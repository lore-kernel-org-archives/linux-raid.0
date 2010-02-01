From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Building RAID5 w/o a Hot Spare
Date: Mon, 01 Feb 2010 16:45:48 -0500
Message-ID: <4B674B8C.9010200@tmr.com>
References: <d80f793f1001270626s3ec1791ma0b5da4b87a31e34@mail.gmail.com> <1264603577.1928.4.camel@test.apertos.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1264603577.1928.4.camel@test.apertos.eu>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?TWljaGHFgiBTYXdpY3o=?= <michal@sawicz.net>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Micha=C5=82 Sawicz wrote:
> Dnia 2010-01-27, =C5=9Bro o godzinie 09:26 -0500, Carlos Williams pis=
ze:
>  =20
>> I am building a Linux system which has 4 identical 'fd' partitions o=
n
>> each of the 4 drives. I don't want to use the 4th partition or disk =
if
>> you would like to call it as a 'hot spare'. I would like to span the
>> entire array over the 4 drives. My question is does my command look
>> correct for doing so?
>>    =20
>
> I'm not sure I understand what you want to achieve. A 'spare' disk is
> one that isn't used until any of the other fail, then the spare repla=
ces
> the failed one. The term 'hot spare' is used to identify a disk that =
is
> a mirror of one of the other drives, but there's no support for that =
in
> Linux Software-RAID.
>
>  =20
>> mdadm --create /dev/md0 --level=3D5 --raid-devices=3D4 /dev/sda2 /de=
v/sdb2
>> /dev/sdc2 /dev/sdd2=20
>>    =20
>
> This will create a RAID5 array of 4 devices, yes. Capacity will be 3 =
x
> sd?2. Failure of any one of those disks will not harm the data.
>
>  =20
A hot spare is in and spinning, or at least powered up, ready to use=20
with software. And software raid does support putting a raid, such as=20
raid-1 or even raid-5, or members which are raid-1 with a write mostly=20
drive and ready to go.

--=20
Bill Davidsen <davidsen@tmr.com>
  "We can't solve today's problems by using the same thinking we
   used in creating them." - Einstein


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
