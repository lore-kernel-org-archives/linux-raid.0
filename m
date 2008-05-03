From: Brad Campbell <brad@wasp.net.au>
Subject: Re: Sleeping hard drives in an array?
Date: Sat, 03 May 2008 19:48:56 +0400
Message-ID: <481C8968.4050808@wasp.net.au>
References: <29a863790804300802i358ab6d9t2be907b47176bd5b@mail.gmail.com> <481B836E.6040208@tmr.com> <481B918E.4@panix.com> <A20315AE59B5C34585629E258D76A97C335968@34093-C3-EVS3.exchange.rackspace.com> <481C200E.60907@msgid.tls.msk.ru> <A20315AE59B5C34585629E258D76A97C3359B7@34093-C3-EVS3.exchange.rackspace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A20315AE59B5C34585629E258D76A97C3359B7@34093-C3-EVS3.exchange.rackspace.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Lethe <david@santools.com>
Cc: Michael Tokarev <mjt@tls.msk.ru>, berk walker <berk@panix.com>, Bill Davidsen <davidsen@tmr.com>, Greg Cormier <gcormier@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

David Lethe wrote:

> Then just tweak a few things to take advantage of soft links & the
> ramdisk filesystem for temporary files & scratch space, and such, and
> you get some real performance boosts.  It really is an elegant solution
> that many people should consider as general practice.  For less than the
> price of a disk drive, put the O/S on SSD, then use md exclusively for
> applications. 
> - David @ SANtools ^ com

My storage array boxes are based on Debian. I simply put the *entire* OS into an initramfs that gets 
loaded along with the kernel over PXE. That way the entire rotating media is dedicated to the RAID, 
and the entire OS runs from RAM. Similar but different.

Yeah, the initramfs is 80MB, but with 1.5GB of ram in each box and all on GB ethernet it really 
makes no difference (plus only rebooting about twice a year).

I used to sleep the drives when the array was idle but it interfered with the ability to monitor 
them with smartmontools, and also when doing a read it would spin up the disks one by one as each 
block request was satisfied (which took forever on the 1st read after spindown). I started to build 
some hackery to spin them all up together, then I just gave up and left them rotating.

30,000 hours later I've only had one fail from 30.. (slow grown defects)

Brad
-- 
"Human beings, who are almost unique in having the ability
to learn from the experience of others, are also remarkable
for their apparent disinclination to do so." -- Douglas Adams
