From: Mark Knecht <markknecht@gmail.com>
Subject: Re: Use of WD20EARS with MDADM
Date: Thu, 25 Mar 2010 10:58:21 -0700
Message-ID: <5bdc1c8b1003251058x1a459118lb29b23eae8cb6d33@mail.gmail.com>
References: <4BAB8D41.4010801@gmail.com> <4BAB9703.2050801@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BAB9703.2050801@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: Asdo <asdo@shiftmail.org>
Cc: Andrew Dunn <andrew.g.dunn@gmail.com>, Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Mar 25, 2010 at 10:01 AM, Asdo <asdo@shiftmail.org> wrote:
> Andrew Dunn wrote:
>>
>> Recently Dell is selling their WD20EARS (2TB) for 90$
>>
>> This being one of the best PPG (Price Per Gigabyte) snatches I have
>> seen, I was considering buying 8 of them for an mdadm array.
>>
>> Has anyone had experience with these drives?
>>
>> Note, they have 4K sectors.
>>
>> Thank you for your kind responses.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.h=
tml
>>
>
> Might not have ERC / TLER settable, see the other WD drive (WD360GD) =
here:
> http://forums.storagereview.com/index.php/topic/28333-tler-cctl/
> however only 1 WD drive is listed (WD360GD), no info is there specifi=
cally
> on WD20EARS
>
> Good luck
>
> Update that list if you buy it :-)

I'm wondering where the guy in the link you provided got the command:

smartctl -l scterc d:

Assuming a Linux shift to

smartctl -l scterc /dev/sda

I get an error message:

gandalf ~ # smartctl -l scterc /dev/sda
smartctl 5.39.1 2010-01-28 r3054 [x86_64-pc-linux-gnu] (local build)
Copyright (C) 2002-10 by Bruce Allen, http://smartmontools.sourceforge.=
net

=3D=3D=3D=3D=3D=3D=3D> INVALID ARGUMENT TO -l: scterc
=3D=3D=3D=3D=3D=3D=3D> VALID ARGUMENTS ARE: error, selftest, selective,
directory[,g|s], background, scttemp[sts|hist], sasphy[,reset],
sataphy[,reset], gplog,N[,RANGE], smartlog,N[,RANGE],
xerror[,N][,error], xselftest[,N][,selftest] <=3D=3D=3D=3D=3D=3D=3D

Use smartctl -h to get a usage summary

gandalf ~ #

Google has a few more links of folks using that command, but less than =
1 page.


I have 6 WD10EARS drives that I'm going to try out, possibly this
weekend, for the first time. We'll see how it goes. I'm a newbie with
RAID and LVM. My requirements are, for the most part, very modest in
terms of speed and lifetime. The RAID is just for basic backup
protection of other stuff.

Cheers,
Mark
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
