From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: md extension to support booting from raid whole disks.
Date: Sat, 02 May 2009 00:33:01 +0200
Message-ID: <87r5z8jvxe.fsf@frosties.localdomain>
References: <1240574900.4507.2076.camel@ezra>
	<87hc0axhg9.fsf@frosties.localdomain> <49F68CE0.2010906@zytor.com>
	<e9c3a7c20904281124g4682d70cp22760176e7a8cfbc@mail.gmail.com>
	<1240957153.18303.689.camel@ezra>
	<e9c3a7c20904281526i59983678mb6fbc10e1761d9f1@mail.gmail.com>
	<87ljpgleku.fsf@frosties.localdomain>
	<e9c3a7c20905011424s6c3b3fd6ya563539b3c079d4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e9c3a7c20905011424s6c3b3fd6ya563539b3c079d4@mail.gmail.com> (Dan
	Williams's message of "Fri, 1 May 2009 14:24:15 -0700")
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Goswin von Brederlow <goswin-v-b@web.de>, Daniel Reurich <daniel@centurion.net.nz>, "H. Peter Anvin" <hpa@zytor.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dan Williams <dan.j.williams@intel.com> writes:

> On Fri, May 1, 2009 at 2:04 PM, Goswin von Brederlow <goswin-v-b@web.de> wrote:
>> And is horribly ugly when you have to switch hardware. And try doing
>> it with disks from different controlers? What bios supports that?
>
> This is just a simple trade-off between two options.
>
> 1/ If you want to reliably boot from multiple disks then make a native
> md-raid1 array for /boot like hpa suggests.

Which still has the same problems as the raid5. How to handle the
bootloader. Say I have a raid1 over sda/b with lvm on it. How do I
boot that? How do I get the bootloader cloned to a new spare disk when
it gets added?

It realy makes no difference if it is a raid0/1/10/4/5/6.

> 2/ If you do not want to make /boot into an md-raid1, and you still
> want to boot from raid5, then use $VENDOR's raid5 option-rom and
> mdadm's external metadata support.

There is no such thing as $VENDOR's raid5 option-rom in pretty much
all cases. And even raid0/1 roms are horribly.

> There is no third option with native md-raid5 and grub2 because as
> Gabor and hpa point out it is not reliable and will break.

And they can still be wrong.

>> What bios even supports raid5?
>
> Just look for any off-the-shelf motherboard that says it has onboard
> raid5 support and is not using a dedicated hardware raid controller.
>
> Regards,
> Dan

MfG
        Goswin
