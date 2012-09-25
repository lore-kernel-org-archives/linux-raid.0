From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Hello,Re: GPT Table broken on a Raid1
Date: Tue, 25 Sep 2012 10:28:34 +0100
Message-ID: <50617942.4070707@anonymous.org.uk>
References: <4961154.0TR9MeFlIq@techz> <2286535.1cCOBDZvYY@techz> <505B736A-B9FE-4DB5-BA22-FEFDF1F9EE47@colorremedies.com> <5231765.ZMIFzBOKSc@techz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5231765.ZMIFzBOKSc@techz>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?=22G=FCnther_J=2E_Niederwimmer=22?= <gjn@gjn.priv.at>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 25/09/2012 09:27, G=FCnther J. Niederwimmer wrote:
> Am Montag, 24. September 2012, 15:12:22 schrieb Chris Murphy:
>> On Sep 24, 2012, at 3:06 PM, G=FCnther J. Niederwimmer wrote:
[...]
>>> Question: Why create mdadm also a md127, I found this now ?
>>
>> Kernel is mapping /dev/md/Volume0 to /dev/md126. It's doing the same=
 on my
>> system, although it's using md126. Not sure if that's controllable o=
r not.
>> Maybe someone else can answer it.
>
> No Problem, but i tell it to you, for me it is mystery. ;)

It's the way IMSM works. You have md127 which is a "container",=20
essentially spanning all the discs concerned. That container holds one=20
or more RAID sets. You have md126 aka Volume0 as a RAID-1 set that fill=
s=20
the container, but you could have more than one RAID set, e.g. you coul=
d=20
have a RAID-1 as md126 and a RAID-10 as md125.

Cheers,

John.

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
