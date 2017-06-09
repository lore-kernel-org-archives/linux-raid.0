From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH] md: don't use flush_signals in userspace processes
Date: Fri, 09 Jun 2017 11:49:45 +1000
Message-ID: <87vao69bgm.fsf@notabene.neil.brown.name>
References: <alpine.LRH.2.02.1706071834250.22850@file01.intranet.prod.int.rdu2.redhat.com> <87h8zrart4.fsf@notabene.neil.brown.name> <20170608171551.ytxk3yz6xxsfbqma@kernel.org> <alpine.LRH.2.02.1706081641160.12323@file01.intranet.prod.int.rdu2.redhat.com> <877f0mb2b6.fsf@notabene.neil.brown.name> <20170608225858.z23vabbkzsf3lgl5@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170608225858.z23vabbkzsf3lgl5@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 08 2017, Shaohua Li wrote:

> On Fri, Jun 09, 2017 at 07:24:29AM +1000, Neil Brown wrote:
>> On Thu, Jun 08 2017, Mikulas Patocka wrote:
>>=20
>> > On Thu, 8 Jun 2017, Shaohua Li wrote:
>> >
>> >> On Thu, Jun 08, 2017 at 04:59:03PM +1000, Neil Brown wrote:
>> >> > On Wed, Jun 07 2017, Mikulas Patocka wrote:
>> >> >=20
>> >> > > The function flush_signals clears all pending signals for the pro=
cess. It
>> >> > > may be used by kernel threads when we need to prepare a kernel th=
read for
>> >> > > responding to signals. However using this function for an userspa=
ces
>> >> > > processes is incorrect - clearing signals without the program exp=
ecting it
>> >> > > can cause misbehavior.
>> >> > >
>> >> > > The raid1 and raid5 code uses flush_signals in its request routin=
e because
>> >> > > it wants to prepare for an interruptible wait. This patch drops
>> >> > > flush_signals and uses sigprocmask instead to block all signals (=
including
>> >> > > SIGKILL) around the schedule() call. The signals are not lost, bu=
t the
>> >> > > schedule() call won't respond to them.
>> >> > >
>> >> > > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
>> >> > > Cc: stable@vger.kernel.org
>> >> >=20
>> >> > Thanks for catching that!
>> >> >=20
>> >> > Acked-by: NeilBrown <neilb@suse.com>
>> >>=20
>> >> Applied, thanks!
>> >>=20
>> >> Neil,
>> >> Not about the patch itself. I had question about that part of code. D=
ropped
>> >> others since this is raid related. I didn't get the point why it's a
>> >> TASK_INTERRUPTIBLE sleep. It seems suggesting the thread will bail ou=
t if a
>> >> signal is sent. But I didn't see we check the signal and exit the loo=
p. What's
>> >> the correct behavior here? Since the suspend range is controlled by u=
serspace,
>> >
>> > As I understand the code - the purpose is to have an UNINTERRUPTIBLE s=
leep=20
>> > that isn't accounted in load average and that doesn't trigger the hung=
=20
>> > task warning.
>>=20
>> Exactly my reason - yes.
>>=20
>> >
>> > There should really be something like TASK_UNINTERRUPTIBLE_LONG for th=
is=20
>> > purpose.
>>=20
>> That would be nice.
>>=20
>> >
>> >> I think the correct behavior is if user kills the thread, we exit the=
 loop. So
>> >> it seems like to be we check if there is fatal signal pending, exit t=
he loop,
>> >> and return IO error. Not sure if we should return IO error though.
>> >
>> > No, this is not correct - if we report an I/O error for the affected b=
io,=20
>> > it could corrupt filesystem or confuse other device mapper targets tha=
t=20
>> > could be on the top of MD. It is not right to corrupt filesystem if th=
e=20
>> > user kills a process.
>>=20
>> Yes, we are too deep to even return something like ERESTARTSYS.
>> Blocking is the only option.
>
> My concern is if the app controlling the suspend range dies, other threads
> will block in the kernel side forever. We can't even force kill them.  Th=
is
> is an unfortunate behavior. Would adding a timeout here make sense? The a=
pp
> controlling the suspend range looks part of the disk firmware now. If the
> firmware doesn't respond, returning IO timeout is normal.

Yes, this happens.
You can write to /sys/block/mdXX/md/suspend_lo to unblock it, but most
people don't know this.

A timeout might be appropriate, but I would want it to be quite a long
one.  Several minutes at least...
Though if I found I wanted to do some careful raid6repair surgery on an
array, and so suspending the problematic region and started work, I
might get annoyed if I/O started getting errors, instead of just waiting
like I asked.... but maybe that is a rather far-fetched scenario.

Thanks,
NeilBrown


>
> Thanks,
> Shaohua

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlk5/rsACgkQOeye3VZi
gblw/A//T7kXcmEGKU73SKTjyyyW9ZT9XIu7UBQr11icR/nrhsdshqcaXkzCtKzA
sqid2+l9g8c7ZqtExUsW6lheFreZsYXD9oF4NS5MWhKoDC7x0+ocbl07v6rXV9rC
3Khpkbd4h69OCBTTb6+M7RVnUIJzQyKNroV50A88bdSLq+2Lg4cOU5mPpnTMevhx
y1QkH6XKJEmBJvSPU+SZyalAJBNCUEkeUuzD/h4sRBZhFbjXAwidPB9iANY8F2aZ
ttlcINw0tOxZjgREyV6ImO47Dz8pXfb7mLc/KT9yqVTewoYhhDEjcvKOgcrqkjTb
6rPjCpZWOeFNkckahYcspkJ0HjpeBUcVOFQ5BjulbLuBje4lvUXM+xMiSEzn9GD0
5yfOsL7q9LKzF19zjSPbnHakKzr6M4rmK+Qk5izsfuCYIHf0jKFYc6Z9O7BMprf5
mdo5YK2QMSC0aO0JAtjn5SupIQrQREFNTwIQUg8/rPiSA/nvLkg/elNXSqbAGt2x
z/F8YauHtDhWqbX942UHsIFUslj211LPV8kmJ4BkNPkHuTSPLlA3tfMAqlpld7C9
dCiydn4BvEa30XP5EfzCmPdHQ60/fWOnGSBkDk2rWr1ysJrbaUwpDS/tXlPNsmhc
f/p29W9V3qK5xN0oSnakDavJl8nNDk0L990E4y8Th+KeV4mRg9M=
=rOXt
-----END PGP SIGNATURE-----
--=-=-=--
