From: "Majed B." <majedb@gmail.com>
Subject: Re: RAID5 broke during reshape...
Date: Sat, 2 Jan 2010 21:36:03 +0300
Message-ID: <70ed7c3e1001021036l73f6194ek8b553bd08f9893d@mail.gmail.com>
References: <1262451347.10047.14.camel@michal-laptop.sawicz.net>
	<70ed7c3e1001020933x7ac028a5n42af404eb5e23e30@mail.gmail.com>
	<1262454630.10047.23.camel@michal-laptop.sawicz.net> <70ed7c3e1001021001g7e7a17b6ufb431ddfd563eae6@mail.gmail.com>
	<1262456799.10047.33.camel@michal-laptop.sawicz.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1262456799.10047.33.camel@michal-laptop.sawicz.net>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?Q?Micha=C5=82_Sawicz?= <michal@sawicz.net>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

=46rom the error mdadm reported, the array's been converted to a 5-disk
one and it's trying to assemble it with 2 disks only which won't work.

I faced interruption during a grow process before, and re-issuing the
grow command worked for me, but I suggest you run all the tests
possible now and wait till more people reply to your email.

Also, dig around in the mailing list's archive. You're bound to find a
similar event sometime soon.

2010/1/2 Micha=C5=82 Sawicz <michal@sawicz.net>:
> Dnia 2010-01-02, sob o godzinie 21:01 +0300, Majed B. pisze:
>> The output of mdadm -E is incomplete. Please make sure the whole
>> output is included, including the table of devices.
>
> Unfortunately that's all I get from mdadm :/ On another array it does
> report the device table.
>
>> All your disks report a lot of ECC errors: 195 Hardware_ECC_Recovere=
d
>> 0x001a =C2=A0 100 =C2=A0 100 =C2=A0 000 =C2=A0 =C2=A0Old_age =C2=A0 =
Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 139150990
>>
>> You may wanna check your cables and/or RAM (RAM can be tested with a
>> free tool called memtest86). Also, if you don't have smartmontools (=
or
>> smartd to be specific) configured to run periodical polling and
>> testing, you may wanna run: smartctl -t offline /dev/sdx for all dis=
ks
>> and wait till it's finished, then you should be able to see whether
>> you have bad sectors or not.
>
> Will do the memtest after the self tests are done.
>
>> Have you tried force-assembling the array again?
>> mdadm -Af /dev/md0
>
> media ~ # mdadm -Af /dev/md5
> mdadm: /dev/md5 assembled from 2 drives and 3 spares - not enough to
> start the array.
>
>> P.S.: Make sure you reply to all not just me. Re-send the email with
>> the files to the mailing list so that others can look at them as wel=
l
>> :)
>
> Of course, didn't notice no Reply-To was set.
>
> --
> Regards
> Micha=C5=82 (Saviq) Sawicz
>



--=20
       Majed B.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
