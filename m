From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: SSD - TRIM command
Date: Mon, 21 Feb 2011 19:38:13 +0000
Message-ID: <AANLkTinPrCw+wTns6Jb8ZNwwMPoKuV9sr5LXqjPtJyUn@mail.gmail.com>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTikR+bKrGUCxnsnNz0vJVGOWoPiP0b618sZNBdqU@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: Phillip Susi <psusi@cfl.rr.com>, David Brown <david@westcontrol.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 21 February 2011 19:32, Roberto Spadim <roberto@spadim.com.br> wrote=
:
> TRIM isn=C2=B4t a problem, it=C2=B4s a solution to optimize dynamic a=
llocation,
> and life time of devices (SSD or harddisk)
> i don=C2=B4t see any problem to implement trim command on hard disks =
(not
> in linux, but at harddisk firmware level)
>
> hard disk have the same problem of ssd, allocation of badblocks, any
> harddisk could implement trim and use it to realloc badblocks...
>
> --
> Roberto Spadim
> Spadim Technology / SPAEmpresarial
>

I don't think you understand TRIM. It wouldn't work, and there is no
need for it, on a HDD. AFAIK a HDD does not have the same penalty as a
SSD does when it needs to write to a (previously) used area. An SSD
cannot do this without erasing the whole (block? page?), usually 512KB
in size (varies between different manufacturers), but the data that's
on there still needs to be moved elsewhere first, block erased, data
moved back the same time the new data is written together with it.
AFAIK it works something like this anyway. The only benefit TRIM will
give you would be potentially faster writes, right.

// M
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
