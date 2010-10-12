From: CoolCold <coolthecold@gmail.com>
Subject: Re: Deadlock in md barrier code? / RAID1 / LVM CoW snapshot + ext3 /
 Debian 5.0 - lenny 2.6.26 kernel
Date: Tue, 12 Oct 2010 20:48:36 +0400
Message-ID: <AANLkTi=Ye_74791SUPOj0RhQ+qmHVNPDjHkv-ZdKLXBo@mail.gmail.com>
References: <4C938103.1010304@seoss.co.uk>
	<20100918085925.5fee83ee@notabene>
	<4C97BD21.1040405@seoss.co.uk>
	<4C991D61.1040400@seoss.co.uk>
	<20100922083039.283ccdfd@notabene>
	<4CB46B75.8050205@seoss.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4CB46B75.8050205@seoss.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Tim Small <tim@seoss.co.uk>
Cc: Neil Brown <neilb@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Oct 12, 2010 at 6:06 PM, Tim Small <tim@seoss.co.uk> wrote:
> Sorry, hit send too soon...
>
>
> On 21/09/10 23:30, Neil Brown wrote:
>>
>> It is odd that 2.6.32 works and 2.6.26 doesn't as I cannot find any =
change
>> between the two that could be related.
>> There were some deadlock issues if a read-error was detected during =
resync
>> but I don't think you are getting read errors are you?
>>
>
> Nope, no read errors.
>
>> A bisect would of course be easier for me, though not particularly e=
asy
>> for
>> you....
>>
>
> I haven't as-yet been able to reproduce the issue without running Ope=
nVZ on
> the box - I suppose the two possibilities are:
>
> 1. The bug is in the OpenVZ patches (seems unlikely given the nature =
of the
> hang, but possible I suppose).
Just in case you don't know 2.6.26 branch is "frozen, not maintained"
- http://wiki.openvz.org/Download/kernel/2.6.26/2.6.26-gogol.1
The only stable for now is 2.6.18 & 2.6.9 , any other is
outdated/testing http://wiki.openvz.org/Download/kernel . Ongoin start
is 2.6.32 as being new RHEL6 kernel. So i'd suggest you to go down to
=2E18 or take .32 from backports.

> 2. The bug is only triggered by the workload which the VZ container i=
s
> producing
>
> ... so without this, a bisect is a non-starter.
>
> Grrr.
>
> Tim.
>
> --
> South East Open Source Solutions Limited
> Registered in England and Wales with company number 06134732.
> Registered Office: 2 Powell Gardens, Redhill, Surrey, RH1 1TQ
> VAT number: 900 6633 53 =A0http://seoss.co.uk/ +44-(0)1273-808309
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Best regards,
[COOLCOLD-RIPN]
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
