From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH] md: don't use flush_signals in userspace processes
Date: Fri, 09 Jun 2017 07:24:29 +1000
Message-ID: <877f0mb2b6.fsf@notabene.neil.brown.name>
References: <alpine.LRH.2.02.1706071834250.22850@file01.intranet.prod.int.rdu2.redhat.com> <87h8zrart4.fsf@notabene.neil.brown.name> <20170608171551.ytxk3yz6xxsfbqma@kernel.org> <alpine.LRH.2.02.1706081641160.12323@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.02.1706081641160.12323@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>, Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 08 2017, Mikulas Patocka wrote:

> On Thu, 8 Jun 2017, Shaohua Li wrote:
>
>> On Thu, Jun 08, 2017 at 04:59:03PM +1000, Neil Brown wrote:
>> > On Wed, Jun 07 2017, Mikulas Patocka wrote:
>> >=20
>> > > The function flush_signals clears all pending signals for the proces=
s. It
>> > > may be used by kernel threads when we need to prepare a kernel threa=
d for
>> > > responding to signals. However using this function for an userspaces
>> > > processes is incorrect - clearing signals without the program expect=
ing it
>> > > can cause misbehavior.
>> > >
>> > > The raid1 and raid5 code uses flush_signals in its request routine b=
ecause
>> > > it wants to prepare for an interruptible wait. This patch drops
>> > > flush_signals and uses sigprocmask instead to block all signals (inc=
luding
>> > > SIGKILL) around the schedule() call. The signals are not lost, but t=
he
>> > > schedule() call won't respond to them.
>> > >
>> > > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
>> > > Cc: stable@vger.kernel.org
>> >=20
>> > Thanks for catching that!
>> >=20
>> > Acked-by: NeilBrown <neilb@suse.com>
>>=20
>> Applied, thanks!
>>=20
>> Neil,
>> Not about the patch itself. I had question about that part of code. Drop=
ped
>> others since this is raid related. I didn't get the point why it's a
>> TASK_INTERRUPTIBLE sleep. It seems suggesting the thread will bail out i=
f a
>> signal is sent. But I didn't see we check the signal and exit the loop. =
What's
>> the correct behavior here? Since the suspend range is controlled by user=
space,
>
> As I understand the code - the purpose is to have an UNINTERRUPTIBLE slee=
p=20
> that isn't accounted in load average and that doesn't trigger the hung=20
> task warning.

Exactly my reason - yes.

>
> There should really be something like TASK_UNINTERRUPTIBLE_LONG for this=
=20
> purpose.

That would be nice.

>
>> I think the correct behavior is if user kills the thread, we exit the lo=
op. So
>> it seems like to be we check if there is fatal signal pending, exit the =
loop,
>> and return IO error. Not sure if we should return IO error though.
>
> No, this is not correct - if we report an I/O error for the affected bio,=
=20
> it could corrupt filesystem or confuse other device mapper targets that=20
> could be on the top of MD. It is not right to corrupt filesystem if the=20
> user kills a process.

Yes, we are too deep to even return something like ERESTARTSYS.
Blocking is the only option.

Thanks,
NeilBrown


>
>> Thanks,
>> Shaohua
>
> Mikulas

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlk5wI4ACgkQOeye3VZi
gbmuWg/+IOfFSzGt/RjWgl0CabhVlC6KXudGQJy/jjGe0GXYrVaAsg8m8c7GqCia
rYBwVjdT+HFNCBjDfUpCX27Mw51L1+N/VOG/q8mqGx/Cgc7vVM5PrDcWszMwSWMM
ejdZzr6ksN3rkmFtSU2Z6T4/JIvsu+lz6M8Z6tzbLXMr4QWdpEPaKXHSjul1lpTs
nChXZQrRFF67BGRn4us7CB/Z32cHJAJnFQ11GbmJ4tL6bQA2KG5x6UX5s1YT7Ymo
YG8xE79YWQ5CpyOUMtWnckL5+5o2keS2Oyusu3xT7ALyxLJ6FwMr1S/xehoYj86D
aLmaklP0IFrSJGo/7A2jcPiUPbcQ2b4tgz2PRCGm5YbursRiPBiCtg/4ux/kPIQz
DRA/TPzKHeSQCR/I/uri25vbO5+JchD/wnTFXFz/7k8pTr05vZZJ3u/7Nzgt67OO
EomoEYBhZspVgapVy4SwoCDDzHXprFV4hfAdOVmwvemq+iOEdoJTzDOp9rjMGUA/
8J6Xe79K5vkoIXP2OFodb658O8lSCZMdmLnvbxqYygfDDBS0kDPAcO92CXx3PBX8
TPtW2WizQVsG4fjieHE7Kv99J2DnPgJ6wi7x/WcFLfFDsXdKdQMU1FRgSxVStgE7
0QtioC+E/v6BzvBY9P6aIrK6vRLeq/apKc4cXMmLBAPX58E+sH4=
=BySJ
-----END PGP SIGNATURE-----
--=-=-=--
