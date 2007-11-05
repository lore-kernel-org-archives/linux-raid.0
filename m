From: David Greaves <david@dgreaves.com>
Subject: Re: Kernel Module - Raid
Date: Mon, 05 Nov 2007 21:16:58 +0000
Message-ID: <472F884A.4010602@dgreaves.com>
References: <472F7AED.1030207@bradfordnetworks.com> <472F81B9.2070100@dgreaves.com> <472F840F.2060607@bradfordnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <472F840F.2060607@bradfordnetworks.com>
Sender: linux-raid-owner@vger.kernel.org
To: Paul VanGundy <pvangundy@bradfordnetworks.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Paul VanGundy wrote:
> Thanks for the prompt replay David. Below are the answers to your que=
stions:
>=20
>> What hardware/distro etc are you using?
>> Is this an expensive (hundreds of =A3) card? Or an onboard/motherboa=
rd chipset?
> The distro is Suse 10.1.
As a bit of trivia, Neil (who wrote and maintains linux RAID) works for=
 Suse.

> It is an onboard chipset.
In which case it's not likely to be hardware RAID.
See: http://linux-ata.org/faq-sata-raid.html

>> Once you answer this then it may be worth suggesting using sw-raid (=
in which
>> case we can help out) or pointing you elsewhere...
You should probably configure the BIOS to use


>> That's one of the big reasons proprietary drivers suck on linux.
>=20
> Ok. So this chipset has the ability to use an Intel based RAID. Would
> that be better?
mmm, see the link above...

In almost any case where you are considering 'onboard' raid, linux soft=
ware raid
(using md and mdadm) is a better choice.

Start here: http://linux-raid.osdl.org/index.php/Main_Page
(feel free to correct it or ask here for clarification)

Also essential reading is the mdadm man page.

David

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
