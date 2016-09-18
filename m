From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Best tool to partition Drives with new sector geometry - (WAS:
 Need Help with crashed RAID5 (that was rebuilding and then had SATA error on
 another drive))
Date: Sun, 18 Sep 2016 20:17:39 +0100
Message-ID: <57DEE853.4060001@youngman.org.uk>
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
 <484e25ca-0a8e-f666-b1c8-ebc92a49f999@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <484e25ca-0a8e-f666-b1c8-ebc92a49f999@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Benjammin2068 <benjammin2068@gmail.com>, Chris Murphy <lists@colorremedies.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 18/09/16 19:41, Benjammin2068 wrote:
> I'll check - this is CentOS... but I've (as shown in followup email) played with fdisk (which doesn't bother me) and some of the others...
> 
> now I just have to sort out this offset issue which I think I'm stuck with due to different partition sizes.

Don't quite understand what you're trying to do, but ...

I'm sure you know this, but getting the physical/logical block size
out-of-sync hurts disk performance. And copying a smaller partition into
a larger allocated space is perfectly harmless. So...

I'd simply use a modern partition manager (such as gdisk) to partition
your new drives such that the new partitions are larger than the
existing ones, and are properly aligned relative to the drive geometry.

Then copy the old partitions across however you were planning - whether
it's "mdadm --replace" or stopping the array and "dd old-device
new-device" or whatever.

If you've got a bit of wasted space, or whatever, who cares.
You can resize your file-systems to use all available space, if you wish
(can't remember how, whenever I've done that sort of stuff it hasn't
been hard).

But I'd certainly try and avoid those offset warnings - it smacks to me
of a mismatch between 512-byte blocks and 4K disk sectors, and I
wouldn't want the drive firmware messing about correcting mismatches
between OS 4K blocks and drive 4K blocks. I don't fully understand it
but I know there was a lot of grief with exactly this sort of thing in
the transition from 512-byte to 4K.

Cheers,
Wol
