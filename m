From: Luca Berra <bluca@comedia.it>
Subject: Re: Time to  deprecate old RAID formats?
Date: Fri, 26 Oct 2007 11:54:18 +0200
Message-ID: <20071026095417.GC32550@percy.comedia.it>
References: <Pine.LNX.4.64.0710191109000.27246@p34.internal.lan> <18200.53593.687483.120827@stoffel.org> <1192810534.1666.68.camel@firewall.xsintricity.com> <18200.56684.14194.630264@stoffel.org> <1192813877.1666.79.camel@firewall.xsintricity.com> <18200.63987.514073.184865@stoffel.org> <20071019212303.GB2013@teal.hq.k1024.org> <1192830129.1666.103.camel@firewall.xsintricity.com> <20071020075349.GA17431@teal.hq.k1024.org> <1192885917.1666.112.camel@firewall.xsintricity.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1192885917.1666.112.camel@firewall.xsintricity.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Oct 20, 2007 at 09:11:57AM -0400, Doug Ledford wrote:
>On Sat, 2007-10-20 at 09:53 +0200, Iustin Pop wrote:
>
>> Honestly, I don't see how a properly configured system would start
>> looking at the physical device by mistake. I suppose it's possible, but
>> I didn't have this issue.
>
>Mount by label support scans all devices in /proc/partitions looking for
>the filesystem superblock that has the label you are trying to mount.
it could probably be smarter, but in any case there is no point in
mounting by label an md device.
>LVM (unless told not to) scans all devices in /proc/partitions looking
yes, but lvm unless told to, will ignore devices having a valid md
superblock.
>for valid LVM superblocks.  In fact, you can't build a linux system that
>is resilient to device name changes without doing that.
i dislike labels, especially for devices that contain the os. we should
ensure great care that these are identified correctly, and
mount-by-label does not (usb drive that migrate from one system to
another are so common that you can't ignore them)

you forgot udev ;)

but the fix is easy.
remove the partition detection code from the kernel and start working on
a smart userspace replacement for device detection. we already have
vol_id from udev and blkid from ext3 which support detection of many
device formats.
just apply some rules, so if you find a partition table _AND_ an md
superblock at the end, read both and you can tell if it is an md on a
partition or a partitioned md raid1 device.

>And you can with superblock at the front.  You can create a new single
>disk raid1 over the existing superblock or you can munge the partition
>table to have it point at the start of your data.  There are options,
Please don't do that,
use device-mapper to set the device up, without mucking with partition
tables.

L.


-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
