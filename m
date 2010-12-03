From: =?ISO-8859-1?Q?Stefan_H=FCbner?=
	<stefan.huebner@stud.tu-ilmenau.de>
Subject: Re: turn off auto assembly
Date: Fri, 03 Dec 2010 02:24:02 +0100
Message-ID: <4CF846B2.8040001@stud.tu-ilmenau.de>
References: <4CF7F369.4090303@stud.tu-ilmenau.de> <slrnifg359.9qh.Mario.Holbe@darkside.dyn.samba-tng.org>
Reply-To: stefan.huebner@stud.tu-ilmenau.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <slrnifg359.9qh.Mario.Holbe@darkside.dyn.samba-tng.org>
Sender: linux-raid-owner@vger.kernel.org
To: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Am 02.12.2010 22:16, schrieb Mario 'BitKoenig' Holbe:
> Stefan /*St0fF*/ H=FCbner <stefan.huebner@stud.tu-ilmenau.de> wrote:
>> Now I have the effect that upon plugging in drives that formerly wer=
e
>> part of an array, the md_mod modules gets loaded and tries to
>> auto-assemble arrays.  This disturbs the diagnosis.
>> I've tried raid=3Dnoautodetect as kernel commandline, and I grepped =
the
>> source for the MODULE_PARM_DESC macro, which yielded no (useful) res=
ult.
>>  This "automagic" behaviour happens since 2.6.36.
> Are you sure this autodetection is triggered by the module?
> And are you sure this behaviour is bound to this specific kernel
> version?
>
> In-Kernel auto-assembly is usually not active when md is compiled as
> module. Probably in your case this is some udev-triggered assembly?
>
>
> regards
>    Mario
Hi Mario,

thanks for the hint, I'll check the rules files then ...

Greetings from nebenan sozusagen,
Stefan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
