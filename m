From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: RAID HDDs spin up sequence
Date: Mon, 31 Jan 2011 19:09:24 -0200
Message-ID: <AANLkTinPTaDfVtjMfz7DHUa95cKFF7MZeg=WhuuTnZM8@mail.gmail.com>
References: <20110131201823.GA15704@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110131201823.GA15704@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

you psu must be dimensioned to work with everythink at full work load
(it=B4s a real production NAS right?! not a test)
your SAS/IDE/SATA controller and HDD manual should be checked
how hdd wake up? one command (read/write) over sata/sas/ide channel wak=
e it up?
on linux raid we have a read algorithm and a write algorithm
if a raid1 write occur all disks will wake up
if a raid1 (raid0 or another) read occur only the disk will wake up

but check you SATA/IDE/SATA controller, how it wake up your disk, and
how you hdd wake up

2011/1/31 Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>:
> Hi all,
>
> assuming there is a NAS, with, for example, 10 HDDs
> in RAID-6. Assuming the HDDs are put in standby, in
> order to save energy, when the NAS is not used.
> How is the spin up sequence when the corresponding
> /dev/mdX device is accessed?
> Will the system spin up one HDD at time or all together?
>
> Obviously, one at time will limit the peak current,
> thus allowing a better dimensioned PSU, working almost
> always around the optimal efficiency point.
>
> Thanks a lot for any information on the topic,
>
> bye,
>
> --
>
> piergiorgio
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
