From: John Lange <john.lange@bighostbox.com>
Subject: RE: Please review: Slackware RAID How-To
Date: Wed, 19 May 2004 20:42:29 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1085017348.8670.26.camel@localhost>
References: <200405170451.i4H4pqB05999@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200405170451.i4H4pqB05999@www.watkins-home.com>
To: Guy <bugzilla@watkins-home.com>
Cc: 'LinuxRaid' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, 2004-05-16 at 23:51, Guy wrote:
> md2 has 4 disks with a chunk size of 128K.  Since only 3 disks are used for
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

