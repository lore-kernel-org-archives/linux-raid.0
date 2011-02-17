From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: high throughput storage server?
Date: Thu, 17 Feb 2011 11:36:49 -0200
Message-ID: <AANLkTi=4TbNNfYQTStryyK9=pW-KD_JqO=ZmCkiH8MvL@mail.gmail.com>
References: <AANLkTik5_Zx98rSbmpgUtG82qtFObANtCcbnn-a7MXcp@mail.gmail.com>
	<4D5D017B.50109@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D5D017B.50109@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: Matt Garman <matthew.garman@gmail.com>, Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

with more network cards =3D more network gbps
with better (faster) rams =3D more disks reads
with more raid0/4/5/6 =3D more speed on disks reads
with more raid1 mirrors =3D more security
with more sas/sata/raid controllers =3D more GB/TB on storage
with more anything ~=3D more money
just know what numbers you want and make it work

2011/2/17 John Robinson <john.robinson@anonymous.org.uk>:
> On 14/02/2011 23:59, Matt Garman wrote:
> [...]
>>
>> The requirement is basically this: around 40 to 50 compute machines
>> act as basically an ad-hoc scientific compute/simulation/analysis
>> cluster. =A0These machines all need access to a shared 20 TB pool of
>> storage. =A0Each compute machine has a gigabit network connection, a=
nd
>> it's possible that nearly every machine could simultaneously try to
>> access a large (100 to 1000 MB) file in the storage pool. =A0In othe=
r
>> words, a 20 TB file store with bandwidth upwards of 50 Gbps.
>
> I'd recommend you analyse that requirement more closely. Yes, you hav=
e 50
> compute machines with GigE connections so it's possible they could al=
l
> demand data from the file store at once, but in actual use, would the=
y?
>
> For example, if these machines were each to demand a 100MB file, how =
long
> would they spend computing their results from it? If it's only 1 seco=
nd,
> then you would indeed need an aggregate bandwidth of 50Gbps[1]. If it=
's 20
> seconds processing, your filer only needs an aggregate bandwidth of 2=
=2E5Gbps.
>
> So I'd recommend you work out first how much data the compute machine=
s can
> actually chew through and work up from there, rather than what their =
network
> connections could stream through and work down.
>
> Cheers,
>
> John.
>
> [1] I'm assuming the compute nodes are fetching the data for the next
> compute cycle while they're working on this one; if they're not you'r=
e
> likely making unnecessary demands on your filer while leaving your co=
mpute
> nodes idle.
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
