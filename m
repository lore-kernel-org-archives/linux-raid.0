From: "Leon Woestenberg" <leon.woestenberg@gmail.com>
Subject: libata hotplug and md raid?
Date: Wed, 13 Sep 2006 12:11:20 +0200
Message-ID: <c384c5ea0609130311t4005e5aam153251fc6bbbdfb8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello all,

I am testing the (work-in-progress / upcoming) libata SATA hotplug.
Hotplugging alone seems to work, but not well in combination with md
RAID.

Here is my report and a question about intended behaviour. Mainstream
2.6.17.11 kernel patched with libata-tj-2.6.17.4-20060710.tar.bz2 from
http://home-tj.org/files/libata-tj-stable/.

Supermicro P8SCT motherboard with Intel ICH6R, using AHCI libata driver.

In short, I use ext3 over /dev/md0 over 4 SATA drives /dev/sd[a-d]
each driven by libata ahci. I unplug then replug the drive that is
rebuilding in RAID-5.

When I unplug a drive, /dev/sda is removed, hotplug seems to work to
the point where proc/mdstat shows the drive failed, but not removed.

Every other notion of the drive (in kernel and udev /dev namespace)
seems to be gone after unplugging. I cannot manually removed the drive
using mdadm, because it tells me the drive does not exist.

Replugging the drive brings it back as /dev/sde, md0 will not pick it up.

The expected behaviour (from me) is that the drive re-appears as /dev/sda.

What is the intended behaviour of md in this case?

Should some user-space application fail-remove a drive as a pre-action
of the unplug event from udev, or should md fully remove the drive
within kernel space??

See kernel/udev/userspace messages in chronological order,
with my actions marked between >>> <<<, at this web
page:

http://pastebin.ca/168798

Thanks,
--
Leon


-- 
Leon
