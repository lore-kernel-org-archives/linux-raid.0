From: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Subject: Re: RAID 16?
Date: Thu, 2 Feb 2006 09:44:36 -0700 (MST)
Message-ID: <Pine.LNX.4.64.0602020942220.1426@filesrv1.baby-dragons.com>
References: <43E19FAB.4000603@cogweb.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <43E19FAB.4000603@cogweb.net>
Sender: linux-raid-owner@vger.kernel.org
To: David Liontooth <liontooth@cogweb.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

 	Hello David ,

On Wed, 1 Feb 2006, David Liontooth wrote:
> We're wondering if it's possible to run the following --
>
>  * define 4 pairs of RAID 1 with an 8-port 3ware 9500S card
>  * the OS will see these are four normal drives
>  * use md to configure them into a RAID 6 array
>
> Would this work? Would it be better than RAID 15? We're looking for a
> very high redundancy system.
>
> This is on a Debian system running the 2.6 kernel. We're contemplating
> running EVMS on top.
 	I happen to agree with the person that said (something like ,
 	"keep as few software layers between you & the devices ."
 	That said why do a raid1 into a raid6 ?
 	Why not a 2 raid6 arrays raid1'd ?
 	A thought .  Hth ,  JimL
-- 
+------------------------------------------------------------------+
| James   W.   Laferriere | System    Techniques | Give me VMS     |
| Network        Engineer | 3542 Broken Yoke Dr. |  Give me Linux  |
| babydr@baby-dragons.com | Billings , MT. 59105 |   only  on  AXP |
|  http://www.asteriskhelpdesk.com/cgi-bin/astlance/r.cgi?babydr   |
+------------------------------------------------------------------+
