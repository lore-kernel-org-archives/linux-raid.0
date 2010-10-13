From: Simon =?iso-8859-1?Q?S=C9HIER?= <simon@sehier.fr>
Subject: Re: reboot before reshape from raid 5 to raid 6 (was in state
	resync=DELAYED). Doesn't assemble anymore.
Date: Wed, 13 Oct 2010 19:32:12 +0200
Message-ID: <20101013173212.GB25675@leontine.pompomgali.com>
References: <20101012142752.GA16007@leontine.pompomgali.com> <20101013074612.6abbb698@notabene> <201010130059.52624.simon@sehier.fr> <20101013110823.54d41db2@notabene> <20101013081833.GA25675@leontine.pompomgali.com> <20101013193759.4678186e@notabene>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20101013193759.4678186e@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Oct 13, 2010 at 07:37:59PM +1100, Neil Brown wrote:
> On Wed, 13 Oct 2010 10:18:33 +0200
> Simon S=C9HIER <simon@sehier.fr> wrote:
>=20
> > On Wed, Oct 13, 2010 at 11:08:23AM +1100, Neil Brown wrote:
> > > On Wed, 13 Oct 2010 00:59:52 +0200
> > > Simon S=C9HIER <simon@sehier.fr> wrote:
> > >=20
> > > > On 12 oct. 2010 22:46:12, Neil Brown wrote :
> > > > > On Tue, 12 Oct 2010 16:27:53 +0200
> > > > >=20
> > > > > Simon S <simon@sehier.fr> wrote:
> > > > > > Hi all,
> > > > > >=20
> > > > > > I had a config with 5 disks and 3 raid 5 arrays:
> > > > > >=20
> > > > > > md2 : system root
> > > > > > md3 : swap
> > > > > > md4 : data
> > > > > >=20
> > > > > > I added a 6th disk with the intention of growing my raid5 i=
nto raid6.
> > > > > >=20
> > > > > > The step I used were :
> > > > > >=20
> > > > > > # mdadm /dev/mdX -a  /dev/newdiskX
> > > > > > # mdadm -G --level 6 -n 6 /dev/mdX --backup-file /mdXbackup
> > > > > >=20
> > > > > >  (yes, with backup file on root partition md2...)
> > > > >=20
> > > > > Bad idea..  Very bad idea.
> > > > >=20
> > > > > > The md3 array reshaped without any problem.
> > > > > > md2 seemed to reshape well until it reaches 50.4%, then the=
 rebuild speed
> > > > > > stalled at 14Kb/s.
> > > > >=20
> > > > > This is the expected consequence of that bad idea.  Unfortuna=
tely it would
> > > > > be hard to reliably get mdadm to complain about that, though =
I guess the
> > > > > common cases are easy to protect against ... added to 'todo' =
list
> > > > >=20
> > > > > > md4 was still in the state "resync=3DDELAYED" then.
> > > > > >=20
> > > > > > As the rebuild process seemed hung, I restart the machine .=
=2E. bad idea.
> > > > >=20
> > > > > Not really, nothing else would have worked.
> > > > >=20
> > > > > > Now mdadm refuses to assemble md2 and md4, and displays thi=
s message :
> > > > > >   mdadm: Failed to restore critical section for reshape, so=
rry.
> > > > > >  =20
> > > > > >     Possibly you needed to specify the --backup-file
> > > > > >=20
> > > > > > md2 is my linux installation, not very bad if I lose this o=
ne.
> > > > > >=20
> > > > > > md4 however contains valuable data.
> > > > > >=20
> > > > > > While md4 was still in the state resync=3DDELAYED before th=
e shutdown, I
> > > > > > expect it should not has been (to much) modified and can be=
 recovered.
> > > > >=20
> > > > > Very true.
> > > > >=20
> > > > > > Any idea on how I could safely do it ?
> > > > > >=20
> > > > > > Should I give a try to the hack "Get 'Grow_restart' to alwa=
ys return 0."
> > > > > > mentionned by Neil Brown on 22 april 2010 in this mailing l=
ist ?
> > > > >=20
> > > > > That is your best bet.  I plan to make that easier to do in m=
dadm-3.2 (no
> > > > > recompile necessary).
> > > > >=20
> > > > > Before you do, check "mdadm -E /dev/newdiskX" and make sure t=
he "Reshape
> > > > > position" is 0.  If it is you should be fine.  I
> > > > >=20
> > > > > It won't be for md2 of course.  So md will quite possible hav=
e some
> > > > > corruption.  Run fsck on it an it will probably be mostly OK,=
 but there is
> > > > > a reasonable chance that some files will be corrupted.  Wheth=
er and when
> > > > > you will notice is impossible to guess.
> > > >=20
> > > > Thanks for your answer Neil,=20
> > > >=20
> > > > I recompiled mdadm 3.1.4 with return 0 in the beginning of the =
function=20
> > > > Grow_restart (mistake was made with 3.1.2). I have one more que=
stion :
> > > >=20
> > > > I first tried assembling the least valued array, md2. It starts=
 reshaping from=20
> > > > where it stops, in the first seconds around 1300 K/s, and rapid=
ly above 10K/s.
> > > >=20
> > > > While my backup file for md4 (the array I care about) was also =
on md2. Do I=20
> > > > have to expect a problem assembling md4 with the modified versi=
on of mdadm, or=20
> > > > can I go without worying md2 (rootfs)  isn't assembled ?
> > >=20
> > > The backup file for md4 would have been essentially empty.  It ca=
n be created
> > > anew elsewhere.  I probably wouldn't rick using the original back=
up file
> > > even if you can access it, as it could be corrupted.
> > > So when you assemble md4, give it a fresh backup file in some sta=
ble location,
> > > and use the hacked mdadm.
> > >=20
> > > NeilBrown
> > >=20
> >=20
> > I tried=20
> >=20
> >  # mdadm -A --backup-file=3D/new-empty-md4backup-file /dev/md4
> >=20
> > but the array is now in "inactive" state with 6 spares :
> >=20
> > md4 : inactive sdc4[0](S) sdh4[6](S) sdg4[5](S) sdf4[3](S) sde4[2](=
S) sdd4[1](S)  =20
> >       1411288041 blocks super 1.2
> >=20
> > I'm a bit confuse on what I could do now.
>=20
> That surprises me a little.
> Try:
>   mdadm -S /dev/md4
>   mdadm -Avv --backup-file=3D/new-empty-md4backup-file /dev/md4
>   dmesg | tail -100
>   mdadm -E /dev/sd[cd]4
>=20
> and send all of the output.
>=20
> NeilBrown
>=20

# mdadm -S /dev/md4

mdadm: stopped /dev/md4


# mdadm -Avv --backup-file=3D/new-empty-md4backup-file /dev/md4

mdadm: looking for devices for /dev/md4
mdadm: no RAID superblock on /dev/md/3
mdadm: /dev/md/3 has wrong uuid.
mdadm: no RAID superblock on /dev/md1
mdadm: /dev/md1 has wrong uuid.
mdadm: cannot open device /dev/sdg3: Device or resource busy
mdadm: /dev/sdg3 has wrong uuid.
mdadm: /dev/sdg2 has wrong uuid.
mdadm: no RAID superblock on /dev/sdg1
mdadm: /dev/sdg1 has wrong uuid.
mdadm: cannot open device /dev/sdg: Device or resource busy
mdadm: /dev/sdg has wrong uuid.
mdadm: cannot open device /dev/sdf3: Device or resource busy
mdadm: /dev/sdf3 has wrong uuid.
mdadm: /dev/sdf2 has wrong uuid.
mdadm: no RAID superblock on /dev/sdf1
mdadm: /dev/sdf1 has wrong uuid.
mdadm: cannot open device /dev/sdf: Device or resource busy
mdadm: /dev/sdf has wrong uuid.
mdadm: cannot open device /dev/sde3: Device or resource busy
mdadm: /dev/sde3 has wrong uuid.
mdadm: /dev/sde2 has wrong uuid.
mdadm: cannot open device /dev/sde1: Device or resource busy
mdadm: /dev/sde1 has wrong uuid.
mdadm: cannot open device /dev/sde: Device or resource busy
mdadm: /dev/sde has wrong uuid.
mdadm: cannot open device /dev/sdd3: Device or resource busy
mdadm: /dev/sdd3 has wrong uuid.
mdadm: /dev/sdd2 has wrong uuid.
mdadm: cannot open device /dev/sdd1: Device or resource busy
mdadm: /dev/sdd1 has wrong uuid.
mdadm: cannot open device /dev/sdd: Device or resource busy
mdadm: /dev/sdd has wrong uuid.
mdadm: cannot open device /dev/sdc3: Device or resource busy
mdadm: /dev/sdc3 has wrong uuid.
mdadm: /dev/sdc2 has wrong uuid.
mdadm: cannot open device /dev/sdc1: Device or resource busy
mdadm: /dev/sdc1 has wrong uuid.
mdadm: cannot open device /dev/sdc: Device or resource busy
mdadm: /dev/sdc has wrong uuid.
mdadm: cannot open device /dev/sdb3: Device or resource busy
mdadm: /dev/sdb3 has wrong uuid.
mdadm: /dev/sdb2 has wrong uuid.
mdadm: cannot open device /dev/sdb1: Device or resource busy
mdadm: /dev/sdb1 has wrong uuid.
mdadm: cannot open device /dev/sdb: Device or resource busy
mdadm: /dev/sdb has wrong uuid.
mdadm: cannot open device /dev/sda5: Device or resource busy
mdadm: /dev/sda5 has wrong uuid.
mdadm: no RAID superblock on /dev/sda2
mdadm: /dev/sda2 has wrong uuid.
mdadm: cannot open device /dev/sda1: Device or resource busy
mdadm: /dev/sda1 has wrong uuid.
mdadm: cannot open device /dev/sda: Device or resource busy
mdadm: /dev/sda has wrong uuid.
mdadm: /dev/sdg4 is identified as a member of /dev/md4, slot 4.
mdadm: /dev/sdf4 is identified as a member of /dev/md4, slot 3.
mdadm: /dev/sde4 is identified as a member of /dev/md4, slot 2.
mdadm: /dev/sdd4 is identified as a member of /dev/md4, slot 1.
mdadm: /dev/sdc4 is identified as a member of /dev/md4, slot 0.
mdadm: /dev/sdb4 is identified as a member of /dev/md4, slot -1.
mdadm:/dev/md4 has an active reshape - checking if critical section nee=
ds to be restored
mdadm: added /dev/sdd4 to /dev/md4 as 1
mdadm: added /dev/sde4 to /dev/md4 as 2
mdadm: added /dev/sdf4 to /dev/md4 as 3
mdadm: added /dev/sdg4 to /dev/md4 as 4
mdadm: no uptodate device for slot 5 of /dev/md4
mdadm: added /dev/sdb4 to /dev/md4 as -1
mdadm: added /dev/sdc4 to /dev/md4 as 0
mdadm: /dev/md4 assembled from 5 drives and 1 spare - not enough to sta=
rt the array while not clean - consider --force.


# dmesg | tail -n100

[   11.127010] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 21 (level, low)=
 -> IRQ 21
[   11.127038] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   11.196601]   alloc irq_desc for 16 on node -1
[   11.196603]   alloc kstat_irqs on node -1
[   11.196611] pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IR=
Q 16
[   11.196614] pci 0000:00:02.0: setting latency timer to 64
[   11.203560]   alloc irq_desc for 32 on node -1
[   11.203563]   alloc kstat_irqs on node -1
[   11.203573] pci 0000:00:02.0: irq 32 for MSI/MSI-X
[   11.203602] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 o=
n minor 0
[   11.230846] Error: Driver 'pcspkr' is already registered, aborting..=
=2E
[   11.251260] hda_codec: ALC662 rev1: BIOS auto-probing.
[   11.252651] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00=
:1b.0/input/input5
[   11.848246] md: md2 stopped.
[   11.852104] md: bind<sdd2>
[   11.852253] md: bind<sde2>
[   11.852386] md: bind<sdf2>
[   11.852636] md: bind<sdg2>
[   11.852845] md: bind<sdb2>
[   11.852932] md: bind<sdc2>
[   11.882369] raid5: reshape will continue
[   11.882378] raid5: device sdc2 operational as raid disk 0
[   11.882380] raid5: device sdg2 operational as raid disk 4
[   11.882382] raid5: device sdf2 operational as raid disk 3
[   11.882383] raid5: device sde2 operational as raid disk 2
[   11.882385] raid5: device sdd2 operational as raid disk 1
[   11.882767] raid5: allocated 6386kB for md2
[   11.882797] 0: w=3D1 pa=3D18 pr=3D6 m=3D2 a=3D2 r=3D6 op1=3D0 op2=3D=
0
[   11.882799] 5: w=3D1 pa=3D18 pr=3D6 m=3D2 a=3D2 r=3D6 op1=3D1 op2=3D=
0
[   11.882801] 4: w=3D2 pa=3D18 pr=3D6 m=3D2 a=3D2 r=3D6 op1=3D0 op2=3D=
0
[   11.882803] 3: w=3D3 pa=3D18 pr=3D6 m=3D2 a=3D2 r=3D6 op1=3D0 op2=3D=
0
[   11.882805] 2: w=3D4 pa=3D18 pr=3D6 m=3D2 a=3D2 r=3D6 op1=3D0 op2=3D=
0
[   11.882807] 1: w=3D5 pa=3D18 pr=3D6 m=3D2 a=3D2 r=3D6 op1=3D0 op2=3D=
0
[   11.882809] raid5: raid level 6 set md2 active with 5 out of 6 devic=
es, algorithm 2
[   11.882849] RAID5 conf printout:
[   11.882851]  --- rd:6 wd:5
[   11.882852]  disk 0, o:1, dev:sdc2
[   11.882854]  disk 1, o:1, dev:sdd2
[   11.882855]  disk 2, o:1, dev:sde2
[   11.882856]  disk 3, o:1, dev:sdf2
[   11.882858]  disk 4, o:1, dev:sdg2
[   11.882859]  disk 5, o:1, dev:sdb2
[   11.882860] ...ok start reshape thread
[   11.882905] md2: detected capacity change from 0 to 34376515584
[   11.882970] md: md2 switched to read-write mode.
[   11.883452] md: reshape of RAID array md2
[   11.883453] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[   11.883455] md: using maximum available idle IO bandwidth (but not m=
ore than 200000 KB/sec) for reshape.
[   11.883459] md: using 128k window, over a total of 8392704 blocks.
[   11.954838]  md2: unknown partition table
[   12.939843] Adding 1648632k swap on /dev/sda5.  Priority:-1 extents:=
1 across:1648632k
[   13.142646] EXT3 FS on sda1, internal journal
[   13.255820] loop: module loaded
[  100.224309] e1000e 0000:00:19.0: irq 30 for MSI/MSI-X
[  100.280126] e1000e 0000:00:19.0: irq 30 for MSI/MSI-X
[  100.280456] ADDRCONF(NETDEV_UP): eth2: link is not ready
[  104.940830] e1000e: eth2 NIC Link is Up 1000 Mbps Full Duplex, Flow =
Control: RX/TX
[  104.941081] ADDRCONF(NETDEV_CHANGE): eth2: link becomes ready
[  143.313242] md: md_do_sync() got signal ... exiting
[  143.373125] md: md2 stopped.
[  143.373138] md: unbind<sdc2>
[  143.384082] md: export_rdev(sdc2)
[  143.384113] md: unbind<sdb2>
[  143.400081] md: export_rdev(sdb2)
[  143.400107] md: unbind<sdg2>
[  143.416081] md: export_rdev(sdg2)
[  143.416108] md: unbind<sdf2>
[  143.432080] md: export_rdev(sdf2)
[  143.432105] md: unbind<sde2>
[  143.448080] md: export_rdev(sde2)
[  143.448104] md: unbind<sdd2>
[  143.464081] md: export_rdev(sdd2)
[  143.464405] md2: detected capacity change from 34376515584 to 0
[  252.687538] md: md4 stopped.
[  252.690104] md: bind<sdd4>
[  252.690266] md: bind<sde4>
[  252.690415] md: bind<sdf4>
[  252.696210] md: bind<sdg4>
[  252.718353] md: bind<sdb4>
[  252.723594] md: bind<sdc4>
[  332.729180] md: md4 stopped.
[  332.729190] md: unbind<sdc4>
[  332.740090] md: export_rdev(sdc4)
[  332.740165] md: unbind<sdb4>
[  332.752030] md: export_rdev(sdb4)
[  332.752092] md: unbind<sdg4>
[  332.768081] md: export_rdev(sdg4)
[  332.768140] md: unbind<sdf4>
[  332.784081] md: export_rdev(sdf4)
[  332.784139] md: unbind<sde4>
[  332.800081] md: export_rdev(sde4)
[  332.800141] md: unbind<sdd4>
[  332.816089] md: export_rdev(sdd4)
[  556.983627] md: md4 stopped.
[  556.988921] md: bind<sdd4>
[  556.989094] md: bind<sde4>
[  556.989239] md: bind<sdf4>
[  556.989391] md: bind<sdg4>
[  556.989642] md: bind<sdb4>
[  556.989787] md: bind<sdc4>


# mdadm -E /dev/sd[cd]4

/dev/sdc4:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x4
     Array UUID : ec600d5d:00cc3fc7:862a4878:9d191184
           Name : citrouille:4
  Creation Time : Wed Sep 15 17:28:55 2010
     Raid Level : raid6
   Raid Devices : 6

 Avail Dev Size : 470429347 (224.32 GiB 240.86 GB)
     Array Size : 1881714688 (897.27 GiB 963.44 GB)
  Used Dev Size : 470428672 (224.32 GiB 240.86 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : e8ef9525:cfb44c96:b5e209ea:b307c619

  Reshape pos'n : 0
     New Layout : left-symmetric

    Update Time : Tue Oct 12 00:01:03 2010
       Checksum : 6dfe6f7b - correct
         Events : 97

         Layout : left-symmetric-6
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : AAAAA. ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sdd4:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x4
     Array UUID : ec600d5d:00cc3fc7:862a4878:9d191184
           Name : citrouille:4
  Creation Time : Wed Sep 15 17:28:55 2010
     Raid Level : raid6
   Raid Devices : 6

 Avail Dev Size : 470429347 (224.32 GiB 240.86 GB)
     Array Size : 1881714688 (897.27 GiB 963.44 GB)
  Used Dev Size : 470428672 (224.32 GiB 240.86 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : 08a661f3:eace7b1f:26fd20a8:ac0ae049

  Reshape pos'n : 0
     New Layout : left-symmetric

    Update Time : Tue Oct 12 00:01:03 2010
       Checksum : b32a5d21 - correct
         Events : 97

         Layout : left-symmetric-6
     Chunk Size : 512K

   Device Role : Active device 1
   Array State : AAAAA. ('A' =3D=3D active, '.' =3D=3D missing)



# mdadm -V
mdadm - v3.1.4 - 31st August 2010 - with Grow_restart always 0
(hacked mdadm)

# uname -a
Linux citrouillerescue 2.6.32-5-amd64 #1 SMP Fri Sep 17 21:50:19 UTC 20=
10 x86_64 GNU/Linux

# cat /etc/issue.net=20
Debian GNU/Linux squeeze/sid

Just in case, I posted the full output of mdadm -E /dev/sd?4 here : htt=
p://pastebin.com/zV6s2Npi

Hope it helps.

--=20
Simon
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
