From: Benjammin2068 <benjammin2068@gmail.com>
Subject: Re: Best tool to partition Drives with new sector geometry - (WAS:
 Need Help with crashed RAID5 (that was rebuilding and then had SATA error on
 another drive))
Date: Sun, 18 Sep 2016 13:41:45 -0500
Message-ID: <484e25ca-0a8e-f666-b1c8-ebc92a49f999@gmail.com>
References: <CADDTLRB9z6J0F6+uO3k-u74qnjZxiagbNLWrg_tP5GSZt-Vd5A@mail.gmail.com>
 <CADDTLRBf9NPO6OuF4a3b+xffZgeZRqHRG+pJdPmbc9-Jat0HVQ@mail.gmail.com>
 <d6d3fe0d-3f9f-985f-9bfb-051428cf221b@websitemanagers.com.au>
 <57BBDA5B.3020706@gmail.com> <57BBDC15.5030301@gmail.com>
 <b8c6a380-7e6a-fda9-5834-b85271b26892@websitemanagers.com.au>
 <57BC61F7.8070102@gmail.com>
 <aca4e83f-9a3f-c200-7c16-3b5d9df52c1e@websitemanagers.com.au>
 <57BE450B.4030700@gmail.com>
 <56e86db5-456d-e9c1-339d-ba8903fe5dde@websitemanagers.com.au>
 <57BE52BC.6040908@gmail.com>
 <933228e0-bce4-ffad-f48d-034bf89bc07f@websitemanagers.com.au>
 <57BF9965.1020403@gmail.com> <57C0856D.8050209@youngman.org.uk>
 <57C32D8E.9030102@gmail.com>
 <3b008fb0-1fb3-f12f-d973-3657de6e6923@websitemanagers.com.au>
 <57C38EF5.7020005@gmail.com> <57C41A47.5050506@youngman.org.uk>
 <e6180f36-f246-b4ad-ef53-8012e583b09e@gmail.com>
 <CAJCQCtQAazjCmXfSgbcJNDxtM2pHRcqbmEo1j=Og-dQRPEAzaQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJCQCtQAazjCmXfSgbcJNDxtM2pHRcqbmEo1j=Og-dQRPEAzaQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 09/18/2016 12:50 PM, Chris Murphy wrote:
>
> This is one of the dumbest things, haha. I do not for the life of me
> understand what distribution won't backport this, if they're unwilling
> to put modern tools for modern hardware in their distributions. It's
> one of the simplest, safest backports they could do and yet they
> don't. Incredible to me.

Yeaaaa.... and considering how often I have to do these kinds of installs or admin... it's... well.. yea.


> Any version of gdisk will do this correctly out of the box, so you can
> just install that from your existing old distro presumably. And if you
> can't, then get a recent live CD from pretty much anybody: Fedora 23
> or Fedora 24 has gdisk already on the media, and its version of parted
> and fdisk, also included, all do alignment to 4KiB sectors correctly.
>
> Actually, on either Fedora live media version you can do
>
> dnf install https://kojipkgs.fedoraproject.org//packages/blivet-gui/2.0.1/1.fc25/noarch/blivet-gui-2.0.1-1.fc25.noarch.rpm
>
> Which is the current version, and it will work on F24 for sure and
> maybe/probably F23 also. And dnf will sort out any additional
> dependencies needed. It has a similar gparted style UI, but it will do
> all kinds of wild things: mdadm raid, LVM raid, Btrfs. It'll create
> the partitions, RAID, LV's, file systems, and it will discover things
> already on the drive and properly wipe their signatures with a proper
> tear down before creating the new things. So you don't end up with
> crusty old stuff coming back to haunt you some other day.
>

I'll check - this is CentOS... but I've (as shown in followup email) played with fdisk (which doesn't bother me) and some of the others...

now I just have to sort out this offset issue which I think I'm stuck with due to different partition sizes.

 -Ben

