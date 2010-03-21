From: jin zhencheng <zhenchengjin@gmail.com>
Subject: Re: BUG:write data to degrade raid5
Date: Sun, 21 Mar 2010 18:29:53 +0800
Message-ID: <de04351e1003210329w21f4731as3597245562a390d@mail.gmail.com>
References: <de04351e1003190329l2f33447bhe37b963bd4b48c70@mail.gmail.com>
	 <4BA3C07A.8030204@gmx.net>
	 <73e903671003191123h1b7e1196v336265842f1b29e5@mail.gmail.com>
	 <4BA3C461.5060209@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-9
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4BA3C461.5060209@gmx.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Joachim Otahal <Jou@gmx.net>
Cc: =?ISO-8859-1?Q?Kristleifur_Da=F0ason?= <kristleifur@gmail.com>, neilb@suse.de, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

hi Joachim Otahal:

ths for your test on "Debian 2.6.26-21lenny4".
if you want to see the oop ,you should always write to the raid5 ,and
pull 2 disks out.maybe you can see the error

i think no matter what i do ,even if i pull out all the disk , kernel
should not oop.


On Sat, Mar 20, 2010 at 2:37 AM, Joachim Otahal <Jou@gmx.net> wrote:
> Kristleifur Da=F0ason schrieb:
>>
>> On Fri, Mar 19, 2010 at 6:20 PM, Joachim Otahal <Jou@gmx.net
>> <mailto:Jou@gmx.net>> wrote:
>>
>> =A0 =A0jin zhencheng schrieb:
>>
>> =A0 =A0 =A0 =A0hi;
>>
>> =A0 =A0 =A0 =A0i use kernel is 2.6.26.2
>>
>> =A0 =A0 =A0 =A0what i do as follow:
>>
>> =A0 =A0 =A0 =A01, I create a raid5:
>> =A0 =A0 =A0 =A0mdadm -C /dev/md5 -l 5 -n 4 /dev/sda /dev/sdb /dev/sd=
c =A0/dev/sdd
>> =A0 =A0 =A0 =A0--metadata=3D1.0 --assume-clean
>>
>> =A0 =A0 =A0 =A02, dd if=3D/dev/zero of=3D/dev/md5 bs=3D1M&
>>
>> =A0 =A0 =A0 =A0write data to this raid5
>>
>> =A0 =A0 =A0 =A03, mdadm --manage /dev/md5 -f /dev/sda
>>
>> =A0 =A0 =A0 =A04 mdadm --manage =A0/dev/md5 -f /dev/sdb
>>
>> =A0 =A0 =A0 =A0if i faild 2 disks ,then the OS kernel display OOP er=
ror and
>> =A0 =A0 =A0 =A0kernel down
>>
>> =A0 =A0 =A0 =A0do somebody know why ?
>>
>> =A0 =A0 =A0 =A0Is MD/RAID5 bug ?
>>
>>
>> =A0 =A0RAID5 can only tolerate ONE drive to fail of ALL members. If =
you
>> =A0 =A0want to be able to fail two drives you will have to use RAID6=
 or
>> =A0 =A0RAID5 with one hot-spare (and give it time to rebuild before
>> =A0 =A0failing the second drive).
>> =A0 =A0PLEASE read the documentation on raid levels, like on wikiped=
ia.
>>
>>
>> That is true,
>>
>> but should we get a kernel oops and crash if two RAID5 drives are fa=
iled?
>> (THAT part looks like a bug!)
>>
>> Jin, can you try a newer kernel, and a newer mdadm?
>>
>> -- Kristleifur
>
> You are probably right.
> My kernel version is "Debian 2.6.26-21lenny4", and I had no oopses du=
ring my
> hot-plug testing one the hardware I use md on. I think it may be the =
driver
> for his chips.
>
> Jin:
>
> Did you really use the whole drives for testing or loopback files or
> partitions on the drives? I never did my hot-plug testings with whole=
 drives
> being in an array, only with partitions.
>
> Joachim Otahal
>
>
