From: Michael Ritzert <ksciplot@gmx.net>
Subject: Re: recovering RAID5 from multiple disk failures
Date: Sat, 2 Feb 2013 21:56:18 +0000 (UTC)
Message-ID: <kek222$1tf$1@ger.gmane.org>
References: <kegcd6$6dl$1@ger.gmane.org> <510BC173.7070002@turmel.org> <kej2t8$vk8$1@ger.gmane.org> <510D184E.4070106@turmel.org> <B7E27E99-9C89-4FC5-A12D-EFFAB5EDE5EB@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Phil, Chris,

Chris Murphy <lists@colorremedies.com> wrote:
> On Feb 2, 2013, at 6:44 AM, Phil Turmel <philip@turmel.org> wrote:
>>=20
>> All of your drives are in perfect condition (no relocations at all).
>=20
> One disk has Current_Pending_Sector raw value 30, and read error rate=
 of 1121.
> Another disk has  Current_Pending_Sector raw value 2350, and read err=
or rate of 29439.
>=20
> I think for new drives that's unreasonable.=20
>=20
> It's probably also unreasonable to trust a new drive without testing =
it. But some of the drives were tested by someone or something, and the=
 test itself was aborted due to read failures, even though the disk was=
 not flagged by SMART as "failed" or failure in progress. Example:
>=20
> # 1  Short offline       Completed: read failure       40%       766 =
        329136144
> # 2  Short offline       Completed: read failure       10%       745 =
        717909280
> # 3  Short offline       Completed: read failure       70%       714 =
        327191864
> # 4  Extended offline    Completed: read failure       90%       695 =
        329136144
> # 5  Short offline       Completed: read failure       80%       695 =
        724561192

That was probably me manually starting tests.

When I first noticed signs of trouble, i.e. slow access, I immediately
checked the disk status, and the status page said "OK". I couldn't beli=
eve
that, so I started unscheduled and extended tests.

Would you consider running a full smart selftest on a new disk sufficie=
nt?
Or do you propose even stricter tests?

> Almost 100 hours ago, at least, problems with this disk were identifi=
ed. Maybe this is a NAS feature limitation problem, but if the NAS is g=
oing to purport to do SMART testing and then fail to inform the user th=
at the tests themselves are failing due to bad sectors, that's negligen=
ce in my opinion. Sadly it's common.

When judging the 100 hours, you have to keep in mind that these disk ha=
ve
been running since the failure. Taking the copy took a few hours (times
two by now), and few more hours have been added since it finished at
nighttime and the disk stayed on until I got up. Still, that shouldn't =
add
up to 100 hours.

>> Based on the event counts in your superblocks, I'd say disk1 was kic=
ked out long ago due to a normal URE (hundreds of hours ago) and the ar=
ray has been degraded ever since.
>=20
> I'm confused because the OP reports disk 1 and disk 4 as sdc3, disk 2=
 and disk 3 as sdb3; yet the superblock info has different checksums fo=
r each. So based on Update Time field, I'm curious what other informati=
on leads you to believe disk1 was kicked hundreds of hours ago:

The disks are running on a desktop PC at the moment. I can plug in two
disks at any time, as I have set things up at the moment. So I had to
connect two times two disk to get all four reports. That's why the
devices are identical.

> disk 1:
> Fri Jan  4 15:11:07 2013
> disk 2:
> Fri Jan  4 16:33:36 2013
> disk 3:
> Fri Jan  4 16:32:27 2013
> disk 4:
> Fri Jan  4 16:33:36 2013
>=20
> Nevertheless, over an hour and a half is a long time if the file syst=
em were being updated at all. There'd definitely be data/parity mismatc=
hes for disk1.

After disk1 failed, the only write access should have been metadata upd=
ate
when the filesystem was mounted. I only read data from the filesystem
thereafter. So only atime changes are to be expected, there, and only
for a small number of files that I could capture before disk3 failed. I
know which files are affected, and could leave them alone.

> If disk 1 is assumed to be useless, meaning force assemble the array =
in degraded mode; a URE or linux SCSI layer time out is to be avoided o=
r the array as a whole fails. Every sector is needed. So what do you th=
ink about raising the linux scsi layer time out to maybe 2 minutes, and=
 leaving the remaining drive's SCT ERC alone so that they don't time ou=
t sooner, but rather go into whatever deep recovery they have to in the=
 hopes those bad sectors can be read?
>=20
> echo 120 >/sys/block/sdX/device/timeout

I just tried that, but I couldn't see any effect. The error rate coming
in is much higher than 1 every two minutes.

When I assemble the array, I will have all new disks (with good smart
selftests...), so I wouldn't expect timeouts. Instead, junk data will b=
e
returned from the sectors in question=C2=B9. How will md react to that?

Regards,
Michael

=C2=B9 One could think about filling these gaps with data from the thre=
e
remaining disks. Disk1 is still uptodate in 99%+ of all chunks. So
data from 3 disks is available. I could implement the RAID5 algorithm
in userspace to compute what should be in the bad sector. I do know
where the bad sectors are from the ddrescue report. We are talking
about less that 50kB bad data on disk1. Unfortunately, disk3 is
worse, but there is no sector that is bad on both disks.


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
