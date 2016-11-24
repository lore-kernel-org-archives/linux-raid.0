From: NeilBrown <neilb@suse.com>
Subject: Re: raid1 bitmap and multiple removed disks
Date: Thu, 24 Nov 2016 11:26:54 +1100
Message-ID: <87fumhbu41.fsf@notabene.neil.brown.name>
References: <ce2ba842-22f0-eebf-856c-f07d38574489@deviltechnologies.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ce2ba842-22f0-eebf-856c-f07d38574489@deviltechnologies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Diego Guella <diego.guella@deviltechnologies.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 23 2016, Diego Guella wrote:

> (2nd attempt: the previous one didn't make it)
> Hi,
>
> I am using linux raid1 for a double-purpose: redundancy and backup.
>
> I have a raid1 array of 5 disks, 3 of which are kept for backup purposes.
> Let's call disks A, B, C, D, E.
> Disks A and B are _always_ connected to the system.
> Disks C, D, E are backup disks.
> Here follows a description of how I use the backup disks.
> This morning I connect disk C, and let it resync.
> Tomorrow morning, I shut down the system, remove disk C and keep it away=
=20
> as a daily backup.
> I connect the next disk (D), then start up the system.
> Linux raid1 recognizes the "old" disk and does not allow it to enter the=
=20
> array (this is evidenced by system logs).
> I then add disk D to the array, and let it resync.

So this would be a full resync - right?

> The next day, I connect the next disk (E), and so on, rotating them.
> The "connect and disconnect" is always performed when the system is=20
> powered off, although sometimes I hot-connect the disk with the system=20
> already powered up.
> The purpose of this is to have an emergency backup: I can disconnect ALL=
=20
> disks from the system and connect only one of the daily backups, going=20
> "back to the past"(TM).
>
> This array has a write-intent bitmap, in order to speed up the resync=20
> (it is a 4TB array, and sometimes it needs nearly 20 hours to resync=20
> without bitmaps due to system load).
>
> This worked flawlessly (for some years) until some days ago, when the=20
> array suffered a strange inconsistency, and the filesystem nearly gone=20
> nuts in about 20 minutes of uptime. I will elaborate more on this
> later.

Did you ever test your backups?

>
> Since that problem happened, some questions come to my mind:
> What raid1 bitmaps allow me to do?

=2D accelerate resync after a crash.
=2D accelerate recovery when you remove a drive and re-add it.

> Can they record _correctly_ the state of multiple removed disks, in=20
> order to overwrite only out-of-sync chunks of multiple removed disks?

All that is recorded is the set of regions which have been written to
since the array was last in a non-degraded state.

> In other words, am I allowed to do what I described above?

If the recovery that happened when you swapped drives was not a full
recovery, then probably not.

> If not, can I change something in my actions in order to have a daily=20
> backup using raid1?

I wrote something about this a few years ago...
 http://permalink.gmane.org/gmane.linux.raid/35074

or this thread
  http://www.spinics.net/lists/raid/msg35532.html

NeilBrown

>
>
> System details:
> # cat /etc/debian_version
> 6.0.10
> # mdadm --version
> mdadm - v3.1.4 - 31st August 2010

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJYNjPOAAoJEDnsnt1WYoG5D4QP/iDEdb6FGxE80ONmRHQrEY3u
uAk2INRMtpH91dBTXNffs21CvM9qKfHs2jt219vjUTE9uSXRICuagUCNyLzRpjmB
G2hM7FQjMOEIFzVM/A3iTdX+c9VufXgTP/nwkdigZiZKxnxXqSJeBthj7kuOHrTc
namYd7MbB5i5zP0Vi3qfTEUf2LjC3+vHzlw6czVEQdwhZfz3/KyfyhkOjNNAxj/T
4mTPLznkZYQaWjJaew1MT7SHFTWTvU3D9khE81I8lnAbSq3mR/s4K9SorPopplVT
pElGANBOvKvY392MpfP3p82qlMpjv9vGBM7xQ5xAKR9QNjk3LmdKcSU68r0X1BG+
N5QVBKUTYFiyOyS1LTXxxYVGsPrJUCGmcpX1v+EGNsM1FOoD6hUQ6ZqlfPd6t4dw
6sb78QvhI2/5t8nHMCyxRXT8mIgPt7aobednuEQXd0hBMEgfSXgEqsUv0xezA4Xn
8KhWzVWhZOVsoBtQOMEdaNllaCHnGAOi0taFZ0PZwNXa25SJsbg/lHYh/6m87qM3
qQwfFok16PgiLfuiZbZi8GaLHCx+tt4i/Y6tZMY8wFk2/2lDU3OXh9nZ2kcwwUnF
8tBq62Uw44UtVEJd1Ufc+Wuv/VaLgJnPZpZtF1VA4TOvKCpzKBu4Cm6qB/Xv8END
BliUFTAxog2K+DMb1h9J
=um0R
-----END PGP SIGNATURE-----
--=-=-=--
