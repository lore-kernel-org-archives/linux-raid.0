From: Neil Brown <neilb@suse.de>
Subject: Re: RAID 6 grow problem
Date: Sun, 3 Jun 2007 08:07:26 +1000
Message-ID: <18017.59934.688277.311357@notabene.brown>
References: <18017.58189.826699.729848@notabene.brown>
	<C287A5E7.7EDA%groups@email.iain.rauch.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Iain Rauch on Saturday June 2
Sender: linux-raid-owner@vger.kernel.org
To: Iain Rauch <groups@email.iain.rauch.co.uk>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, Justin Piszcz <jpiszcz@lucidpixels.com>
List-Id: linux-raid.ids

On Saturday June 2, groups@email.iain.rauch.co.uk wrote:
> > raid6 reshape wasn't added until 2.6.21.  Before that only raid5 was
> > supported.
> > You also need to ensure that CONFIG_MD_RAID5_RESHAPE=y.
> 
> I don't see that in the config. Should I add it? Then reboot?

You reported that you were running a 2.6.20 kernel, which doesn't
support raid6 reshape.
You need to compile a 2.6.21 kernel (or 
   apt-get install linux-image-2.6.21-1-amd64
or whatever) and ensure that CONFIG_MD_RAID5_RESHAPE=y is in the
.config before compiling.

> 
> I used apt-get install mdadm to first install it, which gave me 2.5.x then I
> downloaded the new source and typed make then make install. Now mdadm -V
> shows "mdadm - v2.6.2 - 21st May 2007".
> Is there anyway to check it is installed correctly?

The "mdadm -V" check is sufficient.

NeilBrown
