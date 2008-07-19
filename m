From: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Subject: bonnie++-1.03c -p option problem & ?
Date: Fri, 18 Jul 2008 21:36:46 -0800 (AKDT)
Message-ID: <Pine.LNX.4.64.0807182131420.12086@filesrv1.baby-dragons.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

 	Hello All ,  I know this isn't the proper place to pop this question .
 	But it is one place where quite a few have practical experience with 
bonnie++ .
 	When I add the -p option to my bonnie command line all it does is print 
the uid&gid I am using & dies .  So I think I am doing something wrong somewhere 
.
 	If anyone has ides('s) on the matter to share please pipe up offlies if 
you desire (I'll compile the result & post) or on list everyone could interested 
I guess ;-) .
 		Tia ,  JimL

# bonniemd3() { time /root/bonnie++-1.03c/bonnie++  -u0:0  -d /md3 -x 15 -s 262144 -f -p 4 ; }
# bonniemd3 > 131072MB-bonnie++-run-md3-xfs-15runs.log-`date "+%Y%m%d%H%M"`-`uname -r` 2>&1
# cat 131072MB-bonnie++-run-md3-xfs-15runs.log-200807190513-2.6.26-rc9
Using uid:0, gid:0.

real    0m0.012s
user    0m0.000s
sys     0m0.000s
#

-- 
+------------------------------------------------------------------+
| James   W.   Laferriere | System    Techniques | Give me VMS     |
| Network&System Engineer | 2133    McCullam Ave |  Give me Linux  |
| babydr@baby-dragons.com | Fairbanks, AK. 99701 |   only  on  AXP |
+------------------------------------------------------------------+
