From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Please review: Slackware RAID How-To
Date: Wed, 19 May 2004 23:11:14 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200405200311.i4K3BIB17777@www.watkins-home.com>
References: <1085017348.8670.26.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1085017348.8670.26.camel@localhost>
To: 'John Lange' <john.lange@bighostbox.com>
Cc: 'LinuxRaid' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

The man page says "strip size", not "chunk size", which is correct?

RAID5:
	"strip size" = ("Number of disks in array" - 1) * "chunk size"
RAID6:
	"strip size" = ("Number of disks in array" - 2) * "chunk size"

"Number of disks in array" does not include spares!

It would be GREAT for performance if writes were full strips at a time,
since no reads would be required.

I don't think it would help performance if writes were full chunks at a
time, since the target chunk would still need to be read to compute the
parity chunk.

Any filesystem gods out there?  Any opinions?

Guy


-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of John Lange
Sent: Wednesday, May 19, 2004 9:42 PM
To: Guy
Cc: 'LinuxRaid'
Subject: RE: Please review: Slackware RAID How-To

On Sun, 2004-05-16 at 23:51, Guy wrote:
> md2 has 4 disks with a chunk size of 128K.  Since only 3 disks are used
for
> data, and the filesystem block size is 4K, the stride size should be
> 128*3/4, or 96.
> Change:
> 	mke2fs -b 4096 -R stride=32 /dev/md2
> To:
> 	mke2fs -b 4096 -R stride=96 /dev/md2
> 
> My logic:
> 	"Stripe size" is "chunk size" times "number of data disks".
> 	From example:
> 		"chunk size" = 128
> 		"number of data disks" = "nr-raid-disks" - 1 (-2 if RAID6)

I think this is incorrect. At this point I defer to the
Software-RAID-HOWTO.

http://www.tldp.org/HOWTO/Software-RAID-HOWTO-5.html#ss5.10

From that document stride is chucksize/blocksize . Number of disks does
not enter into it.

So with a chunksize of 128, and a block size of 4 it would be:

128K/4K = 32 for stride.

If this is indeed correct I will be sure to expand that area of the
How-To so it is more clear.

Thanks very much for your feedback.

Regards,

John Lange

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


