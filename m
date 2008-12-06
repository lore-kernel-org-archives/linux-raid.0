From: Michal Soltys <soltys@ziu.info>
Subject: Re: time limited error recovery and md raid
Date: Sat, 06 Dec 2008 11:32:23 +0100
Message-ID: <493A54B7.7070805@ziu.info>
References: <1228510646.16555.73.camel@localhost>  <alpine.DEB.1.10.0812051600410.17806@p34.internal.lan> <1228511266.16555.81.camel@localhost> <alpine.DEB.1.10.0812051609070.17806@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0812051609070.17806@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Redeeman <redeeman@metanurb.dk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Justin Piszcz wrote:
> 
>> when tler is on, why does linux not attempt to remap the sector?
> See my earlier posts on this question from last week.  It would need a 
> metadata section on each HDD to keep track of the bad sectors before it 
> writes to the drives, a 3ware card will do this for you-- however, 
> typically, (having run md/linux) for a number of years is not 
> super-necessary if you run checks on your disks once a week *AND* you 
> have good drives that don't have problems.
> 

 From what I know, md does attempt to repair read errors (but not other 
ones though) with rewrite, and only if it fails, it will kick the drive 
out of the array. In case of 1.x superblocks, the count of repaired (+ 
ones not causing drive to be kicked off) sectors will be preserved 
across reboots as well (check Documentation/md.txt). Peeking over the 
code seems to confirm it as well.

It was on Neil's todo list, and it got implemented a while ago, afaik. 
There was a short discussion on smartmon mailing list recently:

http://sourceforge.net/mailarchive/forum.php?thread_name=VA.00003465.16ed4a93%40news.conactive.com&forum_name=smartmontools-support

There was no 100% answer there either though.

Neil ?
