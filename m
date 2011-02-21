From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: SSD - TRIM command
Date: Mon, 21 Feb 2011 19:39:44 +0000
Message-ID: <AANLkTik7=t_QsMyk9ogmg6ygZzEL=ErTP24OWz8Zsb+w@mail.gmail.com>
References: <AANLkTikfeH_n04iJ=5e=_G4a_GrxiWyZNJ1oCYyiBhNO@mail.gmail.com>
	<4D517F4F.4060003@gmail.com>
	<4D5245DF.4020401@hardwarefreak.com>
	<iiu4rc$9ju$1@dough.gmane.org>
	<AANLkTi=WNk3=3Jwm-YJeujcrdh-OQ4W4mJrq+YJ5Xv4k@mail.gmail.com>
	<iiud2r$qci$1@dough.gmane.org>
	<4D62ACFE.4020401@cfl.rr.com>
	<AANLkTim6qJRZABYj4y_1sL6xq7y_w-STbaC4MK3U05ug@mail.gmail.com>
	<AANLkTimxTBTGupRk_1nSajjoWBstHdzVVpF4kEN3Y6XU@mail.gmail.com>
	<AANLkTikR+bKrGUCxnsnNz0vJVGOWoPiP0b618sZNBdqU@mail.gmail.com>
	<AANLkTinPrCw+wTns6Jb8ZNwwMPoKuV9sr5LXqjPtJyUn@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTinPrCw+wTns6Jb8ZNwwMPoKuV9sr5LXqjPtJyUn@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: Phillip Susi <psusi@cfl.rr.com>, David Brown <david@westcontrol.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 21 February 2011 19:38, Mathias Bur=C3=A9n <mathias.buren@gmail.com>=
 wrote:
> On 21 February 2011 19:32, Roberto Spadim <roberto@spadim.com.br> wro=
te:
>> TRIM isn=C2=B4t a problem, it=C2=B4s a solution to optimize dynamic =
allocation,
>> and life time of devices (SSD or harddisk)
>> i don=C2=B4t see any problem to implement trim command on hard disks=
 (not
>> in linux, but at harddisk firmware level)
>>
>> hard disk have the same problem of ssd, allocation of badblocks, any
>> harddisk could implement trim and use it to realloc badblocks...
>>
>> --
>> Roberto Spadim
>> Spadim Technology / SPAEmpresarial
>>
>
> I don't think you understand TRIM. It wouldn't work, and there is no
> need for it, on a HDD. AFAIK a HDD does not have the same penalty as =
a
> SSD does when it needs to write to a (previously) used area. An SSD
> cannot do this without erasing the whole (block? page?), usually 512K=
B
> in size (varies between different manufacturers), but the data that's
> on there still needs to be moved elsewhere first, block erased, data
> moved back the same time the new data is written together with it.
> AFAIK it works something like this anyway. The only benefit TRIM will
> give you would be potentially faster writes, right.
>
> // M
>

Plus support is needed from the kernel (done) filesystem (ext4 has
it). The filesystem seese the MD device, not the actual SSDs behind
it, so it would probably be quite complicated to implement passthrough
of the trim command in this case.

// M
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
