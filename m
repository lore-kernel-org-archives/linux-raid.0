From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: mdadm raid1 read performance
Date: Wed, 4 May 2011 20:35:19 -0300
Message-ID: <BANLkTi=whGQZGF_9xRd9aXLj7S76+S5W4w@mail.gmail.com>
References: <BANLkTim8Ehn0fANtibg7X1cMVvOgt7CNMA@mail.gmail.com>
	<20110504105822.21e23bc3@notabene.brown>
	<BANLkTimzqu1C+_Z2t5m1bjduXFeRwbgssQ@mail.gmail.com>
	<4DC0F2B6.9050708@fnarfbargle.com>
	<BANLkTinbFZf=kV=3eUe2S6XNAOst_McX4w@mail.gmail.com>
	<BANLkTikQTKPuY+Mg8h9ZOkJPoEQ-jGTeLg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTikQTKPuY+Mg8h9ZOkJPoEQ-jGTeLg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Liam Kurmos <quantum.leaf@gmail.com>
Cc: Brad Campbell <lists2009@fnarfbargle.com>, Drew <drew.kay@gmail.com>, NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2011/5/4 Liam Kurmos <quantum.leaf@gmail.com>:
> Thanks to all who replied on this.
>
> I somewhat naively assumed that having 2 disks with the same data
> would mean a similar read speed to raid0 should be the norm (and i
> think this is a very popular miss-conception).
> I was neglecting the seek time to skip alternate blocks which i guess
> must the flaw.
>
> In theory though if i was reading a larger file, couldn't one disk
> start reading at the beginning to a buffer and one start reading from
> half way ( assuming 2 disks) and hence get close to 2x single disk
> speed?

hummm..... maybe, it=B4s what LINEAR do, and depend how linux divide on=
e
large read into small reads, and how program use fread(), with many
small freads, or with one big fread
check some magic....

1 disk blocks:
disk1: ABCDEFGH

raid0 (stripe) 2 disks
disk1: ACEG
disk2: BDFH

raid1 (no stripe) 2 disks
disk1: ABCDEFGH
disk2: ABCDEFGH

raid0 (linear) 2 disks
disk1: ABCD
disk2: EFGH

if you want to read ABCDEFGH the best speed will be raid0 (stripe),
you can read A+B, C+D, E+F, G+H with small disk/head movement
raid1 could help? maybe.... if you have 2 programs reading ABCDEFGH
and you don=B4t have cache/buffer, one program can use disk1, and
another disk2 that=B4s the best speed, or raid0 (linear) if one program
read ABCD and another EFGH, and after change program 1 EFGH and
program 2 ABCD

the problem here is:
1)read speed (more RPM =3D more MB/s),
2)access time (more acces time =3D more latency, acess time =3D RPM and
DISK (head move time) size 2,5" or 3,5" or 1,8"), some 'normal'
numbers:
    7200rpm=3D8,3333333ms acess time
    10000rpm=3D6ms acess time
    15000rpm=3D4ms acesstime
    ssd =3D 0.1ms acesstime (firmware: sata protocol + internal address
table + queue + others internal firmware tasks)
3)
for hard disk:
total time to read =3D access time (from current disk position and
current head position, to new head position and new disk position) +
read speed * number of bytes
for ssd:
total time to read =3D access time + internal information search (some
ssd have internal reallocation) + memory read time

stripe allow a small accesstime, since one disk read A, and is near to
C, while other disk read B and is near to D, with a sequencial read of
ABCD, you have 2 'reads' per driver, while with a linear you have 4
'reads'



> as a separate question, what should be the theoretical performance of=
 raid5?
>
> in my tests i read 1GB and throw away the data.
> dd if=3D/dev/md0 of=3D/dev/null bs=3D1M count=3D1000
>
> With 4 fairly fast hdd's i get
>
> raid0: ~540MB/s
> raid10: 220MB/s
> raid5: ~165MB/s
> raid1: ~140MB/s =A0(single disk speed)
>
> for 4 disks raid0 seems like suicide, but for my system drive the
> speed advantage is so great im tempted to try it anyway and try and
> use rsync to keep constant back up.
>

i don=B4t know many information about raid5, but i think it=B4s near ra=
id0
linear or raid0 stripe algorithm, need some checks with others guys

> cheers for you responses,
>
> Liam
>
>
>
> On Wed, May 4, 2011 at 8:42 AM, Roberto Spadim <roberto@spadim.com.br=
> wrote:
>> hum...
>> at user program we use:
>> file=3Dfopen(); var=3Dfread(file,buffer_size);fclose(file);
>>
>> buffer_size is the problem since it can be very small (many reads), =
or
>> very big (small memory problem, but very nice query to optimize at
>> device block level)
>> if we have a big buffer_size, we can split it across disks (ssd)
>> if we have a small buffer_size, we can't split it (only if readahead
>> is very big)
>> problem: we need memory (cache/buffer)
>>
>> the problem... is readahead better for ssd? or a bigger 'buffer_size=
'
>> at user program is better?
>> or... a filesystem change of 'block' size to a bigger block size, wi=
th
>> this don't matter if user use a small buffer_size at fread functions=
,
>> filesystem will always read many information at device block layer,
>> what's better? others ideas?
>>
>> i don't know how linux kernel handle a very big fread with memory
>> for example:
>> fread(file,1000000); // 1MB
>> will linux split the 'single' fread in many reads at block layer? ea=
ch
>> read with 1 block size (512byte/4096byte)?
>>
>> 2011/5/4 Brad Campbell <lists2009@fnarfbargle.com>:
>>> On 04/05/11 13:30, Drew wrote:
>>>
>>>> It seemed logical to me that if two disks had the same data and we
>>>> were reading an arbitrary amount of data, why couldn't we split th=
e
>>>> read across both disks? That way we get the benefits of pulling fr=
om
>>>> multiple disks in the read case while accepting the penalty of a w=
rite
>>>> being as slow as the slowest disk..
>>>>
>>>>
>>>
>>> I would have thought as you'd be skipping alternate "stripes" on ea=
ch disk
>>> you minimise the benefit of a readahead buffer and get subjected to=
 seek and
>>> rotational latency on both disks. Overall you're benefit would be s=
lim to
>>> immeasurable. Now on SSD's I could see it providing some extra oomp=
h as you
>>> suffer none of the mechanical latency penalties.
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-rai=
d" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.htm=
l
>>>
>>
>>
>>
>> --
>> Roberto Spadim
>> Spadim Technology / SPAEmpresarial
>>
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
