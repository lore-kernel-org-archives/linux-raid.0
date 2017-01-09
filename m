From: NeilBrown <neilb@suse.com>
Subject: Re: using the raid6check report
Date: Mon, 09 Jan 2017 12:56:03 +1100
Message-ID: <87h959j8ss.fsf@notabene.neil.brown.name>
References: <14e8ec23-de4a-e90b-4b67-155e5e3cc228@eyal.emu.id.au> <20170108174010.GA3699@lazy.lzy> <5872A698.7000009@youngman.org.uk> <20170108214111.GA7933@lazy.lzy> <87pojxjhwt.fsf@notabene.neil.brown.name> <62f5d174-0aef-5a70-68c3-26f7763b5e61@eyal.emu.id.au>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <62f5d174-0aef-5a70-68c3-26f7763b5e61@eyal.emu.id.au>
Sender: linux-raid-owner@vger.kernel.org
To: Eyal Lebedinsky <eyal@eyal.emu.id.au>, list linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Mon, Jan 09 2017, Eyal Lebedinsky wrote:

>
> I am aware of that discussion and agree with the sentiment (fix in user space).

(I primarily provided for the information of others)

> What I miss is a message from md when a 'check' mismatch is found. Not having
> this means I have to run 'raid6check', then after looking at the situation
> run 'raid6check autorepair' in the small sections reported as bad. This is time
> consuming and risky.

Something like this?

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 69b0a169e43d..f19c38baf2b2 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2738,6 +2738,8 @@ static void handle_parity_checks5(raid5_conf_t *conf, struct stripe_head *sh,
 			conf->mddev->resync_mismatches += STRIPE_SECTORS;
 			if (test_bit(MD_RECOVERY_CHECK, &conf->mddev->recovery))
 				/* don't try to repair!! */
+				pr_debug("%s: \"check\" found inconsistency near sector %llu\n",
+					 md_name(conf->mddev), sh->sector);
 				set_bit(STRIPE_INSYNC, &sh->state);
 			else {
 				sh->check_state = check_state_compute_run;


I chose pr_debug() because I didn't want to flood the logs if there are
lots of inconsistencies.
You can selectively enable pr_debug() messages by writing to
/sys/kernel/debug/dynamic_debug/control
providing you have dynamic debugging compiled in.

Maybe use pr_info_ratelimited() instead??

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlhy7bMACgkQOeye3VZi
gbm4gg/9G2eHc59rsUjZcEKcLm9gVXyALk5sUZbtdhaEieylvR0oxLRmcMs4V2Rm
9k9tGQunsldCp7Kmw9tti/n8HoRueX4jQmY/qFUzSRXBrK/uJ12RQrP+stkPc/BD
M6oDx2U5iGAHZt4c543Xh5Sm+T4mVgYHWhPtZx0RX4KdZ3eNBhv8dfTJ/88QRpCq
mspdShv0sbK0adKFoFSosgOh8N7M9vKKA5hjJMNpyLNFkbZMzNU6c7GI0jSlRTKn
u6CRx/M9x3cVDM59OyOuYD/VX17tnkoEPBY7czSoymfy/qQ11gUkEwWuo+L1JsS4
ghD2Qcgqps/846QaDva5WHUmfzManXgMt4Kv3heJAYHJeiCe+CLdwvB0QnQvZIOl
XlNMJlBEiKIki0orN/T/3hTWrzkxv8BEGhJp1qTEjPlbB5LQAplTCJHyIP2ExVy+
rn5kl4Be0QkZ3/zjZcj+zwPuIJ0fOWqSztUeHemPoZqCeUvz0Uvby1UGTAs+5oUI
CwHmUVGW5tqNcp6cR1DZ9PLCz6s0BFUF2C+XOeKI5MdyvEQbXBAYNWxBD7hwJh+Z
JW5ycYeAAHlu/wyGF3XQovGs9sJ2N9s0ftslxEh3M8h7zekrklZeWnG98/ZE5zUi
y06KGhaArjxYdDMB9FMqRXWQpGMC1GfiWYoTedam17y2XVt7Frs=
=Rej2
-----END PGP SIGNATURE-----
--=-=-=--
