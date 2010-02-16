From: Neil Brown <neilb@suse.de>
Subject: Re: Linux mdadm superblock question.
Date: Tue, 16 Feb 2010 11:27:08 +1100
Message-ID: <20100216112708.4a863f86@notabene.brown>
References: <alpine.DEB.2.00.1002111758350.12031@p34.internal.lan>
	<4877c76c1002111752h23e14f7aibe58a89181e6f493@mail.gmail.com>
	<4B77044B.1020609@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4B77044B.1020609@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Michael Evans <mjevans1983@gmail.com>, Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 13 Feb 2010 11:58:03 -0800
"H. Peter Anvin" <hpa@zytor.com> wrote:

> On 02/11/2010 05:52 PM, Michael Evans wrote:
> > On Thu, Feb 11, 2010 at 3:00 PM, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
> >> Hi,
> >>
> >> I may be converting a host to ext4 and was curious, is 0.90 still the only
> >> superblock version for mdadm/raid-1 that you can boot from without having to
> >> create an initrd/etc?
> >>
> >> Are there any benefits to using a superblock > 0.90 for a raid-1 boot volume
> >> < 2TB?
> >>
> >> Justin.
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>
> > 
> > You need the superblock at the end of the partition:  If you read the
> > manual that is clearly either version 0.90 OR 1.0 (NOT 1.1 and also
> > NOT 1.2; those use the same superblock layout but different
> > locations).
> 
> 0.9 has the *serious* problem that it is hard to distinguish a whole-volume
> 
> However, apparently mdadm recently switched to a 1.1 default.  I
> strongly urge Neil to change that to either 1.0 and 1.2, as I have
> started to get complaints from users that they have made RAID volumes
> with newer mdadm which apparently default to 1.1, and then want to boot
> from them (without playing MBR games like Grub does.)  I have to tell
> them that they have to regenerate their disks -- the superblock occupies
> the boot sector and there is nothing I can do about it.  It's the same
> pathology XFS has.

When mdadm defaults to 1.0 for a RAID1 it prints a warning to the effect that
the array might not be suitable to store '/boot', and requests confirmation.

So I assume that the people who are having this problem either do not read,
or are using some partitioning tool that runs mdadm under the hood using
"--run" to avoid the need for confirmation.  It would be nice to confirm if
that was the case, and find out what tool is being used.

If an array is not being used for /boot (or /) then I still think that 1.1 is
the better choice as it removes the possibility for confusion over partition
tables.

I guess I could try defaulting to 1.2 in a partition, and 1.1 on a
whole-device.  That might be a suitable compromise.

How do people cope with XFS??

NeilBrown
