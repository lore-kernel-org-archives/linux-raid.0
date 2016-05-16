From: Wolfgang Denk <wd@denx.de>
Subject: Re: MD RAID6 corrupted by Avago 9260-4i controller [SOLVED]
Date: Mon, 16 May 2016 14:58:01 +0200
Message-ID: <20160516125801.20A1A100879@atlas.denx.de>
References: <20160515124534.A42D0100879@atlas.denx.de> <20160515133740.85EC3100879@atlas.denx.de> <20160515153121.GA11365@EIS.leimen.priv> <20160515182524.7B12D100A8E@atlas.denx.de> <20160515183128.GA12823@EIS.leimen.priv> <20160515193516.2C457100879@atlas.denx.de> <20160515203446.GA13218@EIS.leimen.priv> <20160515231046.E3685100A8E@atlas.denx.de> <20160516083903.GA29380@EIS.leimen.priv> <20160516120600.5428910035C@atlas.denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <20160516120600.5428910035C@atlas.denx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear Andreas,

In message <20160516120600.5428910035C@atlas.denx.de> I wrote:
> 
...
> OK, so I started playing around with the disk order - even though I
> checked yet another time from the disk serial numbers that the drive
> order "a b c d e f" is what was used when initially creating the
> array. When swapping the first two disks (so sda where the LABELONE
> is present) becomes the second disk (i. e. "b a c d e f"), then LVM
> will recognize the volume group and volumes, but data are corrupted.
> 
> So I guess I have to try the possible permutations (probably with sda
> being the second disk only).

Seems I was lucky - already the second of the 120 possible
combination turned out to be working: b a c d f e

But I still have not the slightest idea why the drive order might have
changed...

Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
Do you suppose the reason the ends of the `Intel Inside'  logo  don't
match up is that it was drawn on a Pentium?
