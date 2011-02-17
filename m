From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: high throughput storage server?
Date: Thu, 17 Feb 2011 11:54:36 -0200
Message-ID: <AANLkTimdxUPRnS8AwDeNaoZETVZ8vsL_D_yTWnTqjOeO@mail.gmail.com>
References: <AANLkTik5_Zx98rSbmpgUtG82qtFObANtCcbnn-a7MXcp@mail.gmail.com>
	<4D5D017B.50109@anonymous.org.uk>
	<AANLkTi=4TbNNfYQTStryyK9=pW-KD_JqO=ZmCkiH8MvL@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=4TbNNfYQTStryyK9=pW-KD_JqO=ZmCkiH8MvL@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: Matt Garman <matthew.garman@gmail.com>, Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

building it on only one machine...
if you want 50gbps, put six (one more) for network access (you need
many pci-express slots with 4x(10gbps) or 8x(20gbps))
i use raid10 for redundancy and speed
you can do raid1 for redundancy and after raid0,4,5,6 over raid1
devices for better speed

sata/sas/raid controllers? sata is very cheap you can use SSD with
sata2 interface, sas have fasters (less accestime) hard disks with
10k/15k rpm

ram? with more ran =3D more cache/buffers low disks usage, more read sp=
eed
cpu? i don't know what to use, but it's a big machine maybe you need
servers motherboards (5 pci-express just for network =3D big
motherboard, big motherboard =3D many cpus) try with only one cpu with
6cores hiperthread, etc. if it's not enought put a second cpu

operational system? linux with md =3D), it's a md list heehhe, maybe a
netbsd or freebsd or windows works too
file server? nfs, samba
filesystem? hummmmmm a cluster fs is good here, but a single ext4,
xfs, reiserfs could work, your energy is good? you want jornaling?
redundancy/cluster? beowolf openmosix, others. heartbeat, placemark, ot=
hers.
sql database? mysql have ndb for clusters, myisam is fast without some
features, innodb is slower with many features, ariadb =3D myisam but
slower to write with fail safe feature. oracle is good but mysql is
low resource consuming. postgres is nice too, maybe you app will tell
you what to use
network? many 10gbit with bounding(linux module) on round robin or
another good(working) loadbalance

2011/2/17 Roberto Spadim <roberto@spadim.com.br>:
> with more network cards =3D more network gbps
> with better (faster) rams =3D more disks reads
> with more raid0/4/5/6 =3D more speed on disks reads
> with more raid1 mirrors =3D more security
> with more sas/sata/raid controllers =3D more GB/TB on storage
> with more anything ~=3D more money
> just know what numbers you want and make it work
>
> 2011/2/17 John Robinson <john.robinson@anonymous.org.uk>:
>> On 14/02/2011 23:59, Matt Garman wrote:
>> [...]
>>>
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
>> I'd recommend you analyse that requirement more closely. Yes, you ha=
ve 50
>> compute machines with GigE connections so it's possible they could a=
ll
>> demand data from the file store at once, but in actual use, would th=
ey?
>>
>> For example, if these machines were each to demand a 100MB file, how=
 long
>> would they spend computing their results from it? If it's only 1 sec=
ond,
>> then you would indeed need an aggregate bandwidth of 50Gbps[1]. If i=
t's 20
>> seconds processing, your filer only needs an aggregate bandwidth of =
2.5Gbps.
>>
>> So I'd recommend you work out first how much data the compute machin=
es can
>> actually chew through and work up from there, rather than what their=
 network
>> connections could stream through and work down.
>>
>> Cheers,
>>
>> John.
>>
>> [1] I'm assuming the compute nodes are fetching the data for the nex=
t
>> compute cycle while they're working on this one; if they're not you'=
re
>> likely making unnecessary demands on your filer while leaving your c=
ompute
>> nodes idle.
>>
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
