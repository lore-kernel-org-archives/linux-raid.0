From: Drew <drew.kay@gmail.com>
Subject: Re: A few remaining questions about installing to RAID-10
Date: Mon, 5 Oct 2009 08:49:37 -0700
Message-ID: <c268e4660910050849mc4bba01ifbb1a57caf59c41a@mail.gmail.com>
References: <20091005145711322.FNMG18886@cdptpa-omta02.mail.rr.com>
	<556491.46402.qm@web38805.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <556491.46402.qm@web38805.mail.mud.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: adfas asd <chimera_god@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> WAT?! =C2=A0How can I mount an unpartitioned/unformatted array? =C2=A0=
This is more direct than using a filesystem, although there would be no=
 journalling, right? =C2=A0If I were to mount my small disk for / and t=
he unpartitioned array as /home for example.

What's he's saying is that RAID and LVM do not need partitions to work
properly. You can create a raid array on the raw(unpartitioned)
/dev/sdX devices and then create a LVM volume group using a physical
volume(PV) on a raw(unpartitioned) /dev/mdX (RAID) device.

The filesystem still needs a partition/volume but that can created
either by partitioning /dev/mdX *or* creating a logical volume in LVM.

=46or example, on my system at home I use RAID-6 created using
/dev/sd[b-f]. The resulting /dev/md0 acts as a physical volume for LVM
and I've created several Logical Volumes aka "partitions" for the
filesystems to reside in.

> Seems like journalling/crash recovery is pretty vital. =C2=A0Could no=
t partitioning be recommendable?

See above. You still have a partition/volume of some sort where the
filesystem is created.


--=20
Drew

"Nothing in life is to be feared. It is only to be understood."
--Marie Curie
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
