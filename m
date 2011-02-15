From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: write-behind has no measurable effect?
Date: Tue, 15 Feb 2011 15:46:05 -0200
Message-ID: <AANLkTikhGc-nvtoBZw21W=enciLsM4TPxs62=1A2C+Hj@mail.gmail.com>
References: <20110214213817.GG836@hellgate.intra.guy>
	<20110215095042.51ef7e0a@notabene.brown>
	<20110214225754.GK19990@hellgate.intra.guy>
	<20110215104109.06b12b33@notabene.brown>
	<20110215010052.GA13135@hellgate.intra.guy>
	<4D59D4A5.9050106@anonymous.org.uk>
	<20110215021900.GB13135@hellgate.intra.guy>
	<AANLkTikFSOePZJXknAt=Tx6+FpdJ4tiSNwpuwuPC3RY=@mail.gmail.com>
	<AANLkTinAV4jJc8ueZ1mjRPpDnA_eWhUDcL8uz-0Ufifk@mail.gmail.com>
	<20110215124026.GC13135@hellgate.intra.guy>
	<AANLkTimdyU-rQMY83fq9r2LpP0PGgz0gfV+=gkQWH++F@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTimdyU-rQMY83fq9r2LpP0PGgz0gfV+=gkQWH++F@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Andras Korn <korn@raidlist.elan.rulez.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

at raid1.c there=B4s a example with ssd and hd with different speeds

2011/2/15 Roberto Spadim <roberto@spadim.com.br>:
> writes will be the speed of slowest mirror (ssd or hd)
> read can have speed improvement with this patch
>
> there=B4s some options
>
> /sys/block/md0/md/read_balance_mode
>
> near_head =3D today implementation
> round_robin =3D> could be usefull if you have ssd only, since
> round_robin consider that access time is the same for any drive (hard
> disk access time is diferent for random and sequencial)
> stripe =3D> i didn=B4t get good benchmarks, but it=B4s nice to have i=
t,
> since we could put it over network, some sectors on one disk others o=
n
> another (nbd)
> time_based =3D> here you should send me some information about you di=
sk
> for example:
> =A0 =A0access time of mirrors (check your drive information website, =
ssd
> are normaly <0.1ms, hard disks near 10~20 ms)
> =A0 =A0sequencial read speed (use dd if=3D/dev/sda of=3D/dev/zero bs=3D=
4096,
> change the block size to size you will use with your filesystem, for
> vertex2 ssd i=B4m using bs=3D4096, for disks it=B4s a good value too,=
 since
> disks bs ~=3D number of heads (2,4,8) )
>
> send me the access time and sequencial read speed and i make the
> values to tune your sysfs (/sys/block/md0/md/read_balance_config)
>
> you will need to :
>
> echo "time_based" > /sys/block/md0/md/read_balance_mode
> echo "disks informations" > /sys/block/md0/md/read_balance_config
>
> for each mirror, you can=B4t use sysfs file to configure it, maybe a
> bash script is a better solution to configure it, on future version i
> will change it and put at /sys/block/md0/md/dev-xxxx/
>
> 2011/2/15 Andras Korn <korn@raidlist.elan.rulez.org>:
>> On Tue, Feb 15, 2011 at 06:10:17AM -0300, Roberto Spadim wrote:
>>
>>> andras could you make some benchmarks to raid1 with round robin rea=
d balance?
>>> at this site:
>>> www.spadim.com.br/raid1/
>>>
>>> it's kernel 2.6.37 based
>>
>> Yes, I can do that. Can you give me some hints on what specific
>> configuration to try? I see you have some sysfs tunables. My raid1 a=
rray
>> consists of two spinning disks and an SSD, all local.
>>
>> Do you expect this patch to make a difference in my case? With the s=
pinning
>> disks marked as write-mostly, I'm getting close to the read performa=
nce of
>> the SSD (except for very small random reads, for some reason).
>>
>> It's random writes that are much slower than with only the SSD.
>>
>> --
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 Andras Korn <korn at elan.ru=
lez.org>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0There is no spoon(). But there is=
 a fork().
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>>
>
>
>
> --
> Roberto Spadim
> Spadim Technology / SPAEmpresarial
>



--=20
Roberto Spadim
Spadim Technology / SPAEmpresarial
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
