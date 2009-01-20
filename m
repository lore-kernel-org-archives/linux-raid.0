From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Corrupt data - RAID sata_sil 3114 chip
Date: Mon, 19 Jan 2009 20:50:06 -0600
Message-ID: <49753BDE.8050403@shaw.ca>
References: <200901032104.15242.bs@q-leap.de> <496436C4.4070305@kernel.org> <49643FD4.9080100@shaw.ca> <200901071632.02264.bs@q-leap.de> <49693E08.3050209@shaw.ca> <49694094.60501@shaw.ca> <496A9D42.4000302@kernel.org> <20090119184304.GB30365@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090119184304.GB30365@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dave Jones <davej@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Bernd Schubert <bs@q-leap.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Justin Piszcz <jpiszcz@lucidpixels.com>, debian-user@lists.debian.org, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-raid.ids

Dave Jones wrote:
> On Mon, Jan 12, 2009 at 10:30:42AM +0900, Tejun Heo wrote:
>  > Robert Hancock wrote:
>  > >> There are apparently some reports of issues on NVidia chipsets as
>  > >> well, though I don't have any details at hand.
>  > > 
>  > > Well, Carlos' email bounces, so much for that one. Anyone have any other
>  > > contacts at Silicon Image?
>  > 
>  > I'll ping my SIMG contacts but I've pinged about this problem in the
>  > past but it didn't get anywhere.
> 
> I wish I'd read this thread last week.. I've been beating my head
> against this problem all weekend.
> 
> I picked up a cheap 3114 card, and found that when I created a filesystem
> with it on a 250GB disk, it got massive corruption very quickly.
> 
> My experience echos most the other peoples in this thread, but here's
> a few data points I've been able to figure out..
> 
> I ran badblocks -v -w -s on the disk, and after running
> for nearly 24 hours, it reported a huge number of blocks
> failing at the upper part of the disk.
> 
> I created a partition in this bad area to speed up testing..
> 
>    Device Boot      Start         End	   Blocks   Id  System
> /dev/sde1               1	30000   240974968+  83  Linux
> /dev/sde2           30001	30200     1606500   83  Linux
> /dev/sde3           30201	30401     1614532+  83  Linux
> 
> Rerunning badblocks on /dev/sde2 consistently fails when
> it gets to the reading back 0x00 stage.
> (Somehow it passes reading back 0xff, 0xaa and 0x55)
> 
> I was beginning to suspect the disk may be bad, but when I
> moved it to a box with Intel sata, the badblocks run on that
> same partition succeeds with no problems at all.
> 
> Given the corruption happens at high block numbers, I'm wondering
> if maybe there's some kind of wraparound bug happening here.
> (Though why only the 0x00 pattern fails would still be a mystery).

Yeah, that seems a bit bizarre.. Apparently somehow zeros are being 
converted into non-zero.. Can you try zeroing out the partition by 
dd'ing into it from /dev/zero or something, then dumping it back out to 
see what kind of data is showing up?

> 
> 
> After reading about the firmware update fixing it, I thought I'd
> give that a shot.  This was pretty much complete fail.
> 
> The DOS utility for flashing claims I'm running BIOS 5.0.39,
> which looking at http://www.siliconimage.com/support/searchresults.aspx?pid=28&cat=15
> is quite ancient.  So I tried the newer ones.
> Same experience with both 5.4.0.3, and 5.0.73
> 
> "BIOS version in the input file is not a newer version"
> 
> Forcing it to write anyway gets..
> 
> "Data is different at address 65f6h"
> 
> 
> 
> 
> 	Dave 
> 
> 
