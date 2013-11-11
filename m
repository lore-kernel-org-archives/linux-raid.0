From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Running check and e2fsck simultaneously
Date: Sun, 10 Nov 2013 21:43:13 -0600
Message-ID: <52805251.2010102@hardwarefreak.com>
References: <B385A1A4-3EB2-48CA-8EA5-FE8A0F5C2BA0@gmail.com> <527FCBAF.4070208@hardwarefreak.com> <58CD4AD8-0A1E-42E8-984D-F4727EE2B8F0@gmail.com> <527FDBC1.4000009@hardwarefreak.com> <D691C632-1025-4D32-9138-55BF9DE47300@gmail.com> <527FE89A.4010608@hardwarefreak.com> <89667845-9A4C-4402-91BE-0817BCB02C6F@gmail.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <89667845-9A4C-4402-91BE-0817BCB02C6F@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ivan Lezhnjov IV <ivan.lezhnjov.iv@gmail.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 11/10/2013 5:08 PM, Ivan Lezhnjov IV wrote:
>=20
> On Nov 10, 2013, at 10:12 PM, Stan Hoeppner <stan@hardwarefreak.com> =
wrote:
>=20
>> USB is not a storage protocol.  USB devices often disconnect/reconne=
ct
>> for no apparent reason.  We see this frequently with the little vend=
or
>> USB disk drives (Seagate/WD) and also generic disk enclosures.  USB =
is
>> not a proper protocol for md/RAID storage.  You may have continual
>> problems with this setup.
>>
>> If the laptop has an eSATA port use eSATA.  If not, drop in an eSATA
>> PCMCIA card.  This should be much more reliable than USB for this
>> application.
>=20
> Actually, it's a good piece of advice. Now all I need is to figure ou=
t if I I can do this with the hardware I've got.
>=20
> However, I feel compelled to say that my USB drives (I have had sever=
al=85 4 to be precise, now 5) have been incredibly reliable throughout =
all these years. No connection problems whatsoever, no flakiness/flappi=
ng of any kind. Very solid and reliable as for a home, midrange 7 years=
 old laptop and three 7 years old drives. I've been using them for all =
sorts of things, from backups to torrents and storing virtual machine d=
isk images, etc. Very reliable. The only concern I have is that perform=
ance sometimes may not be enough, but by and large it is not a problem =
for me and so I get by just fine.
>=20
> Installing an eSATA PCMCIA card is actually a great idea, and I almos=
t falmpaced when I realized I could've probably resolved performance is=
sues long time ago and the solution was in front of me all this time, b=
ut then again the problem was from a pressing character and so I have b=
een really content most of the time with what I have.
>=20
>>
>>>> Also, I see little/no value in running a scheduled mdadm check on =
a
>>>> RAID1 array.  Any problems with RAID1 will be due to one of the di=
sks
>>>> beginning to fail in some mode, usually requiring sector relocatio=
n.
>>>> Most drives do this automatically until they run out of spare sect=
ors,
>>>> at which point md will throw write errors.  Monitoring SMART data =
and/or
>>>> running SMART self analysis on a schedule is much more effective h=
ere,
>>>> as you will become aware of a problem sooner, and have the opportu=
nity
>>>> to correct it before it shows up in md.
>>>
>>> Bare with me, I know very little about how RAID works so I can some=
times make totally absurd statements. That being said, I intend to moni=
tor SMART values and I'm wondering now why does it make sense to run ch=
eck on other types of RAID? I assume 5/6/10 mostly?
>>>
>>> I'm also wondering if it is advised to run check with filesystem mo=
unted and in use, or unmounted?
>>
>> Instead of using a connection method known to cause problems with
>> storage, and then attempting to mitigate such damage with array/fs
>> checks after the fact, why not simply avoid the problem in the first
>> place?  Use eSATA, or build/buy a little NFS/Samba NAS filer.
>>
>=20
> As I said in my particular configuration it is a pretty solid connect=
ion.=20

You've been lucky so far.  I hope your luck holds.

> No experience with NAS filers here, but I'm definitely looking this
option up as well (already googled it up and reading a description).

Network Attached Storage, A.K.A a dedicated file server "appliance".
"NAS" is a catch-all term these days for a dedicated file serving
device, whether NFS, Samba, Windows CIFS, etc.

I mentioned this option because it gives you a dedicated storage server=
,
and decouples the sleep mode of your laptop from your bulk storage.
There are DIY kits and full retail NAS boxen on the market that use ver=
y
little power.  Here you would configure the drives to spin down, but no=
t
put the system into sleep, as the mainboard uses less than 10W anyway.

> What about filesystem state? Does it matter if a filesystem is mounte=
d when check is run?

I'm not an EXT user.  See "man e2fsck".

With XFS you can check while mounted using "xfs_repair -n [device]", bu=
t
no repairs will be performed, you simply get a report.  To repair a
damaged XFS filesystem use the same command sans "-n" on the unmounted
filesystem.  xfs_repair will abort if the filesystem is mounted, and
"-n" is not specified.  xfs_repair is not to be automated via
script/cron.  It is only to be run if/when errors are encountered,
usually after a crash, power loss, controller failure, etc.

--=20
Stan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
