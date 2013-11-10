From: Ivan Lezhnjov IV <ivan.lezhnjov.iv@gmail.com>
Subject: Re: Running check and e2fsck simultaneously
Date: Mon, 11 Nov 2013 01:08:02 +0200
Message-ID: <89667845-9A4C-4402-91BE-0817BCB02C6F@gmail.com>
References: <B385A1A4-3EB2-48CA-8EA5-FE8A0F5C2BA0@gmail.com> <527FCBAF.4070208@hardwarefreak.com> <58CD4AD8-0A1E-42E8-984D-F4727EE2B8F0@gmail.com> <527FDBC1.4000009@hardwarefreak.com> <D691C632-1025-4D32-9138-55BF9DE47300@gmail.com> <527FE89A.4010608@hardwarefreak.com>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <527FE89A.4010608@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Nov 10, 2013, at 10:12 PM, Stan Hoeppner <stan@hardwarefreak.com> wr=
ote:

> USB is not a storage protocol.  USB devices often disconnect/reconnec=
t
> for no apparent reason.  We see this frequently with the little vendo=
r
> USB disk drives (Seagate/WD) and also generic disk enclosures.  USB i=
s
> not a proper protocol for md/RAID storage.  You may have continual
> problems with this setup.
>=20
> If the laptop has an eSATA port use eSATA.  If not, drop in an eSATA
> PCMCIA card.  This should be much more reliable than USB for this
> application.

Actually, it's a good piece of advice. Now all I need is to figure out =
if I I can do this with the hardware I've got.

However, I feel compelled to say that my USB drives (I have had several=
=85 4 to be precise, now 5) have been incredibly reliable throughout al=
l these years. No connection problems whatsoever, no flakiness/flapping=
 of any kind. Very solid and reliable as for a home, midrange 7 years o=
ld laptop and three 7 years old drives. I've been using them for all so=
rts of things, from backups to torrents and storing virtual machine dis=
k images, etc. Very reliable. The only concern I have is that performan=
ce sometimes may not be enough, but by and large it is not a problem fo=
r me and so I get by just fine.

Installing an eSATA PCMCIA card is actually a great idea, and I almost =
falmpaced when I realized I could've probably resolved performance issu=
es long time ago and the solution was in front of me all this time, but=
 then again the problem was from a pressing character and so I have bee=
n really content most of the time with what I have.

>=20
>>> Also, I see little/no value in running a scheduled mdadm check on a
>>> RAID1 array.  Any problems with RAID1 will be due to one of the dis=
ks
>>> beginning to fail in some mode, usually requiring sector relocation=
=2E
>>> Most drives do this automatically until they run out of spare secto=
rs,
>>> at which point md will throw write errors.  Monitoring SMART data a=
nd/or
>>> running SMART self analysis on a schedule is much more effective he=
re,
>>> as you will become aware of a problem sooner, and have the opportun=
ity
>>> to correct it before it shows up in md.
>>=20
>> Bare with me, I know very little about how RAID works so I can somet=
imes make totally absurd statements. That being said, I intend to monit=
or SMART values and I'm wondering now why does it make sense to run che=
ck on other types of RAID? I assume 5/6/10 mostly?
>>=20
>> I'm also wondering if it is advised to run check with filesystem mou=
nted and in use, or unmounted?
>=20
> Instead of using a connection method known to cause problems with
> storage, and then attempting to mitigate such damage with array/fs
> checks after the fact, why not simply avoid the problem in the first
> place?  Use eSATA, or build/buy a little NFS/Samba NAS filer.
>=20

As I said in my particular configuration it is a pretty solid connectio=
n. No experience with NAS filers here, but I'm definitely looking this =
option up as well (already googled it up and reading a description).

What about filesystem state? Does it matter if a filesystem is mounted =
when check is run?

Ivan

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
