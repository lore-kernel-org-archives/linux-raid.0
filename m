From: Wolfgang Denk <wd@denx.de>
Subject: Re: MD RAID6 corrupted by Avago 9260-4i controller [SOLVED]
Date: Mon, 16 May 2016 12:06:42 +0200
Message-ID: <20160516100642.D4B4D10035C@atlas.denx.de>
References: <20160515124534.A42D0100879@atlas.denx.de> <20160515133740.85EC3100879@atlas.denx.de> <20160515153121.GA11365@EIS.leimen.priv> <20160515182524.7B12D100A8E@atlas.denx.de> <20160515183128.GA12823@EIS.leimen.priv> <20160515193516.2C457100879@atlas.denx.de> <20160515203446.GA13218@EIS.leimen.priv> <20160515231046.E3685100A8E@atlas.denx.de> <20160516083903.GA29380@EIS.leimen.priv>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <20160516083903.GA29380@EIS.leimen.priv>
Sender: linux-raid-owner@vger.kernel.org
To: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear Andreas,

In message <20160516083903.GA29380@EIS.leimen.priv> you wrote:
> 
> You are using your disks in alphabetical order, are you sure this is 
> the same order your RAID originally used? Maybe the drive letters 
> changed?

Yes, this is one thing I am absolutely sure about. I have the mapping
of the disk serial numbers from initial install, and I verified that
the drive order is still the same.

> You found LABELONE on sda, which is your first drive (Device Role 0) 
> in your RAID (see mdadm --examine after you create it), but when I 
> create a new RAID based on loop devices, pvcreate and vgcreate it, 
> the LABELONE actually appears on the 2nd drive (Device Role 1).

Thi sis strage; I see you are using 6 disks and the same stripe size,
so I would also expect a layout like yours.  OK, I need to experiment
a bit...

> So I assume in the default left-symmetric layout in RAID6, the first chunk 
> of the first disk actually ends up being a parity chunk...? I'm not too 
> sure about this either right now. ;)

Hm... is --data-offset the only parameter I can play with?  (except for
variations of drive order, which appear to make no sense to me as I'm
sure I have it correct).

Then I could also start a brute force approach and just try out all
possible values until I gind a match ;-)

Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
[Braddock:] Mr. Churchill, you are drunk.
[Churchill:] And you madam, are ugly.  But I shall be sober tomorrow.
