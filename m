From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH] md: don't use flush_signals in userspace processes
Date: Fri, 09 Jun 2017 11:55:03 +1000
Message-ID: <87shja9b7s.fsf@notabene.neil.brown.name>
References: <alpine.LRH.2.02.1706071834250.22850@file01.intranet.prod.int.rdu2.redhat.com> <87h8zrart4.fsf@notabene.neil.brown.name> <alpine.LRH.2.02.1706081847150.3603@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.02.1706081847150.3603@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 08 2017, Mikulas Patocka wrote:

> On Thu, 8 Jun 2017, NeilBrown wrote:
>
>> On Wed, Jun 07 2017, Mikulas Patocka wrote:
>>=20
>> > The function flush_signals clears all pending signals for the process.=
 It
>> > may be used by kernel threads when we need to prepare a kernel thread =
for
>> > responding to signals. However using this function for an userspaces
>> > processes is incorrect - clearing signals without the program expectin=
g it
>> > can cause misbehavior.
>> >
>> > The raid1 and raid5 code uses flush_signals in its request routine bec=
ause
>> > it wants to prepare for an interruptible wait. This patch drops
>> > flush_signals and uses sigprocmask instead to block all signals (inclu=
ding
>> > SIGKILL) around the schedule() call. The signals are not lost, but the
>> > schedule() call won't respond to them.
>> >
>> > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
>> > Cc: stable@vger.kernel.org
>>=20
>> Thanks for catching that!
>>=20
>> Acked-by: NeilBrown <neilb@suse.com>
>>=20
>> NeilBrown
>
> BTW. why does md_thread do "allow_signal(SIGKILL)" and then
> "if (signal_pending(current)) flush_signals(current)"?
>
> Does userspace really send SIGKILL to MD kernel threads? The SIGKILL will=
=20
> be lost when flush_signals is called, so it looks quite dubious.
>

This is for md_check_recovery() which does do something on a signal.
Chances are good that it will get to handle the signal before
md_thread() flushed them, but not guaranteed.  I could be improved I
guess.

Or maybe it could be discarded - the md_check_recovery() thing.
The idea was that if you alt-sysrq-K to kill all processes, md arrays
would go into immediate-safe-mode where the metadata is marked clean
immediately after writes finish, rather than waiting a few seconds.  The
chance of having a clean array after shutdown is hopefully improved.

I've never actually used this though, and I doubt many people know about
it.  And bitmaps make it fairly pointless.
So I wouldn't object much if
	allow_signal(SIGKILL);
and
	if (signal_pending(current)) {
		if (mddev->pers->sync_request && !mddev->external) {
			pr_debug("md: %s in immediate safe mode\n",
				 mdname(mddev));
			mddev->safemode =3D 2;
		}
		flush_signals(current);
	}

were removed.

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlk5//gACgkQOeye3VZi
gbmkahAAr3YFlj+w7hBMrt1tuvpapPdkJtrKgAKCPtta/5jFBOT8xwSLGqnpaEs/
LXyUPa1vJXYm4ZxSJcV/qPYO4VZ7paFc2ALqTJ2Fli7eoqV6NLJNi/YVfK6/KAJ8
J4XvTxbMqpEn86RhSIijYPTYgtTEU3yUSkKtHS/PSg5xgYU+iwW0SM+42zOGoZhm
pb/G51nMPsjHa/gZIFdiGxhpJpXXErG3yEEByYzWOBeoGd3QNgZlBhr1Tu9tJx2h
hfptWvmZlD5AxGCAPijgO2JhWSyC7zslOaHoYXSSMpUdBwsrX1sCG8Z5Gvef72yS
ddpM5iokGRsouAah0yTEaFRjS6Tw8dBnqdRQY5J8CXfEdnxIK9eT/yIEa27vxW5o
h6zi+7mNaHmfpd9hZmobAMiF7X7LLLVHcdG/EHMC7yJyB6oe94S01sQFoeeWEXB/
XVWnYRdg5tOGPk3Q34S/Uaug4CgNm5IDBVj8x67VsOc5U/lrMcH/djK0O+JPgnDp
EngeDeax5RJWaB9V8UyAlTIf9nuRE2m2I2tBbdyQ15JI5BBPV1fWJwPswna2syoA
27IaYk6p6ifA+EkAM9DhLqNN5oST5SAOaEcgnGZ3TVXBHez7KGgqCoHPy6R0ZIOb
HF2hLcEO9U2oMycd700mid19Uzujju029HlTBu5rgQWGinuKym0=
=64cH
-----END PGP SIGNATURE-----
--=-=-=--
