From: Moshe Yudkowsky <moshe@pobox.com>
Subject: Re: RAID needs more to survive a power hit, different /boot layout
 for example (was Re: draft howto on making raids for surviving a disk crash)
Date: Sun, 03 Feb 2008 14:46:54 -0600
Message-ID: <47A6283E.1000706@pobox.com>
References: <47A612BE.5050707@pobox.com> <20080203200150.GB22004@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080203200150.GB22004@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Robin Hill wrote:

> This is wrong - the disk you boot from will always be hd0 (no matter
> what the map file says - that's only used after the system's booted).
> You need to remap the hd0 device for each disk:
> 
> grub --no-floppy <<EOF
> root (hd0,1)
> setup (hd0)
> device (hd0) /dev/sdb
> root (hd0,1)
> setup (hd0)
> device (hd0) /dev/sdc
> root (hd0,1)
> setup (hd0)
> device (hd0) /dev/sdd
> root (hd0,1)
> setup (hd0)
> EOF

For my enlightenment: if the file system is mounted, then hd2,1 is a 
sensible grub operation, isn't it? For the record, given my original 
script when I boot I am able to edit the grub boot options to read

root (hd2,1)

and proceed to boot.


-- 
Moshe Yudkowsky * moshe@pobox.com * www.pobox.com/~moshe
  "I love deadlines... especially the whooshing sound they
   make as they fly past."
    				-- Dermot Dobson
