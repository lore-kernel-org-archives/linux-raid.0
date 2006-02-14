From: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Subject: Lilo append= ,  A suggestion .
Date: Mon, 13 Feb 2006 21:12:42 -0700 (MST)
Message-ID: <Pine.LNX.4.64.0602132106560.2467@filesrv1.baby-dragons.com>
References: <050501c5f2a4$fe72c560$200a11ac@NCNF5131FTH>
 <054001c5f2bc$642a62c0$200a11ac@NCNF5131FTH> <055901c5f30c$282ad520$200a11ac@NCNF5131FTH>
 <058201c5f386$bf23d150$200a11ac@NCNF5131FTH> <17290.11404.619425.81197@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17290.11404.619425.81197@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

 	Hello Neil & All ,
 	I'll bet I am going to get harassed over this , but ...

 	The present form (iirc) of the lilo append statement is

 	append="md=d0,/dev/sda,/dev/sdb"

 	I am wondering how difficult the below would be to code ?
 	This allows a (relatively) short strings to be append'd
 	instead of the sometimes large listing of devices .

 	append="md=d0,UUID=e9e0f605:9ed694c2:3e2002c9:0415c080"

 	Ok ,  I got my asbestos brithes on .  Have at it ;-) .
 		Tia ,  JimL
-- 
+------------------------------------------------------------------+
| James   W.   Laferriere | System    Techniques | Give me VMS     |
| Network        Engineer | 3542 Broken Yoke Dr. |  Give me Linux  |
| babydr@baby-dragons.com | Billings , MT. 59105 |   only  on  AXP |
|  http://www.asteriskhelpdesk.com/cgi-bin/astlance/r.cgi?babydr   |
+------------------------------------------------------------------+
