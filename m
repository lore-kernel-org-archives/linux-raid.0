From: Mike Viau <viaum@sheridanc.on.ca>
Subject: RE: How to recreate a dmraid RAID array with mdadm (was: no subject)
Date: Tue, 16 Nov 2010 21:27:19 -0500
Message-ID: <BAY148-w57593947743EF205225D2AEF380@phx.gbl>
References: <BAY148-w337E193E7493BB69F27B31EF350@phx.gbl>,<20101115162122.4fef2542@notabene.brown>,<BAY148-w211AE8BF243615980CE527EF380@phx.gbl>,<20101117122647.48c7b67a@notabene.brown>
 <4CE3325B.7050208@anonymous.org.uk>,<20101117125337.2ca80775@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101117125337.2ca80775@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, john.robinson@anonymous.org.uk
Cc: linux-raid@vger.kernel.org, debian-user@lists.debian.org
List-Id: linux-raid.ids


> On Wed, 17 Nov 2010 12:53:37 +1100 <neilb@suse.de> wrote:
> On Wed, 17 Nov 2010 01:39:39 +0000
> John Robinson  wrote:
>
> > On 17/11/2010 01:26, Neil Brown wrote:
> > > On Tue, 16 Nov 2010 20:02:17 -0500
> > > Mike Viau wrote:
> > [...]
> > >> DEVICE partitions
> > >> HOMEHOST
> > >> ARRAY metadata=3Dimsm UUID=3D084b969a:0808f5b8:6c784fb7:62659383
> > >> ARRAY /dev/md/OneTB-RAID1-PV container=3D084b969a:0808f5b8:6c784=
fb7:62659383 member=3D0 UUID=3Dae4a1598:72267ed7:3b34867b:9c56497a
> > [...]
> > > I would really expect that mdadm.conf file to successfully assemb=
le the
> > > RAID1.
> >
> > The only thing that strikes me is that "DEVICE partitions" line - s=
urely
> > imsm containers don't live in partitions?
>
> No, they don't.
>
> But "DEVICE partitions" actually means "any devices listed
> in /proc/partitions", and that includes whole devices.
> :-(
>

I noticed both /dev/sda and /dev/sdb (the drives which make up the raid=
1 array) do not appear to recognized as having a valid container when o=
ne is required. The output of mdadm -Asvv shows:

mdadm -Asvv
mdadm: looking for devices for further assembly
mdadm: no RAID superblock on /dev/dm-3
mdadm: /dev/dm-3 has wrong uuid.
mdadm: no RAID superblock on /dev/dm-2
mdadm: /dev/dm-2 has wrong uuid.
mdadm: no RAID superblock on /dev/dm-1
mdadm: /dev/dm-1 has wrong uuid.
mdadm: no RAID superblock on /dev/dm-0
mdadm: /dev/dm-0 has wrong uuid.
mdadm: no RAID superblock on /dev/loop0
mdadm: /dev/loop0 has wrong uuid.
mdadm: cannot open device /dev/sdc7: Device or resource busy
mdadm: /dev/sdc7 has wrong uuid.
mdadm: cannot open device /dev/sdc6: Device or resource busy
mdadm: /dev/sdc6 has wrong uuid.
mdadm: cannot open device /dev/sdc5: Device or resource busy
mdadm: /dev/sdc5 has wrong uuid.
mdadm: no RAID superblock on /dev/sdc2
mdadm: /dev/sdc2 has wrong uuid.
mdadm: cannot open device /dev/sdc1: Device or resource busy
mdadm: /dev/sdc1 has wrong uuid.
mdadm: cannot open device /dev/sdc: Device or resource busy
mdadm: /dev/sdc has wrong uuid.
mdadm: cannot open device /dev/sdb: Device or resource busy
mdadm: /dev/sdb has wrong uuid.
mdadm: cannot open device /dev/sda: Device or resource busy
mdadm: /dev/sda has wrong uuid.
mdadm: looking for devices for /dev/md/OneTB-RAID1-PV
mdadm: no recogniseable superblock on /dev/dm-3
mdadm/dev/dm-3 is not a container, and one is required.
mdadm: no recogniseable superblock on /dev/dm-2
mdadm/dev/dm-2 is not a container, and one is required.
mdadm: no recogniseable superblock on /dev/dm-1
mdadm/dev/dm-1 is not a container, and one is required.
mdadm: no recogniseable superblock on /dev/dm-0
mdadm/dev/dm-0 is not a container, and one is required.
mdadm: no recogniseable superblock on /dev/loop0
mdadm/dev/loop0 is not a container, and one is required.
mdadm: cannot open device /dev/sdc7: Device or resource busy
mdadm/dev/sdc7 is not a container, and one is required.
mdadm: cannot open device /dev/sdc6: Device or resource busy
mdadm/dev/sdc6 is not a container, and one is required.
mdadm: cannot open device /dev/sdc5: Device or resource busy
mdadm/dev/sdc5 is not a container, and one is required.
mdadm: no recogniseable superblock on /dev/sdc2
mdadm/dev/sdc2 is not a container, and one is required.
mdadm: cannot open device /dev/sdc1: Device or resource busy
mdadm/dev/sdc1 is not a container, and one is required.
mdadm: cannot open device /dev/sdc: Device or resource busy
mdadm/dev/sdc is not a container, and one is required.
mdadm: cannot open device /dev/sdb: Device or resource busy
mdadm/dev/sdb is not a container, and one is required.
mdadm: cannot open device /dev/sda: Device or resource busy
mdadm/dev/sda is not a container, and one is required.


and cat /proc/partitions shows:

major minor=A0 #blocks=A0 name

=A0=A0 8=A0=A0=A0=A0=A0=A0=A0 0=A0 976762584 sda
=A0=A0 8=A0=A0=A0=A0=A0=A0 16=A0 976762584 sdb
=A0=A0 8=A0=A0=A0=A0=A0=A0 32=A0=A0 78125000 sdc
=A0=A0 8=A0=A0=A0=A0=A0=A0 33=A0=A0=A0=A0 487424 sdc1
=A0=A0 8=A0=A0=A0=A0=A0=A0 34=A0=A0=A0=A0=A0=A0=A0=A0=A0 1 sdc2
=A0=A0 8=A0=A0=A0=A0=A0=A0 37=A0=A0 20995072 sdc5
=A0=A0 8=A0=A0=A0=A0=A0=A0 38=A0=A0=A0 7811072 sdc6
=A0=A0 8=A0=A0=A0=A0=A0=A0 39=A0=A0 48826368 sdc7
=A0=A0 7=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=A0 4388218 loop0
=A0254=A0=A0=A0=A0=A0=A0=A0 0=A0=A0 10485760 dm-0
=A0254=A0=A0=A0=A0=A0=A0=A0 1=A0=A0 10485760 dm-1
=A0254=A0=A0=A0=A0=A0=A0=A0 2=A0=A0 10485760 dm-2
=A0254=A0=A0=A0=A0=A0=A0=A0 3=A0=A0 17367040 dm-3

 		 	   		  --
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
