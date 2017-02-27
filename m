From: Les Stroud <les@lesstroud.com>
Subject: Re: Process stuck in md_flush_request (state: D)
Date: Mon, 27 Feb 2017 13:48:00 -0500
Message-ID: <ED1913CC-96EF-4A25-A1F3-E664396A2710@lesstroud.com>
References: <36A8825E-F387-4ED8-8672-976094B3BEBB@lesstroud.com>
 <99A92F4D-338D-4486-BB1C-C114A8524403@lesstroud.com>
 <20170217200644.amaxgira4nqlbchh@kernel.org>
 <9589FA71-C458-4B44-B2F3-3D42E8B0885D@lesstroud.com>
 <829563C6-A2AF-4E5F-B5AF-D33D2E5A734E@lesstroud.com>
 <20170227182806.jntxzhyw3nkohl5r@kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 10.2 \(3259\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170227182806.jntxzhyw3nkohl5r@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids





> On Feb 27, 2017, at 1:28 PM, Shaohua Li <shli@kernel.org> wrote:
>=20
> On Mon, Feb 27, 2017 at 09:49:59AM -0500, Les Stroud wrote:
>> After a period of a couple of weeks with one of our test instances =
having this problem every other day, they were all nice enough to =
operate without an issue for 9 days.  It finally reoccurred last night =
on one of the machines. =20
>>=20
>> It exhibits the same symptoms and the call traces look as they did =
previously.  This particular instance is configured with a deadline =
scheduler.  I was able to capture the inflight you requested:
>>=20
>> $ cat /sys/block/xvd[abcde]/inflight
>> =E2=80=82=E2=80=82=E2=80=82=E2=80=82=E2=80=82=E2=80=82 =
0=E2=80=82=E2=80=82=E2=80=82=E2=80=82=E2=80=82=E2=80=82=E2=80=82=E2=80=820=

>> =E2=80=82=E2=80=82=E2=80=82=E2=80=82=E2=80=82=E2=80=82 =
0=E2=80=82=E2=80=82=E2=80=82=E2=80=82=E2=80=82=E2=80=82=E2=80=82=E2=80=820=

>> =E2=80=82=E2=80=82=E2=80=82=E2=80=82=E2=80=82=E2=80=82 =
0=E2=80=82=E2=80=82=E2=80=82=E2=80=82=E2=80=82=E2=80=82=E2=80=82=E2=80=820=

>> =E2=80=82=E2=80=82=E2=80=82=E2=80=82=E2=80=82=E2=80=82 =
0=E2=80=82=E2=80=82=E2=80=82=E2=80=82=E2=80=82=E2=80=82=E2=80=82=E2=80=820=

>> =E2=80=82=E2=80=82=E2=80=82=E2=80=82=E2=80=82=E2=80=82 =
0=E2=80=82=E2=80=82=E2=80=82=E2=80=82=E2=80=82=E2=80=82=E2=80=82=E2=80=820=

>>=20
>> I=E2=80=99ve had this happen on instances with the deadline scheduler =
and the noop scheduler.  At this point, I have not had this happen on an =
instance that is noop and the raid filesystem (ext4) is mounted with =
nobarrier.  The instances with noop/nobarrier have not been running long =
enough for me to make any sort of conclusion that it works around the =
problem. Frankly, I=E2=80=99m not sure I understand the interaction =
between ext4 barriers and raid0 block flushes well enough to theorize =
whether it should or shouldn=E2=80=99t make a difference.
>=20
> If nobarrier, ext4 doesn't send flush request.

So, could ext4=E2=80=99s flush request deadlock with an =
md_flush_request?  Do they share a mutex of some sort? Could one of them =
be failing to acquire a mutex and not handling it?

>=20
>> Does any of this help with identifying the bug?  Is there anymore =
information I can get that would be useful? =20
>=20
>=20
> Unfortunately I can't find anything fishing. Does the xcdx disk =
correctly
> handle flush request? For example, you can do the same test with a =
single such
> disk and check if anything wrong.

Until recently, we had a number of these systems setup without raid0.  =
This issue never occurred on those systems.  Unfortunately, I can=E2=80=99=
t find a way to make it happen other than stand a server up and let it =
run.

I suppose I could try a different filesystem and see if that makes a =
difference (maybe ext3, xfs, etc).


>=20
> Thanks,
> Shaohua

