From: Anthony Youngman <antlists@youngman.org.uk>
Subject: Re: mdadm will only start root device degraded
Date: Sat, 12 Aug 2017 18:25:48 +0100
Message-ID: <8a5a5958-b2d6-ee8e-1d06-b61466951bcf@youngman.org.uk>
References: <1502092265.23002.9.camel@fkoop.de>
 <598DF0A1.5030902@youngman.org.uk> <1502529627.31985.2.camel@fkoop.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1502529627.31985.2.camel@fkoop.de>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Felix Koop <fdp@fkoop.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 12/08/17 10:20, Felix Koop wrote:
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
> 
The thing is, which happens first in the boot sequence? Unlocking the 
crypto, or assembling the mirror? Because if the boot attempts to 
assemble the mirror before it unlocks the crypto, this is going to cause 
exactly the scenario you describe.

Cheers,
Wol
