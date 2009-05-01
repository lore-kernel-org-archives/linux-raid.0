From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: md extension to support booting from raid whole disks.
Date: Fri, 1 May 2009 14:24:15 -0700
Message-ID: <e9c3a7c20905011424s6c3b3fd6ya563539b3c079d4@mail.gmail.com>
References: <1240574900.4507.2076.camel@ezra>
	 <87hc0axhg9.fsf@frosties.localdomain> <49F68CE0.2010906@zytor.com>
	 <e9c3a7c20904281124g4682d70cp22760176e7a8cfbc@mail.gmail.com>
	 <1240957153.18303.689.camel@ezra>
	 <e9c3a7c20904281526i59983678mb6fbc10e1761d9f1@mail.gmail.com>
	 <87ljpgleku.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87ljpgleku.fsf@frosties.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Cc: Daniel Reurich <daniel@centurion.net.nz>, "H. Peter Anvin" <hpa@zytor.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, May 1, 2009 at 2:04 PM, Goswin von Brederlow <goswin-v-b@web.de> wrote:
> And is horribly ugly when you have to switch hardware. And try doing
> it with disks from different controlers? What bios supports that?

This is just a simple trade-off between two options.

1/ If you want to reliably boot from multiple disks then make a native
md-raid1 array for /boot like hpa suggests.
2/ If you do not want to make /boot into an md-raid1, and you still
want to boot from raid5, then use $VENDOR's raid5 option-rom and
mdadm's external metadata support.

There is no third option with native md-raid5 and grub2 because as
Gabor and hpa point out it is not reliable and will break.

> What bios even supports raid5?

Just look for any off-the-shelf motherboard that says it has onboard
raid5 support and is not using a dedicated hardware raid controller.

Regards,
Dan
