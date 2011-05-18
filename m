From: Gavin Flower <gavinflower@yahoo.com>
Subject: Re: Best way to create RAID-6 for swap partition - existing one failed
Date: Wed, 18 May 2011 13:32:13 -0700 (PDT)
Message-ID: <12577.16388.qm@web65103.mail.ac2.yahoo.com>
References: <1305748642.10481.1.camel@darkside>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1305748642.10481.1.camel@darkside>
Sender: linux-raid-owner@vger.kernel.org
To: likewhoa <likewhoa@weboperative.com>
Cc: linux-raid@vger.kernel.org, neilb@suse.de, mb@gem.win.co.nz
List-Id: linux-raid.ids

--- On Thu, 19/5/11, likewhoa <likewhoa@weboperative.com> wrote:

> From: likewhoa <likewhoa@weboperative.com>
> Subject: Re: Best way to create RAID-6 for swap partition - existing one failed
> To: "Gavin Flower" <gavinflower@yahoo.com>
> Cc: linux-raid@vger.kernel.org
> Date: Thursday, 19 May, 2011, 7:57
> Why not just let the kernel handle
> the stripping for you, IMO using
> dmraid is overkill for swap when it can all be handled by
> the kernel
> itself with 'swap -p1 /dev/sda1' for example.
[...]

Could you please tell where to read up on that, URL or man page.  I do not know where to apply your suggestion, nor the meaning of the '-p1' option.

I should have said the original problem was associated with hibernation.  (I also have 2 other desk tops that don't use RAID for swap.)

For now, I'll leave the swap as is - but, I will rethink how I implement swap when I upgrade to Fedora 15.

