From: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Subject: RE: bonnie++-1.03c -p option problem & ?
Date: Sun, 20 Jul 2008 09:53:42 -0800 (AKDT)
Message-ID: <Pine.LNX.4.64.0807200949410.31215@filesrv1.baby-dragons.com>
References: <200807200510.m6K5A5MD001922@ns3.baby-dragons.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200807200510.m6K5A5MD001922@ns3.baby-dragons.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guy Watkins <linux-raid@watkins-home.com>
Cc: 'linux-raid maillist' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

 	Hello Guy ,

On Sun, 20 Jul 2008, Guy Watkins wrote:
> } -----Original Message-----
> } From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> } owner@vger.kernel.org] On Behalf Of Mr. James W. Laferriere
> } Sent: Saturday, July 19, 2008 1:37 AM
> } To: linux-raid maillist
> } Subject: bonnie++-1.03c -p option problem & ?
> }
> }  	Hello All ,  I know this isn't the proper place to pop this question
> } .
> }  	But it is one place where quite a few have practical experience with
> } bonnie++ .
> }  	When I add the -p option to my bonnie command line all it does is
> } print
> } the uid&gid I am using & dies .  So I think I am doing something wrong
> } somewhere
> } .
> }  	If anyone has ides('s) on the matter to share please pipe up offlies
> } if
> } you desire (I'll compile the result & post) or on list everyone could
> } interested
> } I guess ;-) .
> }  		Tia ,  JimL
> }
> } # bonniemd3() { time /root/bonnie++-1.03c/bonnie++  -u0:0  -d /md3 -x 15 -
> } s 262144 -f -p 4 ; }
> } # bonniemd3 > 131072MB-bonnie++-run-md3-xfs-15runs.log-`date
> } "+%Y%m%d%H%M"`-`uname -r` 2>&1
> } # cat 131072MB-bonnie++-run-md3-xfs-15runs.log-200807190513-2.6.26-rc9
> } Using uid:0, gid:0.
> }
> } real    0m0.012s
> } user    0m0.000s
> } sys     0m0.000s
> } #
> }
> } --
> } +------------------------------------------------------------------+
> } | James   W.   Laferriere | System    Techniques | Give me VMS     |
> } | Network&System Engineer | 2133    McCullam Ave |  Give me Linux  |
> } | babydr@baby-dragons.com | Fairbanks, AK. 99701 |   only  on  AXP |
> } +------------------------------------------------------------------+
>
> If you want to run 5 copies of bonnie++ at the same time you do this:
> bonnie++ -u 0:0 -p 5 # how many to start, a Semaphore is created
> bonnie++ -u 0:0 -y&
> bonnie++ -u 0:0 -y&
> bonnie++ -u 0:0 -y&
> bonnie++ -u 0:0 -y&
> bonnie++ -u 0:0 -y& # This one is the 5th, so all 5 can now start
>
> Just an example.  Use -u how you want.  Hope this helps.
> Guy

 	Your example helped me out a bunch .  I now have 5 bonnie++ processes 
running 15 passes each .  I hope that with multiple processes I can begin to 
tax the sub-systems (ie: scsi, disk, md, ...) and see if the aggregate thruput 
is at or near the advertised thruput(s) .


 		Tnx ,  JimL
-- 
+------------------------------------------------------------------+
| James   W.   Laferriere | System    Techniques | Give me VMS     |
| Network&System Engineer | 2133    McCullam Ave |  Give me Linux  |
| babydr@baby-dragons.com | Fairbanks, AK. 99701 |   only  on  AXP |
+------------------------------------------------------------------+
