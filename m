From: Phil Turmel <philip@turmel.org>
Subject: Re: recovering RAID5 from multiple disk failures
Date: Sat, 02 Feb 2013 19:23:32 -0500
Message-ID: <510DAE04.5070709@turmel.org>
References: <kegcd6$6dl$1@ger.gmane.org> <510BC173.7070002@turmel.org> <kej2t8$vk8$1@ger.gmane.org> <510D184E.4070106@turmel.org> <B7E27E99-9C89-4FC5-A12D-EFFAB5EDE5EB@colorremedies.com> <kek222$1tf$1@ger.gmane.org> <D0556FFA-7710-47DC-873C-38820439F054@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <D0556FFA-7710-47DC-873C-38820439F054@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: Michael Ritzert <ksciplot@gmx.net>, "linux-raid@vger.kernel.org list" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 02/02/2013 06:08 PM, Chris Murphy wrote:
>=20
> On Feb 2, 2013, at 2:56 PM, Michael Ritzert <ksciplot@gmx.net>=20
> wrote:
>>=20
>> Chris Murphy <lists@colorremedies.com> wrote:
>>>=20
>>> Nevertheless, over an hour and a half is a long time if the file=20
>>> system were being updated at all. There'd definitely be=20
>>> data/parity mismatches for disk1.
>>=20
>> After disk1 failed, the only write access should have been
>> metadata update when the filesystem was mounted.

This is significant.

> Was it mounted ro?
>=20
>> I only read data from the filesystem thereafter. So only atime=20
>> changes are to be expected, there, and only for a small number of=20
>> files that I could capture before disk3 failed. I know which files=20
>> are affected, and could leave them alone.
>=20
> Even for a small number of files there could be dozens or hundreds
> of chunks altered. I think conservatively you have to consider disk
> 1 out and mount in degraded mode.
>=20
>>=20
>>> If disk 1 is assumed to be useless, meaning force assemble the=20
>>> array in degraded mode; a URE or linux SCSI layer time out is to=20
>>> be avoided or the array as a whole fails. Every sector is
>>> needed. So what do you think about raising the linux scsi layer
>>> time out to maybe 2 minutes, and leaving the remaining drive's
>>> SCT ERC alone so that they don't time out sooner, but rather go
>>> into whatever deep recovery they have to in the hopes those bad=20
>>> sectors can be read?
>>>=20
>>> echo 120 >/sys/block/sdX/device/timeout
>>=20
>> I just tried that, but I couldn't see any effect. The error rate=20
>> coming in is much higher than 1 every two minutes.
>=20
> This timeout is not about error rate. And what the value should be=20
> depends on context. Normal operation you want the disk error
> recovery to be short, so that the disk produces a bonafide URE, not a
> SCSI layer timeout error. That way md will correct the bad sector.
> That's what probably wasn't happening in your case, which allowed
> bad sectors to accumulate until it was a real problem.

If you try to recover from the degraded array, this is the correct appr=
oach.

> But now, for the cloning process, you want the disk error timeout to=20
> be long (or disabled) so that the disk has as long as possible to do=20
> ECC to recover each of these problematic sectors. But this also
> means getting the SCSI layer timeout set to at least 1 second longer
> than the longest recovery time for the drives, so that the SCSI layer
> time out doesn't stop sector recovery during cloning. Now maybe the
> disk still won't be able to recover all data from these bad sectors,
> but it's your best shot IMO.

=46or the array assembled degraded (disk1 left out).

>> When I assemble the array, I will have all new disks (with good=20
>> smart selftests...), so I wouldn't expect timeouts. Instead, junk=20
>> data will be returned from the sectors in question=C2=B9. How will m=
d=20
>> react to that?
>=20
> Well yeah, with the new drives, they won't report UREs. So there's
> an ambiguity with any mismatch between data and parity chunks as to=20
> which is correct. Without a URE, md doesn't know that the data chunk=20
> is right or wrong with RAID 5.

Bingo.  Working from the copies guarantees you won't have correct data
where the UREs are.  (The copies are very good to have, of course.)

> Phil may disagree, and I have to defer to his experience in this,
> but I think the most conservative and best shot you have at getting
> the 20GB you want off the array is this:

I do disagree.

The above, combined with:

> I do know where the bad sectors are from the ddrescue report. We are
> talking about less that 50kB bad data on disk1. Unfortunately, disk3
> is worse, but there is no sector that is bad on both disks.

Leads me to recommend "mdadm --create --assume-clean" using the origina=
l
drives, taking care to specify the devices in the proper order (per
their "Raid Device" number in the --examine reports).  I still haven't
seen any data that definitively links specific serial numbers to
specific raid device numbers.  Please do that.

After re-creating the array, and setting all the drive timeouts to 7.0
seconds, issue a "check" scrub:

echo "check" >/sys/block/md0/md/sync_action

This should clean up the few pending sectors on disk #1 by
reconstruction from the others, and may very well do the same for disk =
#3.

If disk #3 gets kicked out at this point, assemble in degraded mode wit=
h
disk #2, #4, and a fresh copy of disk #1 (picking up the new superblock
and any fixes during the partial scrub).  Then "--add" a spare (wiped)
disk and let the array rebuild.

And grab your data.

Phil.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
