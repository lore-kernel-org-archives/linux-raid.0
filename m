From: David Greaves <david@dgreaves.com>
Subject: Re: md reports: unknown partition table - fixed.
Date: Tue, 18 Jul 2006 19:37:46 +0100
Message-ID: <44BD2A7A.5040906@dgreaves.com>
References: <44BD0FC3.3010304@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <44BD0FC3.3010304@dgreaves.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

David Greaves wrote:
> Hi
> 
> After a powercut I'm trying to mount an array and failing :(

A reboot after tidying up /dev/ fixed it.

The first time through I'd forgotten to update the boot scripts and they
were assembling the wrong UUID. That was fine; I realised this and ran
the manual assemble:

  mdadm --assemble /dev/media /dev/sd[bcdef]1
  dmesg
  cat /proc/mdstat

All OK (but I'd forgotten that this was a partitioned array). I suspect
the device entries for /dev/media[1234] from last time were hanging about.

  mount /media
  fdisk /dev/media
So I guess this fails because the major-minor are for a non-p md device?

  mdadm --assemble /dev/media --auto=p /dev/sd[bcdef]1
  mdadm --stop /dev/media
This fails because I'm on mdadm 2.4.1

  mdadm --assemble /dev/media --auto=p /dev/sd[bcdef]1
  cat /proc/mdstat
  mdadm --stop /dev/md_d0
  mdadm --stop /dev/md0
  cat /proc/mdstat
So by now I upgrade to mdadm 2.5.1 in another session.

  mdadm --stop /dev/media
  dmesg
  cat /proc/mdstat
and it stops.

  mdadm --assemble /dev/media --auto=p /dev/sd[bcdef]1
But now it won't create working devices...

Much messing about with assemble and I try a kernel upgrade - can't
because the driver for my video card won't compile under 2.6.17 yet so
WTF, I suspect major/minor numbers so just reboot it under the same kernel.

All seems well.

I think there's a bug here somewhere. I wonder/suspect that the
superblock should contain the fact that it's a partitioned/able md device?

David

-- 

