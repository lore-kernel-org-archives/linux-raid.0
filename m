From: Moshe Yudkowsky <moshe@pobox.com>
Subject: Re: using update-initramfs: how to get new mdadm.conf into the /boot?
 Or is it XFS?
Date: Mon, 04 Feb 2008 16:59:54 -0600
Message-ID: <47A798EA.40002@pobox.com>
References: <47A77CC0.10807@pobox.com> <20080204222521.GB7162@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080204222521.GB7162@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Robin Hill wrote:

> "File not found" at that point would suggest it can't find the kernel
> file.  The path here should be relative to the root of the partition
> /boot is on, so if your /boot is its own partition then you should
> either use "kernel /vmlinuz...." or (the more usual solution from what
> I've seen) make sure there's a symlink:
>         ln -s . /boot/boot

Robin,

Thanks very much! ln -s . /boot/boot works to get past this problem.

Now it's failed in a different section and complains that it can't find 
/sbin/init. I'm at the (initramfs) prompt, which I don't ever recall 
seeing before. I can't  mount /dev/md/root on any mount points ("invalid 
arguments" even though I'm not supplying any). I've checked /dev/md/root 
and it does work as expected when I try mounting it while in my 
emergency partition, and it does contain /sbin/init and the other files 
and mount points for /var, /boot, /tmp, etc.

So this leads me to the question of why /sbin isn't being seen. /sbin is 
on the device /dev/md/root, and /etc/fstab specifically mounts it at /. 
  I would think /boot would look at an internal copy of /etc/fstab. Is 
this another side effect of using /boot on its own partition?

-- 
Moshe Yudkowsky * moshe@pobox.com * www.pobox.com/~moshe
  "Blessed are the peacemakers,
   for they shall be mowed down in the crossfire."
    				-- Michael Flynn
