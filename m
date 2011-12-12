From: NeilBrown <neilb@suse.de>
Subject: Re: raid6 rebuild not starting
Date: Mon, 12 Dec 2011 14:01:19 +1100
Message-ID: <20111212140119.35dbf92e@notabene.brown>
References: <4EE455B2.2040105@iki.fi>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/gzXeeA5U0WKu75OhY/43Vok"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4EE455B2.2040105@iki.fi>
Sender: linux-raid-owner@vger.kernel.org
To: Anssi Hannula <anssi.hannula@iki.fi>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/gzXeeA5U0WKu75OhY/43Vok
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 11 Dec 2011 09:03:14 +0200 Anssi Hannula <anssi.hannula@iki.fi> wro=
te:

> Hi!
>=20
> After I rebooted during a raid6 rebuild, the rebuild didn't start again.
> Instead, there is a flood of "RAID conf printout"s that seemingly happen
> on array activity.
>=20
> All the devices show up properly in --detail and two devices are marked
> as "spare rebuilding", and I can access the contents of the array just
> fine, but the rebuild doesn't actually start. Is this a bug or am I
> missing something? :)
>=20
> I was initially on 2.6.38.8, but also tried 3.1.4 which seems to have
> the same issue. mdadm is 3.1.5.
>=20
> I'm not using start_ro and writing to the array doesn't trigger a
> rebuild either.
>=20
> Attached are --examine outputs before assembly, kernel log output on
> assembly, /proc/mdstat and --detail after assembly (on 3.1.4).
>=20

Thank you for the very detailed problem report.

Unfortunately it is a complete mystery to me what is happening.

The repeated "RAID conf printout" messages are almost certainly coming from
the end of raid5_remove_disk.
It is being called from remove_and_add_spares for each of the two devices
that are being rebuilt.  raid5_remove_disk declines to remove them because =
it
can keep rebuilding them.

remove_and_add_spares then counts them and notes there are 2.
md_check_recovery notes that this is > 0, so it should create a thread to r=
un
md_do_sync.

md_do_sync should then print out a message like
  md: recovery of RAID array md0

but it doesn't.  So something went wrong.
There are three reasons that md_do_sync might not print a message:

1/ MD_RECOVERY_DONE is set.  As only md_do_sync ever sets it, that is
    unlikely, and in any case md_check_recovery clears it.
2/ mddev->ro !=3D 0.  It is only ever set to 0, 1, or 2.  If it is 1 or 2
   then we would be able to see that in /proc/mdstat as a "(readonly)"
   status.  But we don't.
3/ MD_RECOVERY_INTR is set. Again, md_check_recovery clears this.  It does
   get set if kthread_should_stop() returns 'true', but that should only
   happen if kthread_stop() was called.  That is only called by
   md_unregister_thread and I cannot see any way that could be call.

So.  No idea.

Are you compiling these kernels yourself?
If so, could you:
 - put a printk in the top of md_do_sync to report the values of
   mddev->recovery and mddev->ro
 - print a message whenever md_unregister_thread is called
 - in md_check_recovery, in the=20
		if (mddev->ro) {
			/* Only thing we do on a ro array is remove
			 * failed devices.
			 */
			mdk_rdev_t *rdev;

  in statement, print the value of mddev->ro.

Then see which of those printk's fire, and what they tell us.

NeilBrown


--Sig_/gzXeeA5U0WKu75OhY/43Vok
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTuVugDnsnt1WYoG5AQKyEw/8CEkSzAqRFvjpsa17CWTO8KWbSH5ZQImv
Y7qHJZrrJwoR3a1CHvR1sG+IrPq3k/cr1HiAF129+9TyM07KIL7uW6iuzvh1zkyP
IGVxsYepW6rmdAG6RtRljwybVYuW/6PaTY1aH3e7yTt2AsjX0N6wnNpLCE1ZIYlp
j7VngDBtPOSZiPRifdZ/5cztC2C0EoNoQskRu2bLHddOTn2mSCrc9Z+BfKjZBTK3
VsB+J5zgRHqi938bMFzP/2GHDklHO9h+tnpe5l55YARVjqemG7L1PfqMtH4TxKgY
EXfXxlokcAatiQ2Gje0GMhsvtar2WxmbVsk3Aywr9t36VORJjfDRnA7ZcG/zre9r
NQ6s7JMenmyydagwNqQkN/ICafDgdA7Y7UaymhPfPC6S9zlJGyI2Zl0vC+OqmLVL
jKMUD1xo+p1LltGTn4Cl/Ub2J9K7RbY7MYnbnXIi10MTt/e3WWVE89um+4po4PAv
X5PEZ3bY6bHG74RleLdUjZ42o8m8fR7NobXeyc+aF3giFZ+eOilZFrjGAjDVqdGX
9hZ1IKz0z9ijnKNce2tnzKk2FZ+G/Kwu3rElb+JXNZoZBfYJrU9LcnZj8cffNWkh
MXFvDsEJgsSS6htpyD03E/QNIjdXSf+CL0eqVdMf9ecx8nwmScvtwbsOQhdpz9uq
0qMOzbtKYLc=
=I/lR
-----END PGP SIGNATURE-----

--Sig_/gzXeeA5U0WKu75OhY/43Vok--
