From: Du Jun <dujun@perabytes.com>
Subject: Re: raid related kernel hang in 2.6.36
Date: Wed, 24 Nov 2010 22:34:21 +0800
Message-ID: <4CED226D.6090602@perabytes.com>
References: <4CED17A4.7050604@perabytes.com> <AANLkTinfbPDQhmKRVibUv+Rm50wDkGizeYLGXQqY_xOu@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTinfbPDQhmKRVibUv+Rm50wDkGizeYLGXQqY_xOu@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?TWF0aGlhcyBCdXLDqW4=?= <mathias.buren@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Their's no dmesg information at all before the hang. The system just=20
hangs suddenly without any kernel printk or oops.

mdadm version is debian lenny version 2.6.7.2-3

I will get mdadm -E & mdadm -D informations tomorrow but I doubt they=20
are useful.

Johnson
on 2010/11/24 22:19, Mathias Bur=C3=A9n  wrote:
> Hi,
>
> I suppose a few logs would be interesting. (dmesg, mdadm -E (hdds),
> mdadm -D md10, zcat /proc/config.gz, mdadm version)
>
> Regards,
> // Mathias
>
> 2010/11/24 Du Jun<dujun@perabytes.com>:
>   =20
>> Hi,
>> We just quick tested the raid stability under the vanilla 2.6.36 ker=
nel
>> and got an unstable result.
>>
>> first, we create a raid5 array using 16 sata disks:
>>
>> mdadm -C /dev/md10 -l 5 -n 16 /dev/sd[b-q]
>>
>> then use dd to stress the io:
>>
>> dd if=3D/dev/zero of=3D/dev/md10 bs=3D1M
>>
>> After a while, usually several minutes, the system hangs. It looks l=
ike
>> some kind of kernel deadlock. ping to this machine could get timely
>> response, however, any other process just hangs.
>>
>> It is easily reproducible and everytime the test result is a system =
hang.
>>
>> Johnson
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>     =20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>   =20

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
