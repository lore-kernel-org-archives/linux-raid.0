From: "crowston.name" <kevin@crowston.name>
Subject: Re: Requesting assistance recovering RAID-5 array
Date: Mon, 30 Mar 2020 21:27:29 -0400
Message-ID: <etPan.5e829cbd.69391496.da7e@crowston.name>
References: <CAB00BMjPSg2wdq7pjt=AwmcDmr0ep2+Xr0EAy6CNnVhOsWk8pg@mail.gmail.com>
 <058b3f48-e69d-2783-8e08-693ad27693f6@youngman.org.uk>
 <CAB00BMgYmi+4XvdmJDWjQ8qGWa9m0mqj7yvrK3QSNH9SzYjypw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAB00BMgYmi+4XvdmJDWjQ8qGWa9m0mqj7yvrK3QSNH9SzYjypw@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Daniel Jones <dj@iowni.com>, antlists <antlists@youngman.org.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I got the following error trying to run lsdrv:=C2=A0

./lsdrv=C2=A0
Traceback (most recent call last):
=C2=A0 =46ile =22./lsdrv=22, line 423, in <module>
=C2=A0 =C2=A0 probe=5Fblock('/sys/block/'+x)
=C2=A0 =46ile =22./lsdrv=22, line 340, in probe=5Fblock
=C2=A0 =C2=A0 blk.=5F=5Fdict=5F=5F.update(extractvars(runx(=5B'vol=5Fid',=
 '--export', '/dev/block/'+blk.dev=5D)))
=C2=A0 =46ile =22./lsdrv=22, line 125, in runx
=C2=A0 =C2=A0 out, err =3D sub.communicate()
=C2=A0 =46ile =22/usr/lib/python2.5/subprocess.py=22, line 667, in commun=
icate
=C2=A0 =C2=A0 return self.=5Fcommunicate(input)
=C2=A0 =46ile =22/usr/lib/python2.5/subprocess.py=22, line 1138, in =5Fco=
mmunicate
=C2=A0 =C2=A0 rlist, wlist, xlist =3D select.select(read=5Fset, write=5Fs=
et, =5B=5D)
select.error: (4, 'Interrupted system call')




Kevin Crowston
206 Meadowbrook Dr.
Syracuse, NY 13210 USA
Phone: +1 (315) 464-0272
=46ax: +1 (815) 550-2155

-----Original Message-----
=46rom:=C2=A0Daniel Jones <dj=40iowni.com>
Reply:=C2=A0Daniel Jones <dj=40iowni.com>
Date:=C2=A0March 30, 2020 at 8:52:18 PM
To:=C2=A0antlists <antlists=40youngman.org.uk>
Cc:=C2=A0linux-raid=40vger.kernel.org <linux-raid=40vger.kernel.org>
Subject:=C2=A0 Re: Requesting assistance recovering RAID-5 array

> Greetings Wol,
> =20
> > Don't even THINK of --create until the experts have chimed in =21=21=21=

> =20
> Yes, I have had impure thoughts, but fortunately (=3F) I've done nothin=
g
> yet to intentionally write to the drives.
> =20
> > If your drives are 1TB, I would *seriously* consider getting hold of =
a 4TB drive - they're =20
> not expensive - to make a backup. And read up on overlays.
> =20
> The array drives are 10TB each. Understand the concept of overlays in
> general (have used them in a container context) and have skimmed the
> wiki, but not yet acted.
> =20
> > The lsdrv information is crucial - that recovers pretty much all the =
config information =20
> that is available
> =20
> Attached.
> =20
> =24 ./lsdrv
> PCI =5Bpata=5Fmarvell=5D 02:00.0 IDE interface: Marvell Technology Grou=
p
> Ltd. 88SE6101/6102 single-port PATA133 interface (rev b2)
> =E2=94=94scsi 0:x:x:x =5BEmpty=5D
> PCI =5Bahci=5D 00:1f.2 SATA controller: Intel Corporation 82801JI (ICH1=
0
> =46amily) SATA AHCI Controller
> =E2=94=9Cscsi 2:0:0:0 ATA M4-CT256M4SSD2 =7B0000000012050904283E=7D
> =E2=94=82=E2=94=94sda 238.47g =5B8:0=5D Partitioned (dos)
> =E2=94=82 =E2=94=9Csda1 500.00m =5B8:1=5D xfs =7B8ed274ce-4cf6-4804-88f=
8-0213c002a716=7D
> =E2=94=82 =E2=94=82=E2=94=94Mounted as /dev/sda1 =40 /boot
> =E2=94=82 =E2=94=94sda2 237.99g =5B8:2=5D PV LVM2=5Fmember 237.92g used=
, 64.00m free
> =7Bkn8lMS-0Cy8-xpsR-QRTk-CTRG-Eh1J-lmtfws=7D
> =E2=94=82 =E2=94=94VG centos=5Fhulk 237.98g 64.00m free =7BP5MVrD-UMGG-=
0IO9-z=46Nq-8zd2-lycX-oYqe5L=7D =20
> =E2=94=82 =E2=94=9Cdm-2 185.92g =5B253:2=5D LV home xfs =7B39075ece-de0=
a-4ace-b291-cc22aff5a4b2=7D
> =E2=94=82 =E2=94=82=E2=94=94Mounted as /dev/mapper/centos=5Fhulk-home =40=
 /home
> =E2=94=82 =E2=94=9Cdm-0 50.00g =5B253:0=5D LV root xfs =7B68ffae87-7b51=
-4392-b3b8-59a7aa13ea68=7D
> =E2=94=82 =E2=94=82=E2=94=94Mounted as /dev/mapper/centos=5Fhulk-root =40=
 /
> =E2=94=82 =E2=94=94dm-1 2.00g =5B253:1=5D LV swap swap =7Bf2da9893-93f0=
-42a1-ba86-5f3b3a72cc9b=7D
> =E2=94=9Cscsi 3:0:0:0 ATA WDC WD100EMAZ-00 =7B1DGVH01Z=7D
> =E2=94=82=E2=94=94sdb 9.10t =5B8:16=5D Partitioned (gpt)
> =E2=94=9Cscsi 4:0:0:0 ATA WDC WD100EMAZ-00 =7B2YJ2XMPD=7D
> =E2=94=82=E2=94=94sdc 9.10t =5B8:32=5D MD raid5 (4) inactive 'hulk:0'
> =7B423d9a8e-636a-5f08-56ec-bd90282e478b=7D
> =E2=94=9Cscsi 5:0:0:0 ATA WDC WD100EMAZ-00 =7B2YJDR8LD=7D
> =E2=94=82=E2=94=94sdd 9.10t =5B8:48=5D Partitioned (gpt)
> =E2=94=94scsi 6:0:0:0 ATA WDC WD100EMAZ-00 =7BJEHRKH2Z=7D
> =E2=94=94sde 9.10t =5B8:64=5D Partitioned (gpt)
> =20
> Cheers,
> DJ
> =20
> On Mon, Mar 30, 2020 at 6:24 PM antlists wrote:
> >
> > On 31/03/2020 01:04, Daniel Jones wrote:
> > > I am genuinely over my head at this point and unsure how to proceed=
.
> > > My logic tells me the best choice is to attempt a --create to try t=
o
> > > rebuild the missing superblocks, but I'm not clear if I should try
> > > devices=3D4 (the true size of the array) or devices=3D3 (the size i=
t was
> > > last operating in). I'm also not sure of what device order to use
> > > since I have likely scrambled /dev/sd=5Bbcde=5D and am concerned ab=
out
> > > what happens when I bring the previously disable drive back into th=
e
> > > array.
> >
> > Don't even THINK of --create until the experts have chimed in =21=21=21=

> >
> > https://raid.wiki.kernel.org/index.php/Linux=5FRaid=23When=5FThings=5F=
Go=5FWrogn =20
> >
> > The lsdrv information is crucial - that recovers pretty much all the
> > config information that is available, and massively increases the
> > chances of a successful --create, if you do have to go down that rout=
e...
> >
> > If your drives are 1TB, I would *seriously* consider getting hold of =
a
> > 4TB drive - they're not expensive - to make a backup. And read up on
> > overlays.
> >
> > Hopefully we can recover your data without too much grief, but this w=
ill
> > all help.
> >
> > Cheers,
> > Wol
> =20
