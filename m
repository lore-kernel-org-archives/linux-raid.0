From: NeilBrown <neilb@suse.com>
Subject: Re: Resync issue in RAID1
Date: Fri, 28 Oct 2016 15:01:52 +1100
Message-ID: <8760odt93j.fsf@notabene.neil.brown.name>
References: <CAF9xHmRCKzBXE5_tdqNY9BJJn7LyC8bOv8OaFXpxc1BvGUTCeQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAF9xHmRCKzBXE5_tdqNY9BJJn7LyC8bOv8OaFXpxc1BvGUTCeQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: V <viswesh.vichu@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Sat, Oct 22 2016, V wrote:

> Hi,
>
> I am facing an issue during RAID1 resync. I have an ubuntu
> 4.4.0-31-generic running with raid1 configured with 2 disks as active
> and 2 as spares. On the first powercycle, after installing RAID, i see
> the following messages in kern.log
>
>
> My disks are configured with 4K sector size (both logical and
> physical) (sda and sdb are active disks for this raid)
>
>
> ===========
> Oct 18 03:52:56  kernel: [   52.869113] md: using 128k window, over a
> total of 51167104k.
> Oct 18 03:52:56  kernel: [   52.869114] md: resuming resync of md2 from checkpoint.

This line (above) combined with ...

> Oct 18 03:52:56  kernel: [   52.869536] md/raid1:md2: sda: unrecoverable I/O read error for block 3

this line suggests that when you shut down, md had already started a
resync, and it had checkpointed at block '3'.

The subsequent error are:

> Oct 18 03:52:56  kernel: [   52.869692] md/raid1:md2: sda: unrecoverable I/O read error for block 131
> Oct 18 03:52:56  kernel: [   52.869837] md/raid1:md2: sda: unrecoverable I/O read error for block 259
> Oct 18 03:52:56  kernel: [   52.870022] md/raid1:md2: sda: unrecoverable I/O read error for block 387

which are every 128 blocks (aka sectors) from '3'.
I know what caused that.  The patch below will stop it happening again.

You might be able get your array working again by stopping it
and assembling with --update=resync.
That will reset the checkpoint to 0.

NeilBrown

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 2cf0e1c00b9a..aa2ca23463f4 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8099,7 +8099,8 @@ void md_do_sync(struct md_thread *thread)
 	    mddev->curr_resync > 2) {
 		if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery)) {
 			if (test_bit(MD_RECOVERY_INTR, &mddev->recovery)) {
-				if (mddev->curr_resync >= mddev->recovery_cp) {
+				if (mddev->curr_resync >= mddev->recovery_cp &&
+				    mddev->curr_resync > 3) {
 					printk(KERN_INFO
 					       "md: checkpointing %s of %s.\n",
 					       desc, mdname(mddev));

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJYEs2wAAoJEDnsnt1WYoG5+esQAKW/d9YI94jlfmiCo9+LxWdE
4x4Hk3kb5UuWo0uMbedZFQxmMVHMGEa0t2ZtxSSa0vZ8BMm3LMi3ZC+NbbBaRftu
rJ0ehrJ6x9JdNRrMJk6SX0kSfM/Czz2FyTMt4g0zUuYOgge+OLoZQBwSNCQGFYvR
XrqfumVJhThfVxGFZZ2YQHbUuGxdNUkdAieVqgBzgsxZl4N3tw6kk2NPxeGoS1yG
pd6IwM4SJaQq6UzS/mVOM/59fwUjKc6V0+r3SW0tcF6XlqUJ/wN+JKukYxkbY+e0
nXwTcPAThDo9DYRzGcFt2PucjE/coTuuZtdy0vDyHu5lgQx/ktjqh23rju0Jm556
bmgJMLK0A0/p5L7Dj9qKmEWfvHZ74gFMcm1TAT4oybmq73NtElERuybJ6Lfp/L9M
ovH3meZU7b5AMBd4ywTdepDPDrQQoVTaFdW/ORPTlZBUen7NZ0wc+zdADZQTIDPN
NQce84cQjj1qUU54Xs/fB7qv7SJiKkZ9TPK6vOk6Syp/HyNUtZyVlpgHJ5fGRHy2
7D8h9jk8gvqx0YQ0npog/EQz3Ddia1UUid799a0+9QDJo87gIfId0qf0V2+rsT3c
3BShUpGKzwCW6xqLgLoDe8uS5rfPsorxdDtnsfWMwmY3bl7lNw7EBaRGVZmPQwfy
23e0EjHdVhWkf07dp+HA
=LRdJ
-----END PGP SIGNATURE-----
--=-=-=--
