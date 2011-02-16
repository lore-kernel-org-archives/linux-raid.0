From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: md road-map: 2011
Date: Wed, 16 Feb 2011 10:40:40 -0300
Message-ID: <AANLkTikiP+PTJzpQomr++4d0chRww3gOq0R-J2-vaQ1-@mail.gmail.com>
References: <20110216212751.51a294aa@notabene.brown>
	<4D5BB4EA.8030907@texsoft.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D5BB4EA.8030907@texsoft.it>
Sender: linux-raid-owner@vger.kernel.org
To: Giovanni Tessore <giotex@texsoft.it>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

i agree with giovanni, another question since we will make a lot of
change on mirrors based arrays (raid1, raid10) with the badblock list,
could we:

option1) remove raid1 code, change raid10 to work without raid0
'service', change raid10 to work with more than 1mirror (like raid1
do)?
option2) port raid10 layout to raid1?

raid10 can do the same job of raid1 if we don't use 0(stripe) feature.
raid1 have the write-behind, and 'many mirrors' feature, but don't
have layout/offset.

a raid1 with offset layout could improve (a lot!) read performace of
raid1 array. i'm not good in english i will explain with a example:

raid1 (/dev/md0) with 2 mirrors (/dev/sda,/dev/sdb)

/dev/md0 sector1 on /dev/sda =3D sector1
/dev/md0 sector1 on /dev/sdb =3D sector2 (or another offset)

reading sector 1 and 2 from /dev/md0:

considering current disks (/dev/sda,/dev/sdb) head positions=3D0
read sector1 from /dev/sda (distance from sda=3D0, distance from sdb=3D=
1)
read sector2 from /dev/sdb (distance from sda=3D1, distance from sdb=3D=
0)

see that i don't need more size(raid0) i just need a layout/offset to
make reads faster
others layouts could help too: odd sectors on start of disk1 even
sectors on end of disk1; even sectors on start of disk2 odd sectors of
end of disk2

i don't know what is more time consuming (for short and long time),
option1 or option2?



=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
ps1:
i made some benchmarks with ssd only array, a roundrobin read balance
is faster than near head, let's explain my conclusion:
    near head isn't good on devices where sequencial/non sequencial
read have the same speed, it don't know anything about device read
speed
    the near_head algorithm get one disk and use it for a big
sequencial read (some devices aren't good on sequencial read, or time
for sequencial/non sequencial can be the same for some ssd device)
    resume: a mixed speed ssd only is poor optimized with near head, be=
cause:
        1) near head don't know anything about read rate of devices,
with a round robin with per mirror max counter resolve this problem
        2) some ssd access time for sequencial/non sequencial read is
the same (near 0.1ms)

for a mixed array (andreas korn email) using time based with ssd
corsair (~100mb/s, <.1ms accesstime) and 2 barracuda 7200rpm harddisk
(~130mb/s, 0 accestime for sequencial, <=3D8ms accestime for non
sequencial) we don't have a lot of performace since the performace of
raid0 is just because layout/offset feature, just a read difference of
+1% speed improvement using time based read (maybe marginal error,
maybe not, iozone spend a lot of time to benchmark, we didn't have
more time to test).


=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
ps2/explanations:
time based isn't a today kernel read_balance algorithm, it's a patch
that i'm testing (www.spadim.com.br/raid1 for kernel 2.6.37)
time based use near_head idea with some more informations to select bes=
t disk:

time to move head ( (near_head distance * per mirror head move speed)
+ (fixed sequencial speed if sequencial) + (fixed non sequencial speed
if non sequencial)
+
time to read (sectors to read * read_rate, something like: 130mb/s =3D
3,7560096153e-6 seconds / sector)
+
time to end queue (sum of reads*read_rate + sum of writes*write_rate +
time to move head(first read/write sector - last read/write sector) ,
considering that disk queue (scheduler/elevators) make a good job
moving head just 1 time, in futures versions when elevator  could
inform time estimation we could just use it and remove this math from
md code), not yet implemented

time based work like near_head if:
read_rate=3D0, write_rate=3D0, head_move_speed=3D1,
fixed_sequencial_speed=3D0, fixed_nonsequencial_speed=3D0
on all mirror





2011/2/16 Giovanni Tessore <giotex@texsoft.it>:
> Hi Neil,
> I apreciate very much the Bad Block Log feature, as I had big trouble=
s with
> read errors during recovery of a degraded RAID-5 array.
> It seems to me a very good idea to just fail a stripe or even a singl=
e block
> (the smallest possible unit of information possibly) if the read erro=
r is
> unrecoverable, letting the remainig 99.99..% of the device still onli=
ne and
> available (that is, return the unrecoverable read error to the 'calle=
r' as
> would do a single disk).
> Also having the list of bad block availabe into sysfs is a very usefu=
l
> feature.
>
> Still regarding to correctable read errors, how are they currently ma=
naged
> with RAID-1? If a read error occurs on sector XZY of disk A, the same=
 sector
> XYZ is get from another disk (ramdomly) in the same array and rewritt=
en to
> disk A? (for RAID456 it's reconstructed from parity, and it's clearly=
 much
> safer).
>
> Regards.
>
>
> On 02/16/2011 11:27 AM, NeilBrown wrote:
>>
>> I all,
>> =A0I wrote this today and posted it at
>> http://neil.brown.name/blog/20110216044002
>>
>> I thought it might be worth posting it here too...
>>
>> NeilBrown
>
>
> --
> Cordiali saluti.
> Yours faithfully.
>
> Giovanni Tessore
>
>
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
