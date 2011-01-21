From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Low cost PCI-E unRAID - Supermicro AOC-SASLP-MV8 Driver/LBA questions
 for HW owners/users
Date: Fri, 21 Jan 2011 13:04:21 -0600
Message-ID: <4D39D8B5.1090901@hardwarefreak.com>
References: <AANLkTimp7xxQTv419oL7x6L-sbrhv1ZcEqLq+CfY6gs5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTimp7xxQTv419oL7x6L-sbrhv1ZcEqLq+CfY6gs5@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Michael Evans put forth on 1/21/2011 10:00 AM:
> The SUPERMICRO AOC-SASLP-MV8 PCI Express x4 Low Profile SAS SAS RAID
> Controller seems to fit my needs and budget except for one glaring
> omission on Supermicro's product page, and every other site that
> blindly copies it.
> 
> Has anyone tested this hardware with a 48-bit LBA required drive (EG
> one of the 3TB drives that still exposes 512k sectors)?

NewEgg has an excellent return policy:
http://www.newegg.com/Product/Product.aspx?Item=N82E16816101358

But, BTW, if you can afford over $1000 of 3TB drives, why are you demanding to
go so cheap with the HBA?  There are plenty of much better LSI based dual
SFF8087 HBAs available with no LBA or driver issues.  For instance:
http://www.newegg.com/Product/Product.aspx?Item=N82E16816117157

$155 Quality/compatible LSI SAS1068E chip+driver vs
$109 Marvell 88SE6480 less than quality chip+driver

If you can afford 5+ 3TB drives you can certainly afford an extra ~$50 for a
decent quality known to work SAS/SATA HBA.  I say 5+ because you're obviously
starting out with 5 or you'd be looking at cards with a single SFF8087, or
simply 4 individual SATA connectors.

I can't imagine an easier decision to make:  $50 for guaranteed piece of mind,
performance, compatibility.

-- 
Stan
