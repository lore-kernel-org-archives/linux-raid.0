From: Luca Berra <bluca@comedia.it>
Subject: Re: Booting from a raid1 device ?
Date: Fri, 31 Oct 2003 09:28:42 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20031031082841.GB26757@percy.comedia.it>
References: <E5DA6395B8F9614EB7A784D628184B200E33DE@hdsmsx402.hd.intel.com> <3FA06158.9040007@tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3FA06158.9040007@tls.msk.ru>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Oct 30, 2003 at 03:54:48AM +0300, Michael Tokarev wrote:
>  why the hell a boot loader should "mirror" anything to the second disk? :)
>
>That is.  Place standard MBR into the boot sector.  An MBR that will boot
>from active partition.  Be it e.g. /dev/hda and /dev/hdb.  Create raid1
>device from /dev/hda1 and /dev/hdb1.  Mark both partitions as active.
>And install whatever boot loader you want into /dev/md1 - it will be
>mirrored automatically to /dev/hda1 and /dev/hdb1 (and to whatever else
>disks you'll use).
1) are you really mirroring on the same ide controller?
2) whoever told you that the first 512 bytes of a partition are fair
game? lvm uses those, and IIRC xfs does too.

L.
Btw i recall reading somewhere that grub actually modifies the disk it
is booting from if luser wants to change the kernel command line.
I dunno if it is true or not, and i am too lazy to read the source. Can
anyone confirm or deny that?

L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
