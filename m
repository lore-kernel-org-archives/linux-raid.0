From: NeilBrown <neilb@suse.de>
Subject: Re: [RFC PATCH V1] raid1: rewrite the iobarrier
Date: Wed, 6 Feb 2013 13:16:53 +1100
Message-ID: <20130206131653.27d025a6@notabene.brown>
References: <2013012414023278904611@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/nI+1eFQpU2enEKtekO3UQ0M"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2013012414023278904611@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/nI+1eFQpU2enEKtekO3UQ0M
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 24 Jan 2013 14:02:52 +0800 majianpeng <majianpeng@gmail.com> wrote:

> There is iobarrier in raid1 because two reason resync/recovery  or reconf=
igure the array.
> At present,it suspend all nornal IO when reysync/recovey.
> But if nornal IO is outrange the resync/recovery windwos,it  don't need t=
o iobarrier.
> So I rewrite the iobarrier.
> Because the reasons of barrier are two,so i use two different methods.
> First for resync/recovery, there is a reysnc window.The end position is '=
next_resync'.Because the resync depth is  RESYNC_DEPTH(32),
> so the start is 'next_resync - RESYNC_SECTOR * RESYNC_DEPTH'
> The nornal IO Will be divided into three categories by the location.
> a: before the start of resync window
> b: between the resync window
> c: after the end of resync window
> For a, it don't barrier.
> For b, it need barrier and used the original method
> For c, it don't barrier but it need record the minimum position.If next r=
esync is larger this, resync action will suspend.Otherwise versa.
> I used rbtree to order those io.
>=20
> For the reason of reconfigure of the arrary,I proposed a concept "force_b=
arrier".When there is force_barrier, all Nornam IO must be suspended.
>=20
> NOTE:
> Because this problem is also for raid10, but i only do it for raid1. It i=
s post out mainly to make sure it is=20
> going in the correct direction and hope to get some helpful comments from=
 other guys.
> If the methods is accepted,i will send the patch for raid10.
>=20
> Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>

Hi,
 thanks for this and sorry for the delay in replying.

The patch is reasonably good, but there is room for improvement.
I would break it up into several patches which are easier to review.

- Firstly, don't worry about the barrier for 'read' requests - it really
  isn't relevant for them (your patch didn't do this).

- Secondly, find those places where raise_barrier() is used to reconfigure
  the array and replace those with "freeze_array()".  I think that is safe,
  and it means that we don't need to pass a 'force' argument to
  'raise_barrier()' and 'lower_barrier()'.

- The rest might have to be all one patch, though if it could be done in a
  couple of distinct stages that would be good.
  For the different positions (before, during, after), which you currently
  call 0, 1, and 2 you should use an enum so they all have names.
=20
  I don't really like the rbtree.  It adds an extra place where you take the
  spinlock and causes more work to be done inside a spinlock.  And it isn't
  really needed.  Instead, you can have two R1BIO flags for "AFTER_RESYNC".
  One for requests that are more than 2 windows after, one for request that
  are less then 2 windows after (or maybe 3 windows or maybe 8..).  Each of
  these has a corresponding count (as you already have: nr_after).
  Then when resync gets to the end of a window you wait until the count of=
=20
  "less than 2 windows after" reaches zero, then atomically swap the meaning
  of the two bits (toggle a bit somewhere).
  This should give you nearly the same effect with constant (not log-n)
  effort.

Finally, have you done any testing, either to ensure there is no slow-down,
or to demonstrate some improvement?

Thanks,
NeilBrown



--Sig_/nI+1eFQpU2enEKtekO3UQ0M
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBURG9FTnsnt1WYoG5AQKsahAAn6O3j62FK45jmhjRL8wMSYfX1zOXvxGK
v5kIGgp7ONoFi04dga6uZlCjwzYQVANU8kW7pJVVouVG3rqUpA/jYmC/oEjYuryE
wculeBIOUFn2SjeYmiV6BgFU6gZf5i6QvLH0ua5329+ATO/ZE+zZvtx8URKX9nJv
gYu26pu9HdifBicuO5jWG3s3zJCLa8lXTXQlaT8FX+D9eC1EGvudEXH21x9BVsU5
F6Dtt8lV7l6IgGzB+cE7X3w6YHigbsmktlIsRY6kDuA7ewKVuYnaDj8GSrj3UZF0
Xh49O0kepJLD7WQ9Y1H1DpdNIUN9nCHCmvtel82Rc0J2T1RowL9AfGZ+giddkop1
yzL1Tle4qHhdIePM/zSpV4hlJoa6hPBUXROydhC74jKTfca3eOlhNwcoifBzdQdQ
xXNw5ChyCFxZVZabdAsrByc0r6ypByv2CWfV+Axr95j+sOAKg0DEE5sFhgNQ/gTC
RNBy0V9ccnwNDtArI7p6piNNxuPnW9s0C1gd7wMQOha+PzgNkHC2n/ZOTFOAjnD6
queAg9A/oyfj+id3403dblcoClIiN+meCjbMW+qzMQz8+ebMUC68c22EnW++JmSc
fTBSZ02GP2m8cvqY/Se1F3Aao6MqzMPRK2gGRSBr+2Z6RQl6YIbq7v0LSnlz0FMu
2eLyNG2Aw6s=
=YEvm
-----END PGP SIGNATURE-----

--Sig_/nI+1eFQpU2enEKtekO3UQ0M--
