From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Please review: Slackware RAID How-To
Date: Mon, 17 May 2004 00:51:45 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200405170451.i4H4pqB05999@www.watkins-home.com>
References: <1084761418.1963.11.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1084761418.1963.11.camel@localhost>
To: office@ninti.com.au, 'John Lange' <john.lange@bighostbox.com>
Cc: 'LinuxRaid' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Stride=32

Using the example.  md0 and md1 are RAID1, md2 is RAID5

RAID1 does not have a strip size.  Therefore stride=anything would be wrong,
but may not hurt, not sure.  Filesystem gods watching?

md2 has 4 disks with a chunk size of 128K.  Since only 3 disks are used for
data, and the filesystem block size is 4K, the stride size should be
128*3/4, or 96.
Change:
	mke2fs -b 4096 -R stride=32 /dev/md2
To:
	mke2fs -b 4096 -R stride=96 /dev/md2

Hay, I may be wrong!  I have never noticed the stride option before 5
minutes ago!  10 - 15 minutes now.  Got to type faster! :)

If I misread, or misunderstood anything, please correct me fast!

From "man mke2fs":
stride=stripe-size
      Configure  the  filesystem  for  a  RAID  array with
      stripe-size filesystem blocks per stripe.

My logic:
	"Stripe size" is "chunk size" times "number of data disks".
	From example:
		"chunk size" = 128
		"number of data disks" = "nr-raid-disks" - 1 (-2 if RAID6)

On a related subject...
	I use grub, not lilo!
	Please consider a grub section.
	Is one better than the other?
	The only reason I use grub is 2-3 years ago I was told grub was
newer.

Guy


-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Ninti Systems
Sent: Sunday, May 16, 2004 10:37 PM
To: John Lange
Cc: LinuxRaid
Subject: Re: Please review: Slackware RAID How-To

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

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


