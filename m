From: Luca Berra <bluca@comedia.it>
Subject: Re: Making bootable SATA RAID1 array in Mandriva 2006
Date: Tue, 15 Aug 2006 13:48:37 +0200
Message-ID: <20060815114837.GF21221@percy.comedia.it>
References: <44E05576.5050604@aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <44E05576.5050604@aol.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Aug 14, 2006 at 06:50:30AM -0400, andy liebman wrote:
>>>-- I edited fstab and lilo.conf on the the RAID1 "/" partition so that 
>>>they would refer to /dev/md1
>>>-- I ran chroot on the /dev/md1 partition
>>did you mount /dev, /proc and /sys before chrooting?
>>i.e
>>mount --bind /dev /newroot/dev
>>mount -t proc /proc /newroot/proc
>>mount -t sysfs /sys /newroot/sys
>
>Why do I have to do this? I haven't seen this in any "recipies". My 
you need it because mkinitrd will need info from /proc and /sys to work
correctly and lilo will try to access /proc/partitions and /dev/md1 if
your /boot is on /dev/md1.

>Linux setup only has three partitions:   "/", swap, and "/home".
/dev /proc and /sys are not disk based filesystems
/dev is a ram disk which is populated at runtime by udev
/proc and /sys are virtual filesystem that expose some of your hw and
kernel configuration to userspace

>I'm not sure I understand what you're saying about mounting /dev, /proc 
>and /sys.

just run:
mount --bind /dev /newroot/dev
mount -t proc /proc /newroot/proc
mount -t sysfs /sys /newroot/sys
before chrooting

L.
btw, be sure to add "auto=yes" to the ARRAY lines in /etc/mdadm.conf
or you might find some arrays are not recognized after boot.

L.


-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
