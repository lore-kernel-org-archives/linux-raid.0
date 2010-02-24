From: Jon Hardcastle <jd_hardcastle@yahoo.com>
Subject: Re: Fwd: Majordomo results: Re: Majordomo results: .
Date: Wed, 24 Feb 2010 01:07:51 -0800 (PST)
Message-ID: <61113.94788.qm@web51303.mail.re2.yahoo.com>
References: <e4ae6451002240054q4cb517a3m4715046647e2d68c@mail.gmail.com>
Reply-To: Jon@eHardcastle.com
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e4ae6451002240054q4cb517a3m4715046647e2d68c@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, Felipe Alvarez <felipe.alvarez@gmail.com>
List-Id: linux-raid.ids




--- On Wed, 24/2/10, Felipe Alvarez <felipe.alvarez@gmail.com> wrote:

> From: Felipe Alvarez <felipe.alvarez@gmail.com>
> Subject: Fwd: Majordomo results: Re: Majordomo results: .
> To: linux-raid@vger.kernel.org
> Date: Wednesday, 24 February, 2010, 8:54
> Hi list. I've 4 X 320GB Sata disks in
> Raid 5 (mdadm - v2.6.7.1 - 15th
> October 2008). They all have a 0xFD raid autodetect
> parition, filling
> 100% of the drives. One drive failed, and I bought a 500GB
> disk
> (instead of 320GB). Should I just add /dev/sde as-is,
> allowing mdadm
> to automatically rebuild it as required? Or, should I
> partition it to
> exact same dimensions/size as the other disks, with
> part-type 0xFD?
> TIA
>=20
> Felipe
> end
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at=A0 http://vger.kernel.org/majordomo-info.html
>=20

AFAIK

You can - after you have failed/removed etc the old drive. Create a new=
 partition that is the same type - but not necessarily the identical si=
ze(i.e. fill the whole drive if you like but not smaller) and add it to=
 the array.

The beauty of that being that when all the drives have been retired/fai=
led and the smallest partition size is now 500GB or whatever you can --=
grow=3Dmax and get that unused space.

-----------------------
N: Jon Hardcastle
E: Jon@eHardcastle.com
'Do not worry about tomorrow, for tomorrow will bring worries of its ow=
n.'

***********
Please note, I am phasing out jd_hardcastle AT yahoo.com and replacing =
it with jon AT eHardcastle.com
***********

-----------------------


     =20
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
