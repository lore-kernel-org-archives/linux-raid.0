From: Phil Turmel <philip@turmel.org>
Subject: Re: Storage device enumeration script
Date: Thu, 26 May 2011 13:46:59 -0400
Message-ID: <4DDE9213.2070508@turmel.org>
References: <4DDDC301.7090608@turmel.org> <1306403130.9437.109.camel@torbjorn> <4DDE3BF1.7030105@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DDE3BF1.7030105@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?VG9yYmrDuHJuIFNrYWdlc3RhZA==?= <torbjorn@itpas.no>
Cc: linux-raid@vger.kernel.org, Roman Mamedov <roman@rm.pp.ru>, John Robinson <john.robinson@anonymous.org.uk>, CoolCold <coolthecold@gmail.com>, =?UTF-8?B?TWF0aGlhcyBCdXLDqW4=?= <mathias.buren@gmail.com>
List-Id: linux-raid.ids

On 05/26/2011 07:39 AM, Phil Turmel wrote:
> On 05/26/2011 04:11 AM, CoolCold wrote:
>> May be setup some github repo for this?
>>
>=20
> Yes, I'll do this later today.  Obviously needed. :(

Done.  With part of Torbj=C3=B8rn's patch and further fixes as proper c=
ommits.

https://github.com/pturmel/lsdrv

if you just want the latest script:

https://github.com/pturmel/lsdrv/raw/HEAD/lsdrv

Bug reports welcome. Patches, too.

I'm especially interested in users with hardware raid controllers...  n=
ot all of them expose their devices through the SCSI subsystem.  I've a=
n older HP SmartArray here to play with, so I know it basically works. =
 I'm interested in enumerating the physical drives hooked to these cont=
roller subsystems.

Phil
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
