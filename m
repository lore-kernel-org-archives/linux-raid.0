From: "David Rees" <drees76@gmail.com>
Subject: Re: RAID 1 and grub
Date: Wed, 30 Jan 2008 16:41:15 -0800
Message-ID: <72dbd3150801301641n2801846cgc2f3bc04aa842baf@mail.gmail.com>
References: <47A0F4DC.9030005@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47A0F4DC.9030005@sauce.co.nz>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Richard Scobie <richard@sauce.co.nz>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Jan 30, 2008 2:06 PM, Richard Scobie <richard@sauce.co.nz> wrote:
> hda has failed and after spending some time with a rescue disk mounting
> hdc's /boot partition (hdc1) and changing the grub.conf device
> parameters, I have no success in booting off it.
>
> I then set them back to the original (hd0,0) and moved hdc into hda's
> position.
>
> Booting from there brings up the message: GRUB hard disk error

Have you tried re-running grub-install after booting from a rescue disk?

-Dave
