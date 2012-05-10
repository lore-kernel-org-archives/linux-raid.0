From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: md RAID with enterprise-class SATA or SAS drives
Date: Thu, 10 May 2012 19:10:54 +0100
Message-ID: <CADNH=7H1kL41fHQ6dog=2yA3GfW7Vg3FfdSMiPfcM1hWuX5WhQ@mail.gmail.com>
References: <4FAAE8F1.8000600@pocock.com.au>
	<CALFpzo5ObdwFATdT4e20znnxzU5hX9SVSfqJcdqOXM1FEYJQuw@mail.gmail.com>
	<4FABC7C6.4030107@turmel.org>
	<CALFpzo6BECrv2eTbSRKwUzpTopx_0EmD+UipqUf-XE=vzz2OnQ@mail.gmail.com>
	<4FABE724.40103@turmel.org>
	<otbt79xn1j.ln2@goaway.wombat.san-francisco.ca.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <otbt79xn1j.ln2@goaway.wombat.san-francisco.ca.us>
Sender: linux-raid-owner@vger.kernel.org
To: Keith Keller <kkeller@wombat.san-francisco.ca.us>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10 May 2012 18:53, Keith Keller <kkeller@wombat.san-francisco.ca.us>=
 wrote:
> On 2012-05-10, Phil Turmel <philip@turmel.org> wrote:
>>
>> Frequent array checks are not optional, if you want flush out any UR=
Es
>> in the making, and maximize your odds of successfully rebuilding aft=
er
>> a drive replacement. =C2=A0If you are running RAID6 or a triple mirr=
or, with
>> frequent checks, you are very safe.
>
> How frequent do people define as "frequent"? =C2=A0I typically do mon=
thly
> checks, but perhaps I should be doing them weekly.
>
> --keith
>
>
> --
> kkeller@wombat.san-francisco.ca.us
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml

RAID6 on 7 2TB here, weekly checks..
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
