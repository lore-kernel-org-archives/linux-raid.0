From: Ninti Systems <office@ninti.com.au>
Subject: Re: Please review: Slackware RAID How-To
Date: 17 May 2004 12:06:59 +0930
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1084761418.1963.11.camel@localhost>
References: <1084290138.25942.30.camel@ws101.darkcore.net>
Reply-To: office@ninti.com.au
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1084290138.25942.30.camel@ws101.darkcore.net>
To: John Lange <john.lange@bighostbox.com>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

If at first you don't succeed ...

Success at last, or so it seems. The new sections on lilo were quite
helpful, I could have used even more hand-holding on the whole lilo
thing (MBR vs root, etc), though I suppose that is a different topic
really. 

One of my problems previously was that the box didn't have a floppy
drive, so a boot disk wasn't an option for changing lilo.conf.

Also, this time I formatted with mke2fs rather than letting setup do it,
as you suggest.

I'm wondering, is the stride=32 parameter to mke2fs necessary for RAID1
arrays? I used it anyway.

If I were to suggest any new info to be included in the HOW-TO, maybe
the setup of simple RAID1 with two disks could be explicitly addressed
as well. Perhaps this could then lead onto RAID5 setup.

Anyway, thanks a lot John, I've still got a lot to learn, but this is a
great start.

Mick


On Wed, 2004-05-12 at 01:12, John Lange wrote:
> As mentioned, I have created a Slackware RAID How-To and an initial
> draft is located here:
> 
> http://www.langefamily.ca/howto/SlackwareRaidHowTo.html
> 
> This document covers getting Slackware installed on a system with RAID.
> This technique does not require a temporary hard drive or anything other
> than a Slackware boot CD.
> 
> I am fairly new to linux software RAID so I really hope some more
> experienced people will take some time to read it and give me some
> feedback. I would hate to have some glaring errors inflicted on others!
> 
> Thanks.
-- 
--------------------------------------
Ninti Systems: Smart IT Solutions
Michael Hall
Mobile: 0429 095 392
Ph/Fax: 08 8953 1442       
Email:  office at ninti dot com dot au
Web:    http://ninti.com.au
--------------------------------------

