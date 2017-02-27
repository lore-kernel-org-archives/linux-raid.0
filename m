From: Les Stroud <les@lesstroud.com>
Subject: Re: Process stuck in md_flush_request (state: D)
Date: Mon, 27 Feb 2017 09:49:59 -0500
Message-ID: <829563C6-A2AF-4E5F-B5AF-D33D2E5A734E@lesstroud.com>
References: <36A8825E-F387-4ED8-8672-976094B3BEBB@lesstroud.com>
 <99A92F4D-338D-4486-BB1C-C114A8524403@lesstroud.com>
 <20170217200644.amaxgira4nqlbchh@kernel.org>
 <9589FA71-C458-4B44-B2F3-3D42E8B0885D@lesstroud.com>
Mime-Version: 1.0 (Mac OS X Mail 10.2 \(3259\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <9589FA71-C458-4B44-B2F3-3D42E8B0885D@lesstroud.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

After a period of a couple of weeks with one of our test instances =
having this problem every other day, they were all nice enough to =
operate without an issue for 9 days.  It finally reoccurred last night =
on one of the machines. =20

It exhibits the same symptoms and the call traces look as they did =
previously.  This particular instance is configured with a deadline =
scheduler.  I was able to capture the inflight you requested:

$ cat /sys/block/xvd[abcde]/inflight
=E2=80=82=E2=80=82=E2=80=82=E2=80=82=E2=80=82=E2=80=82 =
0=E2=80=82=E2=80=82=E2=80=82=E2=80=82=E2=80=82=E2=80=82=E2=80=82=E2=80=820=

=E2=80=82=E2=80=82=E2=80=82=E2=80=82=E2=80=82=E2=80=82 =
0=E2=80=82=E2=80=82=E2=80=82=E2=80=82=E2=80=82=E2=80=82=E2=80=82=E2=80=820=

=E2=80=82=E2=80=82=E2=80=82=E2=80=82=E2=80=82=E2=80=82 =
0=E2=80=82=E2=80=82=E2=80=82=E2=80=82=E2=80=82=E2=80=82=E2=80=82=E2=80=820=

=E2=80=82=E2=80=82=E2=80=82=E2=80=82=E2=80=82=E2=80=82 =
0=E2=80=82=E2=80=82=E2=80=82=E2=80=82=E2=80=82=E2=80=82=E2=80=82=E2=80=820=

=E2=80=82=E2=80=82=E2=80=82=E2=80=82=E2=80=82=E2=80=82 =
0=E2=80=82=E2=80=82=E2=80=82=E2=80=82=E2=80=82=E2=80=82=E2=80=82=E2=80=820=


I=E2=80=99ve had this happen on instances with the deadline scheduler =
and the noop scheduler.  At this point, I have not had this happen on an =
instance that is noop and the raid filesystem (ext4) is mounted with =
nobarrier.  The instances with noop/nobarrier have not been running long =
enough for me to make any sort of conclusion that it works around the =
problem.  Frankly, I=E2=80=99m not sure I understand the interaction =
between ext4 barriers and raid0 block flushes well enough to theorize =
whether it should or shouldn=E2=80=99t make a difference.

Does any of this help with identifying the bug?  Is there anymore =
information I can get that would be useful? =20

I have some systems that need to be moved into production in the next =
couple of weeks that are having this problem.  Do you have any ideas how =
I might be able to work around the problem?



Thanx for the time,
LES



> On Feb 17, 2017, at 3:40 PM, Les Stroud <les@lesstroud.com> wrote:
>=20
> It=E2=80=99ll take a day or two for it to happen again.  When it does, =
I=E2=80=99ll pull the inflight stats.  Anything else I should grab while =
I=E2=80=99m at it?
>=20
> Thanx,
> LES
>=20
>=20
>> On Feb 17, 2017, at 3:06 PM, Shaohua Li <shli@kernel.org> wrote:
>>=20
>> On Fri, Feb 17, 2017 at 02:05:49PM -0500, Les Stroud wrote:
>>>=20
>>> I have a problem with processes entering an uninterruptible sleep =
state in md_flush_request and never returning. I having trouble =
identifying the underlying issue. I=E2=80=99m hoping someone on here may =
be able to help.
>>>=20
>>> The servers in question are running in aws (xen hvm) with kernel =
3.8.13-118.16.2.el6uek.x86_64.  The server has two mounts.  The first is =
vanilla ext4.  The second is a software RAID0 array, striped with 256k =
chunks, buiIt with md.  It=E2=80=99s file system is ext4.=20
>>>=20
>>> The most immediately and obvious symptom of the issue are kernel =
errors =E2=80=9Ckernel: INFO task [some process]: blocked for more than =
120 seconds.=E2=80=9D.  Shortly there after, other processes start =
entering the same uninterruptible wait state (D). This almost always =
impacts ssh logins.
>>>=20
>>> The problem does not occur when the system is under load, or was =
recently under load.  It happens when the system is quiet (no cpu, very =
little io).
>>=20
>> This seems suggesting we have a missed blk-plug flush in light =
workload. Can
>> you check the output of /sys/block/disk-bame/inflight for both md and =
the
>> underlayer disks? This will let us know if there is IO pending.
>> Also it would be great if you can test a upstream kernel.
>>=20
>> Thanks,
>> Shaohua
>=20

