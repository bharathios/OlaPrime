//
//  OlaConstants.h
//  OlaPrime
//
//  Created by Bharath Nagaraj Rao on 07/02/15.
//  Copyright (c) 2015 Bharath Nagaraj Rao. All rights reserved.
//

#import <Foundation/Foundation.h>

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:r/255.0 \
green:g/255.0 \
blue:b/255.0 \
alpha:(0xFF)/255.0]

#define FontType(fontName,fontSize) [UIFont fontWithName:@fontName size:fontSize]

//Menu Screens

#define Menu_NavigationBar_Color     RGBCOLOR(42,50,62)
#define Menu_View_Background_Color   RGBCOLOR(42,50,62)

#define Menu_Title_Color             RGBCOLOR(255,255,255)
#define Menu_Title_Font              FontType("Helvetica-Bold",18)

#define Menu_Item_Color              RGBCOLOR(255,255,255)
#define Menu_Item_Selected_Color     RGBCOLOR(35,185,144)
#define Menu_Item_Font               FontType("Helvetica",18)

#define Menu_Cell_Color              RGBCOLOR(42,50,62)
#define Menu_Cell_Selected_Color     RGBCOLOR(27,35,46)
#define Menu_Cell_Seperator_Color    RGBCOLOR(53,64,79)

#define HEIGHT_OF_MENU_TABLE_CELL     60



//About-Us Screens

#define AboutUs_NavigationBar_Color     RGBCOLOR(35,185,144)
#define AboutUs_Menu_Color              RGBCOLOR(255,255,255)
#define AboutUs_View_Background_Color   RGBCOLOR(247,247,247)

#define AboutUs_Title_Color             RGBCOLOR(255,255,255)
#define AboutUs_Title_Font              FontType("Helvetica-Bold",18)

#define AboutUs_Content_Title_Color     RGBCOLOR(19,19,21)
#define AboutUs_Content_Title_Font      FontType("Helvetica-Bold",16)

#define AboutUs_Content_Details_Color   RGBCOLOR(78,74,74)
#define AboutUs_Content_Details_Font    FontType("Helvetica",17)

#define AboutUs_Feedback_Color          RGBCOLOR(78,74,74)
#define AboutUs_Feedback_Font           FontType("Helvetica",17)

#define AboutUs_Facebook_Color          RGBCOLOR(69,97,158)
#define AboutUs_Mail_Color              RGBCOLOR(38,46,56)


//Places Screens

#define Places_NavigationBar_Color     RGBCOLOR(35,185,144)
#define Places_Menu_Color              RGBCOLOR(255,255,255)
#define Places_View_Background_Color   RGBCOLOR(247,247,247)

#define Places_Title_Color             RGBCOLOR(255,255,255)
#define Places_Title_Font              FontType("BrandonGrotesque-Bold",18)

#define Places_Name_Color              RGBCOLOR(35,185,144)
#define Places_Name_Font               FontType("BrandonGrotesque-Bold",16)

#define Places_Details_Color           RGBCOLOR(78,74,74)
#define Places_Details_Font             FontType("BrandonGrotesque-Regular",14)

#define Places_Distance_Color          RGBCOLOR(78,74,74)
#define Places_Distance_Font           FontType("BrandonGrotesque-Regular",12)

#define HEIGHT_OF_PLACES_TABLE_CELL     86



#define HEIGHT_OF_CATEGORY_VIEW                227
#define HEIGHT_OF_RIDE_MENU_VIEW               230
#define HEIGHT_OF_DRIVER_DETAILS_VIEW          380


#define MARATHHALLI_LATITUDE                    12.956868
#define MARATHHALLI_LONGITUDE                   77.701192

#define KM_IN_METERS                            1000

