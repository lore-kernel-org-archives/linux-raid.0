From: Chris Murphy <lists@colorremedies.com>
Subject: Re: recovering RAID5 from multiple disk failures
Date: Sat, 2 Feb 2013 16:08:03 -0700
Message-ID: <D0556FFA-7710-47DC-873C-38820439F054@colorremedies.com>
References: <kegcd6$6dl$1@ger.gmane.org> <510BC173.7070002@turmel.org> <kej2t8$vk8$1@ger.gmane.org> <510D184E.4070106@turmel.org> <B7E27E99-9C89-4FC5-A12D-EFFAB5EDE5EB@colorremedies.com> <kek222$1tf$1@ger.gmane.org>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <kek222$1tf$1@ger.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Ritzert <ksciplot@gmx.net>
Cc: Phil Turmel <philip@turmel.org>, "linux-raid@vger.kernel.org list" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Feb 2, 2013, at 2:56 PM, Michael Ritzert <ksciplot@gmx.net> wrote:
>=20
> Chris Murphy <lists@colorremedies.com> wrote:
>>=20
>> Nevertheless, over an hour and a half is a long time if the file sys=
tem were being updated at all. There'd definitely be data/parity mismat=
ches for disk1.
>=20
> After disk1 failed, the only write access should have been metadata u=
pdate
> when the filesystem was mounted.

Was it mounted ro?

> I only read data from the filesystem
> thereafter. So only atime changes are to be expected, there, and only
> for a small number of files that I could capture before disk3 failed.=
 I
> know which files are affected, and could leave them alone.

Even for a small number of files there could be dozens or hundreds of c=
hunks altered. I think conservatively you have to consider disk 1 out a=
nd mount in degraded mode.=20

>=20
>> If disk 1 is assumed to be useless, meaning force assemble the array=
 in degraded mode; a URE or linux SCSI layer time out is to be avoided =
or the array as a whole fails. Every sector is needed. So what do you t=
hink about raising the linux scsi layer time out to maybe 2 minutes, an=
d leaving the remaining drive's SCT ERC alone so that they don't time o=
ut sooner, but rather go into whatever deep recovery they have to in th=
e hopes those bad sectors can be read?
>>=20
>> echo 120 >/sys/block/sdX/device/timeout
>=20
> I just tried that, but I couldn't see any effect. The error rate comi=
ng
> in is much higher than 1 every two minutes.

This timeout is not about error rate. And what the value should be depe=
nds on context. Normal operation you want the disk error recovery to be=
 short, so that the disk produces a bonafide URE, not a SCSI layer time=
out error. That way md will correct the bad sector. That's what probabl=
y wasn't happening in your case, which allowed bad sectors to accumulat=
e until it was a real problem.

But now, for the cloning process, you want the disk error timeout to be=
 long (or disabled) so that the disk has as long as possible to do ECC =
to recover each of these problematic sectors. But this also means getti=
ng the SCSI layer timeout set to at least 1 second longer than the long=
est recovery time for the drives, so that the SCSI layer time out doesn=
't stop sector recovery during cloning. Now maybe the disk still won't =
be able to recover all data from these bad sectors, but it's your best =
shot IMO.




> When I assemble the array, I will have all new disks (with good smart
> selftests...), so I wouldn't expect timeouts. Instead, junk data will=
 be
> returned from the sectors in question=B9. How will md react to that?

Well yeah, with the new drives, they won't report UREs. So there's an a=
mbiguity with any mismatch between data and parity chunks as to which i=
s correct. Without a URE, md doesn't know that the data chunk is right =
or wrong with RAID 5.

Phil may disagree, and I have to defer to his experience in this, but I=
 think the most conservative and best shot you have at getting the 20GB=
 you want off the array is this:

a.) Make sure the SCT ERC for all drives is disabled. That means it wil=
l take the longest time to recover from bad sectors, and thus has as mu=
ch of a chance as there can be for the disk firmware to do ECC recovery=
 on them.

b.) Make sure the linux SCSI layer has a timeout set that's at least 1 =
second longer than the disk error time out. I think that no vendor user=
s a time longer than 2 minutes.

c.) Base your disk 2, 3, 4 clones on the above settings. If you cloned =
the data from old to new disk using default /sys/block/sdX/device/timeo=
ut of 30 seconds, then the source disks did not have every chance to re=
cover their sectors and you almost certainly have more holes in the clo=
nes than you want. If you are still getting errors in dmesg during the =
clone, they should only be bonafide read errors from the disk, not time=
outs. Report the errors if you're not clear on this point.

d.) Try to assemble force the clones of disks 2, 3, 4, which means it's=
 brought up degraded. Disk 1, conservatively probably can't be trusted.=
 Open question on whether you do or do not want to assume clean in this=
 case, maybe it doesn't matter because it's degraded anyway.

But now you try to extract those 20GB you really need.

Chris Murphy--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
