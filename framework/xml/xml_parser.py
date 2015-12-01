from xml.dom.minidom import parseString


data = open("design.xml").read()
dom= parseString(data)
xmlTag = dom.getElementsByTagName('design')[0].toxml()
#print xmlTag



