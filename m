From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: mdadm raid1 read performance
Date: Wed, 4 May 2011 20:57:00 -0300
Message-ID: <BANLkTikPNcCuPkEV4ikwKvvkV468yYJZKA@mail.gmail.com>
References: <BANLkTim8Ehn0fANtibg7X1cMVvOgt7CNMA@mail.gmail.com>
	<20110504105822.21e23bc3@notabene.brown>
	<BANLkTimzqu1C+_Z2t5m1bjduXFeRwbgssQ@mail.gmail.com>
	<4DC0F2B6.9050708@fnarfbargle.com>
	<BANLkTinbFZf=kV=3eUe2S6XNAOst_McX4w@mail.gmail.com>
	<BANLkTikQTKPuY+Mg8h9ZOkJPoEQ-jGTeLg@mail.gmail.com>
	<20110505094538.0cef02cc@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110505094538.0cef02cc@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Liam Kurmos <quantum.leaf@gmail.com>, Brad Campbell <lists2009@fnarfbargle.com>, Drew <drew.kay@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2011/5/4 NeilBrown <neilb@suse.de>:
> On Thu, 5 May 2011 00:08:59 +0100 Liam Kurmos <quantum.leaf@gmail.com=
> wrote:
>
>> Thanks to all who replied on this.
>>
>> I somewhat naively assumed that having 2 disks with the same data
>> would mean a similar read speed to raid0 should be the norm (and i
>> think this is a very popular miss-conception).
>> I was neglecting the seek time to skip alternate blocks which i gues=
s
>> must the flaw.
>>
>> In theory though if i was reading a larger file, couldn't one disk
>> start reading at the beginning to a buffer and one start reading fro=
m
>> half way ( assuming 2 disks) and hence get close to 2x single d
>
> isk
>> speed?
>
> If you write your program to read from both the beginning and the mid=
dle
> then you might get double-speed. =A0The kernel doesn't know you are g=
oing to do
> this so the best it can do is read-ahead is large amounts.
>
> raid1 could notice large reads and send some to one disk and some to =
another,
> but the size for each device must be large enough that the time to se=
ek over
> must be much less than the time to read, which is probably many megab=
ytes on
> todays hardware - and raid1 has no way to know what that size is.
>
> Certainly it is possible that the read_balance code in md/raid1 could=
 be
> improved. =A0As yet no-one has improved it and provided convincing pe=
rformance
> numbers.

yes, it=B4s not a 10000% improvement, i got a max of 1% on a big test (=
1
hour of nonsequencial read), for ssd round robin allow a more use of
drives, and some improvements, while i don=B4t know how to get
hardware/software queue size, i couln=B4t improve code for select 'best=
'
disk: the disk that should return with less time, but benchmark
results was interesting since 1% was 1% three times (60minutes drop to
54minutes)

could be very interesting how to get information about disk and
automatic tune read balance
informations: acesstime (RPM information can help here), mb/s in a
sequencial search (depend RPM+disk size(1,8" 2,5" 3,5")+interface
(SATA1,SATA2,SAS) since SATA1 can=B4t allow more than 1,5Gb/s),
rotational/non rotational information
diference from rotational to non rotational:
roatitional: access time proportional to block distance (head arm /
disk position)
non rotaition: fixed accesstime with low variation


>> as a separate question, what should be the theoretical performance o=
f raid5?
>
> x(N-1)
>
> So a 4 drive RAID5 should read at 3 time the speed of a single drive.
>
>>
>> in my tests i read 1GB and throw away the data.
>> dd if=3D/dev/md0 of=3D/dev/null bs=3D1M count=3D1000
>>
>> With 4 fairly fast hdd's i get
>
> Which apparently do 140MB/s:
>
>>
>> raid0: ~540MB/s
>
> I would expect 4*140 =3D=3D 560, so this is a good result.
>
>> raid10: 220MB/s
>
> Assuming the default 'n2' layout, I would expect 2*140 or 280, so thi=
s is a
> little slow. =A0Try "--layout=3Df2" and see what you get (should be m=
ore like
> RAID0).
>
>> raid5: ~165MB/s
>
> I would expect 3*140 or 420, so this is very slow. =A0I wonder if rea=
d-ahead is
> set badly.
> Can you:
> =A0 blockdev --getra /dev/md0
> multiply the number it gives you by 8 and give it back with
> =A0 blockdev --setra NUMBER /dev/md0

very nice :)

>
>
>> raid1: ~140MB/s =A0(single disk speed)
>
> as expected.
>
>>
>> for 4 disks raid0 seems like suicide, but for my system drive the
>> speed advantage is so great im tempted to try it anyway and try and
>> use rsync to keep constant back up.
>
> If you have somewhere to rsync to, then you have more disks so RAID10=
 might
> be an answer... but I suspect you cannot move disks around that freel=
y :-)
>
> NeilBrown
>
>
>
>>
>> cheers for you responses,
>>
>> Liam
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Roberto Spadim
Spadim Technology / SPAEmpresarial
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
