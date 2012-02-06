From: pg@lxra2.for.sabi.co.UK (Peter Grandi)
Subject: Re: Would different hd speeds affect md raid?
Date: Mon, 6 Feb 2012 22:57:02 +0000
Message-ID: <20272.23230.427914.118682@tree.ty.sabi.co.UK>
References: <BLU0-SMTP42258229182D2BB3BC44EB798740@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BLU0-SMTP42258229182D2BB3BC44EB798740@phx.gbl>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> I was just wondering a quick question... If a system had a
> failed 1.5Gbps speed sata (out of 3 in a raid 5)

Congratulations for choosing one of the few good RAID5 setups.

> and it was replaced with a 3Gbps speed drive would the
> difference affect the speed of the raid, or would it be no
> different to its original 3 * 1.5Gbps speed. [ ... ]

The speed of a drive is not the same thing as the speed of the
SATA bus. If your drives are not recent flash SSDs their peak
transfer rates are rather slower than 1.5Gps anyhow.
