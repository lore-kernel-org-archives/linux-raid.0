From: Neil Brown <neilb@suse.de>
Subject: Re: How to recreate a dmraid RAID array with mdadm
Date: Tue, 23 Nov 2010 10:11:29 +1100
Message-ID: <20101123101129.7ff37234@notabene.brown>
References: <BAY148-w65577551281F75C185BEBEF380@phx.gbl>
	<20101117141514.759d9eea@notabene.brown>
	<BAY148-w18A88E7D84CE0213B44F26EF380@phx.gbl>
	<20101118111149.7b5004a2@notabene.brown>
	<BAY148-w607755AA342EF4ACCCC9A5EF390@phx.gbl>
	<20101118122847.1530d86c@notabene.brown>
	<BAY148-w149179108DC6D340247236EF390@phx.gbl>
	<20101118133247.7ffa99d1@notabene.brown>
	<BAY148-w494B0F5EB60CC742DFC817EF390@phx.gbl>
	<20101118141718.44c1837f@notabene.brown>
	<BAY148-w508672292A737E86BE8332EF390@phx.gbl>
	<20101118163849.7e63b4d0@notabene.brown>
	<BAY148-w47CEC117EA632A5DA3987EF3D0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=Windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BAY148-w47CEC117EA632A5DA3987EF3D0@phx.gbl>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Viau <viaum@sheridanc.on.ca>
Cc: linux-raid@vger.kernel.org, debian-user@lists.debian.org
List-Id: linux-raid.ids


I see the problem now.  And John Robinson was nearly there.

The problem is that after assembling the container /dev/md/imsm,
mdadm needs to assemble the RAID1, but doesn't find the
container /dev/md/imsm to assemble it from.
That is because of the
  DEVICE partitions
line.
A container is not a partition - it does not appear in /proc/partitions=
=2E
You need

  DEVICE partitions containers

which is the default if you don't have a DEVICE line (and I didn't have=
 a
device line in my testing).

I think all the "wrong uuid" messages were because the device was busy =
(and
so it didn't read a uuid), probably because you didn't "mdadm -Ss" firs=
t.

So just remove the "DEVICE partitions" line, or add " containers" to it=
, and=20
all should be happy.

NeilBrown



On Mon, 22 Nov 2010 13:07:10 -0500
Mike Viau <viaum@sheridanc.on.ca> wrote:

>=20
> > On Thu, 18 Nov 2010 16:38:49 +1100 <neilb@suse.de> wrote:
> > > > On Thu, 18 Nov 2010 14:17:18 +1100  wrote:
> > > > >
> > > > > > On Thu, 18 Nov 2010 13:32:47 +1100 wrote:
> > > > > > > ./mdadm -Ss
> > > > > > >
> > > > > > > mdadm: stopped /dev/md127
> > > > > > >
> > > > > > >
> > > > > > > ./mdadm -Asvvv
> > > > > > >
> > > > > > > mdadm: looking for devices for further assembly
> > > > > > > mdadm: no RAID superblock on /dev/dm-3
> > > > > > > mdadm: /dev/dm-3 has wrong uuid.
> > > > > > > want UUID-084b969a:0808f5b8:6c784fb7:62659383
> > > > > > > Segmentation fault
> > > > > >
> > > > > > Try this patch instead please.
> > > > >
> > > > > Applied new patch and got:
> > > > >
> > > > > ./mdadm -Ss
> > > > >
> > > > > mdadm: stopped /dev/md127
> > > > >
> > > > >
> > > > > ./mdadm -Asvvv
> > > > > mdadm: looking for devices for further assembly
> > > > > mdadm: no RAID superblock on /dev/dm-3
> > > > > mdadm: /dev/dm-3 has wrong uuid.
> > > > > want UUID-084b969a:0808f5b8:6c784fb7:62659383
> > > > > tst=3D0x10dd010 sb=3D(nil)
> > > > > Segmentation fault
> > > >
> > > > Sorry... I guess I should have tested it myself..
> > > >
> > > > The
> > > > if (tst) {
> > > >
> > > > Should be
> > > >
> > > > if (tst && content) {
> > > >
> > >
> > > Apply update and got:
> > >
> > > mdadm: /dev/sdb is identified as a member of /dev/md/imsm0, slot =
-1.
> > > mdadm: /dev/sda is identified as a member of /dev/md/imsm0, slot =
-1.
> > > mdadm: added /dev/sda to /dev/md/imsm0 as -1
> > > mdadm: added /dev/sdb to /dev/md/imsm0 as -1
> > > mdadm: Container /dev/md/imsm0 has been assembled with 2 drives
> > > mdadm: looking for devices for /dev/md/OneTB-RAID1-PV
> >
> > So just to clarify.
> >
> > With the Debian mdadm, which is 3.1.4, if you
> >
> > mdadm -Ss
> > mdadm -Asvv
> >
> > it says (among other things) that /dev/sda has wrong uuid.
> > and doesn't start the array.
>=20
> Actually both compiled and Debian do not start the array. Or atleast =
create the /dev/md/OneTB-RAID1-PV device when running mdadm -I /dev/md/=
imsm0 does.
>=20
> You are right about seeing a message on /dev/sda about having a wrong=
 uuid somewhere though.=A0 I went back to take a look at my output from=
 the Debian mailing list to see that the mdadm did change slightly from=
 this thread has begun.
>=20
> The old output was copied verbatim on http://lists.debian.org/debian-=
user/2010/11/msg01234.html and says (among other things) that /dev/sda =
has wrong uuid.
>=20
> The /dev/sd[ab] has wrong uuid messages are missing from the mdadm -A=
svv output but....
>=20
> ./mdadm -Ivv /dev/md/imsm0=20
> mdadm: UUID differs from /dev/md/OneTB-RAID1-PV.
> mdadm: match found for member 0
> mdadm: Started /dev/md/OneTB-RAID1-PV with 2 devices
>=20
>=20
> I still have this UUID message when still using the mdadm -I command.
>=20
>=20
> I'll attach the output of both the mdadm commands above as they run n=
ow on the system, but I noticed, but also that in the same thread link =
above, with the old output I was inqurying as to both /dev/sda and /dev=
/sdb (the drives which make up the raid1 array) do not appear to recogn=
ized as having a valid container when one is required.
>=20
> What is take on GeraldCC (gcsgcatling@bigpond.com) assistance about /=
dev/sd[ab] containing a 8e (for LVM) partition type, rather than the fd=
 type to denote raid autodetect. If this was the magical fix (which I a=
m not saying it can=92t be) why is mdadm -I /dev/md/imsm0 able to bring=
 up the array for use as an physical volume for LVM?
>=20
>=20
>=20
> >
> > But with the mdadm you compiled yourself, which is also 3.1.4,
> > if you
> >
> > mdadm -Ss
> > mdadm -Asvv
> >
> > then it doesn't give that message, and it works.
>=20
> Again, actually both compiled and Debian do not start the array. Or a=
tleast
> create the /dev/md/OneTB-RAID1-PV device when running mdadm -I
> /dev/md/imsm0 does.
>=20
> >
> > That is very strange. It seems that the Debian mdadm is broken some=
how, but
> > I'm fairly sure Debian hardly changes anything - they are *very* go=
od at
> > getting their changes upstream first.
> >
> > I don't suppose you have an /etc/mdadm.conf as well as /etc/mdadm/m=
dadm.conf
> > do you? If you did and the two were different, the Debian's mdadm w=
ould
> > behave a bit differently to upstream (they prefer different config =
files) but
> > I very much doubt that is the problem.
> >
>=20
> There is no /etc/mdadm.conf on the filesystem only /etc/mdadm/mdadm.c=
onf
>=20
>=20
> > But I guess if the self-compiled one works (even when you take the =
patch
> > out), then just
> > make install
>=20
> I wish this was the case...
>=20
> >
> > and be happy.
> >
> > NeilBrown
> >
> >
> > >
> > >
> > > Full output at: http://paste.debian.net/100103/
> > > expires:
> > >
> > > 2010-11-21 06:07:30
>=20
> Thanks
>=20
> -M
>  		 	   		 =20
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
