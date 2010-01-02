From: "Majed B." <majedb@gmail.com>
Subject: Re: RAID5 broke during reshape...
Date: Sat, 2 Jan 2010 21:01:49 +0300
Message-ID: <70ed7c3e1001021001g7e7a17b6ufb431ddfd563eae6@mail.gmail.com>
References: <1262451347.10047.14.camel@michal-laptop.sawicz.net>
	<70ed7c3e1001020933x7ac028a5n42af404eb5e23e30@mail.gmail.com>
	<1262454630.10047.23.camel@michal-laptop.sawicz.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1262454630.10047.23.camel@michal-laptop.sawicz.net>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?Q?Micha=C5=82_Sawicz?= <michal@sawicz.net>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

The output of mdadm -E is incomplete. Please make sure the whole
output is included, including the table of devices.

All your disks report a lot of ECC errors: 195 Hardware_ECC_Recovered
0x001a   100   100   000    Old_age   Always       -       139150990

You may wanna check your cables and/or RAM (RAM can be tested with a
free tool called memtest86). Also, if you don't have smartmontools (or
smartd to be specific) configured to run periodical polling and
testing, you may wanna run: smartctl -t offline /dev/sdx for all disks
and wait till it's finished, then you should be able to see whether
you have bad sectors or not.

Have you tried force-assembling the array again?
mdadm -Af /dev/md0

P.S.: Make sure you reply to all not just me. Re-send the email with
the files to the mailing list so that others can look at them as well
:)

2010/1/2 Micha=C5=82 Sawicz <michal@sawicz.net>:
> Dnia 2010-01-02, sob o godzinie 20:33 +0300, Majed B. pisze:
>> Post the output of mdadm -E /dev/sdx1 and smart -a /dev/sdx for all
>> disks.
>
> Please find the files attached.
>
>> Also, which version of mdadm are you using?
>
> media ~ # mdadm --version
> mdadm - v3.1.1 - 19th November 2009
>
>
> --
> Pozdrawiam
> Micha=C5=82 (Saviq) Sawicz
>



--=20
       Majed B.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
