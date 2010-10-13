From: CoolCold <coolthecold@gmail.com>
Subject: Re: Deadlock in md barrier code? / RAID1 / LVM CoW snapshot + ext3 /
 Debian 5.0 - lenny 2.6.26 kernel
Date: Wed, 13 Oct 2010 17:00:49 +0400
Message-ID: <AANLkTinPF3CeGoe5NxYdfUZcjpO5pvwh0SrC++fZc-fr@mail.gmail.com>
References: <4C938103.1010304@seoss.co.uk>
	<20100918085925.5fee83ee@notabene>
	<4C97BD21.1040405@seoss.co.uk>
	<4C991D61.1040400@seoss.co.uk>
	<20100922083039.283ccdfd@notabene>
	<4CB46B75.8050205@seoss.co.uk>
	<AANLkTi=Ye_74791SUPOj0RhQ+qmHVNPDjHkv-ZdKLXBo@mail.gmail.com>
	<4CB57302.4080409@seoss.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4CB57302.4080409@seoss.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Tim Small <tim@seoss.co.uk>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Oct 13, 2010 at 12:51 PM, Tim Small <tim@seoss.co.uk> wrote:
> Hi,
>
> On 12/10/10 17:48, CoolCold wrote:
>>
>> Just in case you don't know 2.6.26 branch is "frozen, not maintained=
"
>> - http://wiki.openvz.org/Download/kernel/2.6.26/2.6.26-gogol.1
>>
>
> Yep, but that's by OpenVZ, I'm using the Debian kernel, and 2.6.26 is=
 Debian
> stable, and so supported by the Debian kernel team....
well..at least it should

>
>> The only stable for now is 2.6.18& =A02.6.9 , any other is
>> outdated/testing http://wiki.openvz.org/Download/kernel . Ongoin sta=
rt
>> is 2.6.32 as being new RHEL6 kernel. So i'd suggest you to go down t=
o
>> .18 or take .32 from backports.
>>
>
> Once RHEL6 and/or Debian6.0 has been out for a few months, I'll proba=
bly
> switch to 2.6.32, but I don't feel sufficiently confident to do that =
yet
> (not for OpenVZ boxes anyway - OpenVZ+2.6.32 just hasn't had enough
> testing-time yet for production IMO) - I also look after plenty of
> non-openvz 2.6.26 Debian 5.0 boxes, and if this bug is md+lvm+ext3 (w=
hich in
> my semi-educated opinion looks most likely, partly because there have=
 been
> some similar looking deadlocks reported on non-OpenVZ Debian 5.0 syst=
ems),
> then it'd be preferable to track-down the cause of this and get it fi=
xed....
I got your point, good luck! As for me, i've switched to 2.6.32 from
backports, but still has 2.6.18 on openvz boxes.

>
> Cheers,
>
> Tim.
>
> --
> South East Open Source Solutions Limited
> Registered in England and Wales with company number 06134732.
> Registered Office: 2 Powell Gardens, Redhill, Surrey, RH1 1TQ
> VAT number: 900 6633 53 =A0http://seoss.co.uk/ +44-(0)1273-808309
>
>



--=20
Best regards,
[COOLCOLD-RIPN]
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
