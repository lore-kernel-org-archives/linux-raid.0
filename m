From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: Swapping out for larger disks
Date: Tue, 08 May 2007 15:28:08 +0400
Message-ID: <46405EC8.4020605@msgid.tls.msk.ru>
References: <464055F5.2090108@wasp.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <464055F5.2090108@wasp.net.au>
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <brad@wasp.net.au>
Cc: RAID Linux <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Brad Campbell wrote:
[]
> It occurs though that the superblocks would be in the wrong place for
> the new drives and I'm wondering if the kernel or mdadm might not find
> them.

I once had a similar issue.  And wrote a tiny program (a hack, sort of),
to read or write md superblock from/to a component device.  The only
thing it really does is to calculate the superblock location - exactly
as it is done in mdadm.  Here it is:

  http://www.corpit.ru/mjt/mdsuper.c

Usage is like:

 mdsuper read /dev/old-device | mdsuper write /dev/new-device

(or using an intermediate file).

So you're doing like this:

 shutdown array
 for i in all-devices-in-array
   dd if=old-device[i] of=new-device[i] iflag=direct oflag=direct
   mdsuper read old-device | mdsuper write new-device
 done
 assemble-array-on-new-devices
 mdadm -G --size=max /dev/mdx

or something like that.

Note that the program does not work for anything but 0.90
superblocks (i haven't used 1.0 superblocks yet - 0.90 works
for me just fine).  However, it should be trivial to extend
it to handle v1 superblocks too.

Note also that it's trivial to do something like that in shell
too, with blockdev --getsz to get the device size, some shell-
style $((math)), and dd magic.

And 3rd note: using direct as above speeds up the copying *alot*,
while keeping system load at zero.  Without direct, one pair of
disks and the system is doing nothing but the copying...

/mjt
