From: hansbkk@gmail.com
Subject: Re: Inconsistent UUIDs between mkconf vs blkid
Date: Fri, 4 Feb 2011 21:02:46 +0700
Message-ID: <AANLkTim+7Lvah6vkXByEodhypbN1i5FMhVoG3OM3HTYU@mail.gmail.com>
References: <AANLkTimpqwEoyZTNB+as0UyK8uOAy7P1fihBUBpd1tCs@mail.gmail.com>
	<AANLkTinUsT6XU_9=xLeRK7hMfyM_pQ6a=a74-wjqgeTL@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTinUsT6XU_9=xLeRK7hMfyM_pQ6a=a74-wjqgeTL@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Sorry to be talking to myself here, but wanted to close the issue(s)
out. As a practical matter, some combination of everything I've done
(all mentioned in the above post) has caused Ubuntu to resume booting
without the help of Super Grub2 boot disc.

I would still like feedback on this one:

Q5 I've noticed that my arrays aren't quite as as stable as I'd like,
and I'm wondering if that might be due to the different
flavors/versions of mdadm running? The kernels range from 24 to 35,
and while I'm using .0.90.3 metadata for the boot arrays, I've gone
with 1.2 for the big storage RAID6's.

Lessons I've learned (for future googlers):

Since mkconf is a debian/ubuntu-specific tool, I've decided to use
blkid instead from now on instead.

I now check after --zero-superblock'ing a removed member that the
partition's UUID has been re-set (to something other than the
array's).

I'll still use UUIDs in my mdadm.conf, as one of the "unstable" issues
is my .90 RAID1s getting moved to new preferred-minors, e.g. md1 ->
md1_0. I believe this happens when the kernel is still doing
autoassembly too early in the process, before mdadm's had a chance to
kick in - SystemRescueCD bad (ironically the fix is a boot option
called "nomdadm", but in fact the arrays do still auto-assemble, just
properly this time), Grml handles this properly as is.
