From: Zoltan Szecsei <zoltans@geograph.co.za>
Subject: Re: Confusion with setting up new RAID6 with mdadm
Date: Tue, 16 Nov 2010 08:48:59 +0200
Message-ID: <4CE2295B.8050403@geograph.co.za>
References: <4CE00206.4000301@geograph.co.za>	<20101115091326.42b38b84@notabene.brown>	<4CE1758C.5080008@geograph.co.za> <20101116065325.6dd5e8cf@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101116065325.6dd5e8cf@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2010-11-15 21:53, Neil Brown wrote:
> On Mon, 15 Nov 2010 20:01:48 +0200
> Zoltan Szecsei<zoltans@geograph.co.za>  wrote:
>
>   =20
>> Hi,
>> One last quick question:
>> ****************************************************
>> I have compiled the following mdadm on my Ubuntu 64 bit 10.04 Deskto=
p
>> system:
>> root@gs0:/home/geograph# uname -a
>> Linux gs0 2.6.32-25-generic #45-Ubuntu SMP Sat Oct 16 19:52:42 UTC 2=
010
>> x86_64 GNU/Linux
>> root@gs0:/home/geograph# mdadm -V
>> mdadm - v3.1.4 - 31st August 2010
>> root@gs0:/home/geograph#
>>
>> ****************************************************
>> I have deleted the partitions on all 8 drives, and done a mdadm -Ss
>>
>> root@gs0:/home/geograph# fdisk -lu
>>
>> Disk /dev/sda: 2000.4 GB, 2000398934016 bytes
>> 255 heads, 63 sectors/track, 243201 cylinders, total 3907029168 sect=
ors
>> Units =3D sectors of 1 * 512 =3D 512 bytes
>> Sector size (logical/physical): 512 bytes / 512 bytes
>> I/O size (minimum/optimal): 512 bytes / 512 bytes
>> Disk identifier: 0x00000000
>>
>> Disk /dev/sda doesn't contain a valid partition table
>>
>> Disk /dev/sdb: 2000.4 GB, 2000398934016 bytes
>>
>> ******************************************************
>> Based on the above "assume-clean" comment, plus all the help you guy=
s
>> have offered, I have just run:
>> mdadm --create /dev/md0 --metadata=3D1.2 --auto=3Dmd --assume-clean
>> --bitmap=3Dinternal --bitmap-chunk=3D131072 --chunk=3D512 --level=3D=
6
>> --raid-devices=3D8 /dev/sd[abcdefgh]
>>
>> It took a nano-second to complete!
>>
>> The man-pages for assume-clean say that "the array pre-existed". Sur=
ely
>> as I have erased the HDs, and now have no partitions on them, this i=
s
>> not true?
>> Do I need to re-run the above mdadm command, or is it safe to procee=
d
>> with LVM then mkfs ext4?
>>     =20
> It is safe to proceed.
>   =20

Too cool (A for away at last :-) )
Neil: Big thanks to you and the others on this list for all the patienc=
e=20
& help you guys have given.,
Kind regards,
Zoltan
> The situation is that the two parity block are probably not correct o=
n most
> (or even any) stripes.  But you have no live data on them to protect,=
 so it
> doesn't really matter.
>
> With the current implementation of RAID6, every time you write, the c=
orrect
> parity blocks are computed and written.  So any live data that is wri=
tten
> will be accompanies by correct parity blocks to protect it.
>
> This does *not* apply to RAID5 as it sometimes uses the old parity bl=
ock to
> compute the new parity block.  If the old was wrong, the new will be =
wrong
> too.
>
> It is conceivable that one day we might change the raid6 code to perf=
orm
> similar updates if it ever turns out to be faster to do it that way, =
but it
> seems unlikely at the moment.
>
> NeilBrown
>
>
>   =20




--=20

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Zoltan Szecsei PrGISc [PGP0031]
Geograph (Pty) Ltd.
P.O. Box 7, Muizenberg 7950, South Africa.

65 Main Road, Muizenberg 7945
Western Cape, South Africa.

34=B0 6'16.35"S 18=B028'5.62"E

Tel: +27-21-7884897  Mobile: +27-83-6004028
=46ax: +27-86-6115323     www.geograph.co.za
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D



-----
No virus found in this message.
Checked by AVG - www.avg.com
Version: 10.0.1153 / Virus Database: 424/3258 - Release Date: 11/15/10

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
