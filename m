From: =?ISO-8859-1?Q?Bj=F8rn_Eikeland?= <beikeland@gmail.com>
Subject: Re: best way to try recovering inactive raid6
Date: Tue, 21 Dec 2010 22:43:17 +0100
Message-ID: <AANLkTikAc18ryvkdC5Lc37zPQsaaddgPWLCAoJqHszW-@mail.gmail.com>
References: <AANLkTin71JrpmKJC6df+ZX7jsm7P8RwCzUSfV8CMWk2v@mail.gmail.com>
	<alpine.DEB.1.10.1012191559010.27193@uplift.swm.pp.se>
	<AANLkTi=8TGmNYqm0Vt1VSDZcm1rBh24857pR=M9xdEyc@mail.gmail.com>
	<alpine.DEB.1.10.1012191743350.27193@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.1012191743350.27193@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>> $ uname -a
>> Linux filebear 2.6.32-26-generic #48-Ubuntu SMP Wed Nov 24 09:00:03
>> UTC 2010 i686 GNU/Linux
>>
>> $ mdadm -V
>> mdadm - v3.1.4 - 31st August 2010
>> $ sudo mdadm --assemble --force /dev/md6
>> mdadm: /dev/md6 assembled from 2 drives and 2 spares - not enough to
>> start the array.
>>
>> $ cat /proc/mdstat
>> Personalities : [raid6] [raid5] [raid4]
>> md6 : inactive sdc1[0](S) sdd1[6](S) sdh1[5](S) sda1[3](S)
>> =A0 =A0 3906236416 blocks
>>
>> unused devices: <none>
>>
>> mdadm was older, but same behavior with 3.1.14. It was a new ubuntu
>> install a few days ago so didn't think of updating mdadm, kernel is
>> fairly recent at least.
>>
> You should send this to the list together with dmesg output from when=
 this
> happens.
>
> Also, I would include the actual drives on the mdadm line, "sudo mdad=
m
> --assemble --force /dev/md6 /dev/sd[wxyz]".
>
> --
> Mikael Abrahamsson =A0 =A0email: swmike@swm.pp.se


I've cloned and re-added /dev/sdb, and it's starting.., but if
/dev/sdb was stale, and the UU_U_ pattern seems to indicate its
resyncing  /dev/sdb and /dev/sdh - why would it ever need /dev/sdb?

$ mdadm --assemble --force /dev/md6 /dev/sd[abcdh]1
mdadm: forcing event count in /dev/sdb1(1) from 1290382 upto 1290388
mdadm: clearing FAULTY flag for device 1 in /dev/md6 for /dev/sdb1
mdadm: /dev/md6 has been started with 3 drives (out of 5) and 2 spares.
root@filebear:/home/bjorn# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md6 : active raid6 sdc1[0] sdd1[6] sdh1[5] sda1[3] sdb1[1]
      2929677312 blocks level 6, 256k chunk, algorithm 2 [5/3] [UU_U_]
      [>....................]  recovery =3D  0.0% (841000/976559104)
finish=3D309.3min speed=3D52562K/sec

unused devices: <none>

Oh well, I'm just glad this was md based and possible to resurrect at
all! I've mounted it read-only and tested quite a few large files, and
they're intact.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
