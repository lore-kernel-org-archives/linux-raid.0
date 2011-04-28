From: Gavin Flower <gavinflower@yahoo.com>
Subject: Re: RAID6 data-check took almost 2 hours, clicking sounds, system unresponsive
Date: Thu, 28 Apr 2011 13:03:39 -0700 (PDT)
Message-ID: <327628.84887.qm@web65101.mail.ac2.yahoo.com>
References: <4DA773EB.5030005@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DA773EB.5030005@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: =?iso-8859-1?Q?Mathias_Bur=E9n?= <mathias.buren@gmail.com>, neilb@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--- On Fri, 15/4/11, Phil Turmel <philip@turmel.org> wrote:

> From: Phil Turmel <philip@turmel.org>
> Subject: Re: RAID6 data-check took almost 2 hours, clicking sounds, s=
ystem unresponsive
> To: "Gavin Flower" <gavinflower@yahoo.com>
> Cc: "Mathias Bur=E9n" <mathias.buren@gmail.com>, neilb@suse.de, linux=
-raid@vger.kernel.org
> Date: Friday, 15 April, 2011, 10:23
> On 04/14/2011 05:12 PM, Gavin Flower
> wrote:
>=20
> >=20
> > Hi Phil,
> >=20
> > I was under the impression that I had an adequate
> power supply, so I checked all 5 drives.=A0=20
[...]
> >=20
> > Note that Power_Cycle_Count is anomalous only for
> /dev/sdc, so would this suggest cable problems?
>=20
> No two drives are perfectly identical, so when the drive's
> power rail is only slightly overloaded, the least tolerant
> drive chokes as the voltage declines (we're talking tens of
> milliseconds, here).=A0 As soon as it chokes, the extra
> load disappears, and the power supply recovers.=A0 The
> other drives carry on.=A0 The drive that choked resets
> (*Click*) in time for the block driver to try again, and the
> cycle repeats.
>=20
> As a test, borrow another power supply and hook just that
> one drive to it.=A0 If the problem continues, the drive
> is toast.=A0 If the problem goes away, look for a better
> power supply.=A0 Note:=A0 for the Barracuda with the
> problem, the detailed spec says the 5V load spikes on
> activity, not the 12V load.=A0 So make sure the current
> capacity of the power supply meets your needs for both 5V
> & 12V (plus your motherboard).=A0 Also check if the
> power supply has multiple regulators for drive power, and if
> you need to re-arrange the connectors to spread the load
> evenly amongst them.
>=20
> As another test, you can swap all your cables around.=A0
> If the problem is in the cables, the problem will follow the
> cables to the drive you moved them to.
>=20
> > I am not sure what to make of the other
> discrepancies.
> >=20
> > Note that sda, sdb, sdd, & sde were bought and put
> in at the same time, while sdc was only obtained and
> inserted recently.
>=20
> So sdc came from a different manufacturing batch, which is
> likely to have slightly different tolerances.
>=20
> HTH,
>=20
> Phil

Thanks Phil,

A few days ago, I noticed that 2 of my 3 RAID arrays were down to 4 out=
 of 5 drives - /dev/sdc had been dropped out, the one which made clicki=
ng sounds when I ran badblocks.

A couple of days ago, my friend Mario brought over his oscilloscope and=
 a volt meter.  The 5 volt rail was showing about 4.7 volts, typically =
it should be 5.2 - 5.4 (from memory of what he said), and the voltage l=
ooked shaky on the oscilloscope.  The old power supply rated at 400 Wat=
ts. =20

Mario suggested that power supplies greater than 500 Watts had signific=
antly better quality, also he and others said that power supplies tende=
d to have reduced capability to supply their maximum power as they age.=
  So while, 400 Watts seemed nominally adequate for my system, I starte=
d looking for ones that wee at least 500 Watts, I also looked at other =
features, such as reliability and the ability to support at least 5 sat=
a drives without using adapters.

I was in the process of checking out various power supplies, when my de=
velopment machine ('saturn') refused to complete the boot process due t=
o RAID problems.

There are many power supplies that would have met my requirements, but =
I told Mario that I was prepared to pay a bit extra, if there was real =
benefit, as I saw no point in being penny wise and pound foolish as the=
y say in England.  If the time Mario and I (let alone that of the other=
s who advised me) had spent on this problem was costed, it would have b=
een more than double the price of the power supply, so I figured paying=
 a bit extra was a good investment. The one Mario obtained for me was t=
he one in stock that met my needs without being too expensive.  The new=
 one is 700 Watts with reasonably robust specifications: Cooler Master =
Extreme Power Plus 700W. MTBF  > 100,000 hours (11 years), high efficie=
ncy 80% at typical load...

Reassembling the 2 defective RAID-6 partitions went okay, now all 3 RAI=
D partitions are complete.

Been running over 16 hours now and no apparent problems.  I ran badbloc=
ks on all 5 disks concurrently - no clicking sounds were heard, nor wer=
e any errors reported. Also the 'ata' errors previously seen on the sys=
tems log are absent.

I very much appreciate the help provided to me by the people on this li=
st.


Regards,
Gavin
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
