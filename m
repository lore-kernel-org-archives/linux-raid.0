From: Iain Rauch <groups@email.iain.rauch.co.uk>
Subject: Re: RAID 6 grow problem
Date: Sat, 02 Jun 2007 22:55:35 +0100
Message-ID: <C287A5E7.7EDA%groups@email.iain.rauch.co.uk>
References: <18017.58189.826699.729848@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18017.58189.826699.729848@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, Justin Piszcz <jpiszcz@lucidpixels.com>
List-Id: linux-raid.ids

> raid6 reshape wasn't added until 2.6.21.  Before that only raid5 was
> supported.
> You also need to ensure that CONFIG_MD_RAID5_RESHAPE=y.

I don't see that in the config. Should I add it? Then reboot?

I used apt-get install mdadm to first install it, which gave me 2.5.x then I
downloaded the new source and typed make then make install. Now mdadm -V
shows "mdadm - v2.6.2 - 21st May 2007".
Is there anyway to check it is installed correctly?


Iain


