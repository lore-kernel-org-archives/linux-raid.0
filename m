From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: high throughput storage server?
Date: Tue, 15 Feb 2011 11:03:16 -0200
Message-ID: <AANLkTikSehaGsna8z4qFH_S2JPSsepiTUV8OEYdQPykm@mail.gmail.com>
References: <AANLkTik5_Zx98rSbmpgUtG82qtFObANtCcbnn-a7MXcp@mail.gmail.com>
	<4D5A7198.7060607@hardwarefreak.com>
	<AANLkTinpUmxQ6gMWPfyZsfUKjQZ_rGMETf3=BMu5o4Dj@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTinpUmxQ6gMWPfyZsfUKjQZ_rGMETf3=BMu5o4Dj@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: Mdadm <linux-raid@vger.kernel.org>, Matt Garman <matthew.garman@gmail.com>
List-Id: linux-raid.ids

disks are good for sequencial access
for non-sequencial ssd are better (the sequencial access rate for a
ssd is the same for a non sequencial access rate)

in my tests the best disk i used (15000rpm SAS 6gb 146gb) get a
sequencial read of 160MB/s (for random it=B4s slower)
a OCZ VERTEX2 SSD SATA2 (near USD 200, for 128GB) get min of 190MB/s
max of 270MB/s for random or sequencial read (maybe a disk isn=B4t a
good option today... the cost of ssd isn=B4t a problem today, i=B4m usi=
ng
vertez2 on one production server and the speed is really good)

the solution to get more speed today is raid0 (or another stripe raid s=
olution)
why? check example:

reading sector 1 to 10
using raid0, 2, hard disks, striping per sector

what today read do:

considering disks position=3D0
read sector 1
disk1 read, new position=3D1 (no access time, since the sector1 =3D dis=
k 1
position0)
read sector 2
disk2 read, new position=3D1 (no access time, since the sector2 =3D dis=
k 2
position0)
read sector 3
disk1 read, new position=3D2 (no access time, since the sector2 =3D dis=
k 2
position1)
=2E..


that=B4s why you get 2x the read speed for harddisks raid0 sequencial
read, the access time is very small for raid0 on a sequencial read, if
you use a random access you will have a bigger access time  since disk
must change head position, with a sequencial read the position isn=B4t
changed a lot

with raid1 using harddisk you can=B4t get the same speed as raid0
striping, since sector2 is position 2 in any disk, that=B4s why the
today raid1 read_balance use near head algorithm and if it can use
only one disk it will use just one disk

if you want try another read balance for raid1 i=B4m testing (benchmark=
ing) it at:
www.spadim.com.br/raid1/

when i get good benchmarks i will send to Neil to test and try to
adopt it on next md version
if you could help with benchmarks =3D) you are welcome =3D)
there=B4s many scenarios where diferent read_balance are better than ne=
ar_head
all solutions can use any read_balance
the time based is good for anyone, the problem is the number of
parameters to config it
the round robin is good for ssd since access time is the same for
random or sequencial read
the stripe is a round robin solution but i didn=B4t see any performace
improvement with it
the near head is good with hard disk


2011/2/15 Roberto Spadim <roberto@spadim.com.br>:
> if you want a hobby server
> a old computer with many pci-express slots
> many sata2 boards
> and a mdadm work
> no problem on speed
> the common bottle neck:
>
> 1)disk speed for sequencial read/write
> 2)disk speed for non-sequencial read/write
> 3)disk channel (SATA/SAS/other)
> 4)pci-express/pci/isa/other channel speed
> 5)ram memory speed
> 6)cpu use
>
> check that buffer on disk controllers just help with read speed, if
> you want more speed for read put more ram (file system cache) or
> controller cache
> another solution for big speed is ssd (for read/write it=B4s near a
> fixed speed rate), use raid0 when possible, raid1 just for mirroring
> (it=B4s not a speed improvement for writes, the write is done with th=
e
> rate of slowest disk, read can work near raid0 if using harddisk,
> better if use raid1)
>
> 2011/2/15 Stan Hoeppner <stan@hardwarefreak.com>:
>> Matt Garman put forth on 2/14/2011 5:59 PM:
>>
>>> The requirement is basically this: around 40 to 50 compute machines
>>> act as basically an ad-hoc scientific compute/simulation/analysis
>>> cluster. =A0These machines all need access to a shared 20 TB pool o=
f
>>> storage. =A0Each compute machine has a gigabit network connection, =
and
>>> it's possible that nearly every machine could simultaneously try to
>>> access a large (100 to 1000 MB) file in the storage pool. =A0In oth=
er
>>> words, a 20 TB file store with bandwidth upwards of 50 Gbps.
>>
>> If your description of the requirement is accurate, then what you ne=
ed is a
>> _reliable_ high performance NFS server backed by many large/fast spi=
ndles.
>>
>>> I was wondering if anyone on the list has built something similar t=
o
>>> this using off-the-shelf hardware (and Linux of course)?
>>
>> My thoughtful, considered, recommendation would be to stay away from=
 a DIY build
>> for the requirement you describe, and stay away from mdraid as well,=
 but not
>> because mdraid isn't up to the task. =A0I get the feeling you don't =
fully grasp
>> some of the consequences of a less than expert level mdraid admin be=
ing
>> responsible for such a system after it's in production. =A0If multip=
le drives are
>> kicked off line simultaneously (posts of such seem to occur multiple=
 times/week
>> here), downing the array, are you capable of bringing it back online=
 intact,
>> successfully, without outside assistance, in a short period of time?=
 =A0If you
>> lose the entire array due to a typo'd mdadm parm, then what?
>>
>> You haven't described a hobby level system here, one which you can f=
ix at your
>> leisure. =A0You've described a large, expensive, production caliber =
storage
>> resource used for scientific discovery. =A0You need to perform one v=
ery serious
>> gut check, and be damn sure you're prepared to successfully manage s=
uch a large,
>> apparently important, mdraid array when things go to the South pole =
in a
>> heartbeat. =A0Do the NFS server yourself, as mistakes there are more=
 forgiving
>> than mistakes at the array level. =A0Thus, I'd recommend the followi=
ng. =A0And as
>> you can tell from the length of it, I put some careful consideration=
 (and time)
>> into whipping this up.
>>
>> Get one HP ProLiant DL 385 G7 eight core AMD Magny Cours server for =
deployment
>> as your 64 bit Linux NFS server ($2500):
>> http://www.newegg.com/Product/Product.aspx?Item=3DN82E16859105806
>>
>> Eight 2.3GHz cores is actually overkill for this NFS server, but thi=
s box has
>> the right combination of price and other features you need. =A0The s=
tandard box
>> comes with 2x2GB DIMMs, using only 2 of the 4 channels of the occupi=
ed G34
>> socket, and 4GB is a tad short of what you'll need. =A0So toss the i=
nstalled DIMMs
>> and buy this HP certified 4 channel 16GB kit directly from Kingston =
($400):
>> http://www.ec.kingston.com/ecom/configurator_new/partsinfo.asp?root=3D=
us&LinkBack=3Dhttp://www.kingston.com&ktcpartno=3DKTH-PL313K4/16G
>>
>> This box has 4 GbE ports, which will give you max NFS throughput of =
~600-800
>> MB/s bidirectional, roughly 1/3rd to half the storage system bandwid=
th (see
>> below). =A0Link aggregation with the switch will help with efficienc=
y. =A0Set jumbo
>> frames across all the systems and switches obviously, MTU of 9000, o=
r the lowest
>> common denominator, regardless of which NIC solution you end up with=
=2E =A0If that's
>> not enough b/w...
>>
>> Add one of these PCI Express 2.0 x8 10 GbE copper Intel NICs ($600) =
to bump max
>> NFS throughput to ~1.5-2 GB/s bidirectional (assuming your switch ha=
s a copper
>> 10 GbE port):
>> http://www.newegg.com/Product/Product.aspx?Item=3DN82E16833106043
>> Due to using NFS+TCP/UDP as your protocols, this NIC can't outrun th=
e FC back
>> end, even though the raw signaling rate is slightly higher. =A0Howev=
er, if you
>> fired up 10-12 simultaneous FTP gets you'd come really close.
>>
>> Two of these for boot drives ($600):
>> http://www.newegg.com/Product/Product.aspx?Item=3DN82E16822332060
>> Mirror them with the onboard 256MB SmartArray BBWC RAID controller
>>
>> Qlogic PCIe 2.0 x4/x8 8Gbit FC HBA ($1100):
>> http://www.newegg.com/Product/Product.aspx?Item=3DN82E16833380014&cm=
_re=3Dqlogic-_-33-380-014-_-Product
>>
>> for connecting to the important part ($20-40K USD):
>> http://www.nexsan.com/satabeast.php
>>
>> 42 drives in a single 4U chassis, one RAID group or many, up to 254 =
LUNs or just
>> one, awesome capacity and performance for the price. =A0To keep cost=
s down yet
>> performance high, you'll want the 8Gbit FC single controller model w=
ith 2GB
>> cache (standard) and with qty 42* 1TB 7.2K rpm SATA drives. =A0All d=
rives use a
>> firmware revision tested and certified by Nexsan for use with their =
controllers
>> so you won't have problems with drives being randomly kicked offline=
, etc. =A0This
>> is an enterprise class SAN controller. =A0(Do some research and look=
 at Nexsan's
>> customers and what they're using these things for. =A0Caltech dumps =
the data from
>> the Spitzer space telescope to a group of 50-60 of these SATABeasts)=
=2E
>>
>> A SATABeast with 42 * 1TB drives should run in the ballpark of $20-4=
0K USD
>> depending on the reseller and your organization status (EDU, non pro=
fit,
>> government, etc). =A0Nexsan has resellers covering the entire Americ=
as and Europe.
>> =A0If you need to expand in the future, Nexsan offers the NXS-B60E e=
xpansion
>> chassis
>> (http://www.nexstor.co.uk/prod_pdfs/NXS-B60E_Nexsan%20NXS-B60E%20Dat=
asheet.pdf)
>> which holds 60 disks and plugs into the SATABeast with redundant mul=
tilane SAS
>> cables, allowing up to 102 drives in 8U of rack space, 204TB total u=
sing 2TB
>> drives, or any combination in between. =A0The NXS-B60E adds no addit=
ional
>> bandwidth to the system. =A0Thus, if you need more speed and space, =
buy a second
>> SATABeast and another FC card, or replace the single port FC card wi=
th a dual
>> port model (or buy the dual port up front)
>>
>> With the full 42 drive chassis configured as a 40 disk RAID 10 (2 sp=
ares) you'll
>> get 20TB usable space and you'll easily peak the 8GBit FC interface =
in both
>> directions simultaneously. =A0Aggregate random non-cached IOPS will =
peak at around
>> 3000, cached at 50,000. =A0The bandwidth figures may seem low to peo=
ple used to
>> "testing" md arrays with hdparm or dd and seeing figures of 500MB/s =
to 1GB/s
>> with only a handful of disks, however these are usually sequential _=
read_
>> figures only, on RAID 6 arrays, which have write performance often 2=
-3 times
>> lower. =A0In the real world, 1.6GB/s of sustained bidirectional rand=
om I/O
>> throughput while servicing dozens or hundreds of hosts is pretty phe=
nomenal
>> performance, especially in this price range. =A0The NFS server will =
most likely be
>> the bottleneck though, not this storage, definitely so if 4 bonded G=
bE
>> interfaces are used for NFS serving instead of the 10 GbE NIC.
>>
>> The hardware for this should run you well less than $50K USD for eve=
rything.
>> I'd highly recommend you create a single 40 drive RAID 10 array, as =
I mentioned
>> above with 2 spares, if you need performance as much as, if not more=
 than,
>> capacity--especially write performance. =A0A 40 drive RAID 10 on thi=
s SATABeast
>> will give you performance almost identical to a 20 disk RAID 0 strip=
e. =A0If you
>> need additional capacity more than speed, configure 40 drives as a R=
AID 6. =A0The
>> read performance will be similar, although the write performance wil=
l take a big
>> dive with 40 drives and dual parity.
>>
>> Configure 90-95% of the array as one logical drive and save the othe=
r 5-10% for
>> a rainy day--you'll be glad you did. =A0Export the logical drive as =
a single LUN.
>> =A0Format that LUN as XFS. =A0Visit the XFS mailing list and ask for=
 instructions on
>> how best to format and mount it. =A0Use the most recent Linux kernel=
 available,
>> 2.6.37 or later, depending on when you actually build the NFS server=
--2.6.38/39
>> if they're stable. =A0If you get Linux+XFS+NFS configured and runnin=
g optimally,
>> you should be more than impressed and satisfied with the performance=
 and
>> reliability of this combined system.
>>
>> I don't work for any of the companies whose products are mentioned a=
bove. =A0I'm
>> merely a satisfied customer of all of them. =A0The Nexsan products h=
ave the lowest
>> price/TB of any SAN storage products on the market, and the highest
>> performance/dollar, and lowest price per watt of power consumption. =
=A0They're
>> easy as cake to setup and manage with a nice GUI web interface over =
an ethernet
>> management port.
>>
>> Hope you find this information useful. =A0Feel free to contact me di=
rectly if I
>> can be of further assistance.
>>
>> --
>> Stan
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
