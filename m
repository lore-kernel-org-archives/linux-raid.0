From: =?ISO-8859-1?Q?Kristleifur_Da=F0ason?= <kristleifur@gmail.com>
Subject: Re: BUG:write data to degrade raid5
Date: Fri, 19 Mar 2010 18:26:18 +0000
Message-ID: <73e903671003191126l6c0bed69q69c32bf37922690d@mail.gmail.com>
References: <de04351e1003190329l2f33447bhe37b963bd4b48c70@mail.gmail.com>
	<4BA3C07A.8030204@gmx.net> <73e903671003191123h1b7e1196v336265842f1b29e5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <73e903671003191123h1b7e1196v336265842f1b29e5@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Mar 19, 2010 at 6:20 PM, Joachim Otahal <Jou@gmx.net> wrote:
> jin zhencheng schrieb:
>>
>> hi;
>>
>> i use kernel is 2.6.26.2
>>
>> what i do as follow:
>>
>> 1, I create a raid5:
>> mdadm -C /dev/md5 -l 5 -n 4 /dev/sda /dev/sdb /dev/sdc =A0/dev/sdd
>> --metadata=3D1.0 --assume-clean
>>
>> 2, dd if=3D/dev/zero of=3D/dev/md5 bs=3D1M&
>>
>> write data to this raid5
>>
>> 3, mdadm --manage /dev/md5 -f /dev/sda
>>
>> 4 mdadm --manage =A0/dev/md5 -f /dev/sdb
>>
>> if i faild 2 disks ,then the OS kernel display OOP error and kernel =
down
>>
>> do somebody know why ?
>>
>> Is MD/RAID5 bug ?
>>
>
> RAID5 can only tolerate ONE drive to fail of ALL members. If you want=
 to be
> able to fail two drives you will have to use RAID6 or RAID5 with one
> hot-spare (and give it time to rebuild before failing the second driv=
e).
> PLEASE read the documentation on raid levels, like on wikipedia.
>

That is true,

but should we get a kernel oops and crash if two RAID5 drives are
failed? (THAT part looks like a bug!)

Jin, can you try a newer kernel, and a newer mdadm?

-- Kristleifur
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
