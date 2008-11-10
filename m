From: Steve Fairbairn <steve@fairbairn-family.com>
Subject: Re: Recovering RAID-5 from images
Date: Mon, 10 Nov 2008 10:06:39 +0000
Message-ID: <491807AF.7040508@fairbairn-family.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-Raid <linux-raid@vger.kernel.org>
Cc: Stefan Heinrichsen <gelbemauer@gmx.de>
List-Id: linux-raid.ids

Stefan Heinrichsen wrote:
> Hello,
> 
> I have a RAID-5 with 3 devices. One disked failed and I added a new one. During sync a second disc failed. This second "Disc" is a RAID-0 consisting of to 120GB IDE Discs. I handled to dump an image of both disc with ddrescue. Only a few kilobytes of the broken disk could not been read (some where in the middle of the disc).
> For my recovering experiments I made an Image of the remaining disc of the RAID-5 (/dev/loop3). No I tried to assemble the both RAIDs using loopbackdevice. The RAID-0 (/dev/md0) started without any problems. But the RAID-5 is not starting. It seems like both discs are marked as spare (see below).
> 

I'm no md/mdadm expert, but I suspect you first need to stop the
/dev/md0 and restart it as /dev/md1 (I hope you can do that).  The
reason I would do this is that the examines of the array elements you
sent us show that what you have now as /dev/md0 was /dev/md1.

Then you need to force the assembly of the array with just the 2
'working' discs (/dev/loop3 && /dev/md1)

eg. (PLEASE check these with someone else before using them)...

mdadm --stop /dev/d0
mdadm --assemble /dev/md1 <component devices)
mdadm --assemble /dev/<dev> /dev/loop3 /dev/md1 --force

The --force will tell it to ignore that fact that /dev/md1 was marked as
failed and insert it anyway.

Hope this helps,

Steve.

PS.  Sorry for repeat send.  I forgot to include the list address.
