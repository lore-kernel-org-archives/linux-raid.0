From: Reindl Harald <h.reindl@thelounge.net>
Subject: Re: mdadm will only start root device degraded
Date: Sat, 12 Aug 2017 16:17:58 +0200
Message-ID: <0ff0c567-8de6-5a15-a37f-29474f9b2b57@thelounge.net>
References: <1502092265.23002.9.camel@fkoop.de>
 <598DF0A1.5030902@youngman.org.uk> <1502529627.31985.2.camel@fkoop.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1502529627.31985.2.camel@fkoop.de>
Content-Language: de-CH
Sender: linux-raid-owner@vger.kernel.org
To: Felix Koop <fdp@fkoop.de>, Wols Lists <antlists@youngman.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Am 12.08.2017 um 11:20 schrieb Felix Koop:
> Hello Wol,
> 
> thanks for trying to help me.
> 
> Yes, md2 is a mirror. Initially it was a mirror of sdf1 and sdg1. Then
> I broke that mirror and reassembled/recreated it as a mirror of sdf1
> and cryptorootg (which is the encrypted device sdg1). After the
> reassembly this worked fine until next reboot. cryprotrootg is unlocked
> during boot, but md2 is not reassembled.
> 
> Is it correct that mirroring (or raid in general) does not work on
> encrypted devices? If so, why?

as already said it makes no sense to encrypt the underlying device - 
frankly in case of a mirror even if it works what is the point to 
encrypt twice instead raid -> luks which first encrypts the data and 
then write the already encrypted data to both mirrors
