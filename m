From: "David Rees" <drees76@gmail.com>
Subject: Re: RAID 1 and grub
Date: Wed, 30 Jan 2008 18:47:19 -0800
Message-ID: <72dbd3150801301847s6bbfa958h1213e782627e64a1@mail.gmail.com>
References: <47A0F4DC.9030005@sauce.co.nz>
	 <72dbd3150801301641n2801846cgc2f3bc04aa842baf@mail.gmail.com>
	 <47A13379.50703@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47A13379.50703@sauce.co.nz>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Richard Scobie <richard@sauce.co.nz>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Jan 30, 2008 6:33 PM, Richard Scobie <richard@sauce.co.nz> wrote:
> I found this document very useful:
> http://lists.us.dell.com/pipermail/linux-poweredge/2003-July/008898.html
>
> After modifying my grub.conf to refer to (hd0,0), reinstalling grub on
> hdc with:
>
> grub> device (hd0) /dev/hdc
> grub> root (hd0,0)
> grub> (hd0)
>
> and rebooting with the bios set to boot off hdc, everything burst back
> into life.

FWIW, this step is clearly marked in the Software-RAID HOWTO under
"Booting on RAID":
http://tldp.org/HOWTO/Software-RAID-HOWTO-7.html#ss7.3

If it appears that Fedora isn't doing this when installing on a
Software RAID 1 boot device, I suggest you open a bug.

BTW, I suspect you are missing the command "setup" from your 3rd
command above, it should be:

# grub
grub> device (hd0) /dev/hdc
grub> root (hd0,0)
grub> setup (hd0)

> I shall now be checking all my Fedora/Centos RAID1 installs for grub
> installed on both drives.

Good idea. Whenever setting up a RAID1 device to boot from, I perform
the above 3 steps. I also suggest using labels to identify partitions
and testing the two failure modes and that you are able to boot with
either drive disconnected.

-Dave
