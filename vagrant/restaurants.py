from BaseHTTPServer import BaseHTTPRequestHandler, HTTPServer
from sqlalchemy import create_engine
from database_setup import Base, Restaurant, MenuItem
from sqlalchemy.orm import sessionmaker
import cgi

engine = create_engine('sqlite:///restaurantmenu.db')
Base.metadata.bind = engine
DBSession = sessionmaker(bind = engine)
session = DBSession()

class WebServerHandler(BaseHTTPRequestHandler):
    
    def do_GET(self):
        if self.path.endswith("/delete"):
            restaurantIDPath = self.path.split("/")[2]
            myRestaurantQuery = session.query(Restaurant).filter_by(id = restaurantIDPath).one()
            if myRestaurantQuery:
                self.send_response(200)
                self.send_header('Content-type', 'text/html')
                self.end_headers()
                output = "<html><body>"
                output += "<h2>Delete "+myRestaurantQuery.name+" ?</h2>"
                output += "<form method = 'POST' enctype='multipart/form-data' action = '/restaurants/%s/delete'>" % restaurantIDPath
                #output += "<label for='newRestaurantName'>Restaurant Name</label><input type='text' name='newRestaurantName' placeholder = '%s' >" % myRestaurantQuery.name"<input type='submit' value='Rename'>"
                output += "<input name = 'newRestaurantName' type='text' placeholder = '%s' >" % myRestaurantQuery.name
                output += "<input type = 'submit' value = 'Yes'>"
                output += "<a href='/restaurants'><input type = 'button' value = 'No'></a>"
                output += "</form>"
                output += "</body></html>"
                self.wfile.write(output)
                return

        if self.path.endswith("/edit"):
            restaurantIDPath = self.path.split("/")[2]
            myRestaurantQuery = session.query(Restaurant).filter_by(id = restaurantIDPath).one()
            if myRestaurantQuery:
                self.send_response(200)
                self.send_header('Content-type', 'text/html')
                self.end_headers()
                output = "<html><body>"
                output += "<h2>"+myRestaurantQuery.name+"</h2>"
                output += "<form method = 'POST' enctype='multipart/form-data' action = '/restaurants/%s/edit'>" % restaurantIDPath
                #output += "<label for='newRestaurantName'>Restaurant Name</label><input type='text' name='newRestaurantName' placeholder = '%s' >" % myRestaurantQuery.name"<input type='submit' value='Rename'>"
                output += "<input name = 'newRestaurantName' type='text' placeholder = '%s' >" % myRestaurantQuery.name
                output += "<input type = 'submit' value = 'Rename'>"
                output += "</form>"
                output += "</body></html>"
                self.wfile.write(output)
                return

        if self.path.endswith("/restaurants/new"):
            self.send_response(200)
            self.send_header('Content-type', 'text/html')
            self.end_headers()
            output = ""
            output += "<html><body>"
            output += "<h2>Make a New Restaurant</h2>"
            output += "<form method = 'POST' enctype='multipart/form-data' action = '/restaurants/new'>"
            output += "<input type='text' name='newRestaurantName'><input type='submit'>"
            output += "</form>"
            output += "</body></html>"
            self.wfile.write(output)
            return

        if self.path.endswith("/restaurants"):
            restaurants = session.query(Restaurant).all()
            self.send_response(200)
            self.send_header('Content-type', 'text/html')
            self.end_headers()
            output = ""
            output += "<html><body>"
            output += "<h3>Make a New Restaurant <a href = '/restaurants/new' >Here</a></h3></br></br>"
            for restaurant in restaurants:
                output += restaurant.name
                output += "</br>"
                output += "<a href='/restaurants/%s/edit' >Edit </a>" % restaurant.id
                output += "</br>"
                output += "<a href ='/restaurants/%s/delete'> Delete </a>" % restaurant.id
                output += "</br></br>"

            output += "</body></html>"
            self.wfile.write(output)
            return
        else:
            self.send_error(404, 'File Not Found: %s' % self.path)

    def do_POST(self):
        try:
            if self.path.endswith("/delete"):
                ctype, pdict = cgi.parse_header(
                    self.headers.getheader('content-type'))
                if ctype == 'multipart/form-data':
                    fields = cgi.parse_multipart(self.rfile, pdict)
                    messagecontent = fields.get('newRestaurantName')
                    restaurantIDPath = self.path.split("/")[2]
                    myRestaurantQuery = session.query(Restaurant).filter_by(id = restaurantIDPath).one()
                    if myRestaurantQuery != [] :
                        myRestaurantQuery.name = messagecontent[0]
                        session.delete(myRestaurantQuery)
                        session.commit()    
                    # Create edited Restaurant Object
                        self.send_response(301)
                        self.send_header('Content-type', 'text/html')
                        self.send_header('Location', '/restaurants')
                        self.end_headers()

            if self.path.endswith("/edit"):
                ctype, pdict = cgi.parse_header(
                    self.headers.getheader('content-type'))
                if ctype == 'multipart/form-data':
                    fields = cgi.parse_multipart(self.rfile, pdict)
                    messagecontent = fields.get('newRestaurantName')
                    restaurantIDPath = self.path.split("/")[2]
                    myRestaurantQuery = session.query(Restaurant).filter_by(id = restaurantIDPath).one()
                    if myRestaurantQuery != [] :
                        myRestaurantQuery.name = messagecontent[0]
                        session.add(myRestaurantQuery)
                        session.commit()    
                    # Create edited Restaurant Object
                        self.send_response(301)
                        self.send_header('Content-type', 'text/html')
                        self.send_header('Location', '/restaurants')
                        self.end_headers()

            if self.path.endswith("/restaurants/new"):
                ctype, pdict = cgi.parse_header(
                    self.headers.getheader('content-type'))
                if ctype == 'multipart/form-data':
                    fields = cgi.parse_multipart(self.rfile, pdict)
                    messagecontent = fields.get('newRestaurantName')

                    # Create new Restaurant Object
                    newRestaurant = Restaurant(name=messagecontent[0])
                    session.add(newRestaurant)
                    session.commit()

                    self.send_response(301)
                    self.send_header('Content-type', 'text/html')
                    self.send_header('Location', '/restaurants')
                    self.end_headers()

        except:
            pass

def main():
    try:
        port = 8080
        server = HTTPServer(('', port), WebServerHandler)
        print "Web Server running on port %s" % port
        server.serve_forever()
    except KeyboardInterrupt:
        print " ^C entered, stopping web server...."
        server.socket.close()

if __name__ == '__main__':
    main()