From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 1/2] md: clear CHANGE_PENDING in readonly array
Date: Thu, 24 Sep 2015 14:03:53 +1000
Message-ID: <87fv24wjiu.fsf@notabene.neil.brown.name>
References: <bda150068cfdb69bf8b632c32dc2a7db17c919f4.1442596586.git.shli@fb.com> <87eghpy8k2.fsf@notabene.neil.brown.name> <20150923062302.GA2780132@devbig084.prn1.facebook.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150923062302.GA2780132@devbig084.prn1.facebook.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>
Cc: linux-raid@vger.kernel.org, Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Shaohua Li <shli@fb.com> writes:

> On Wed, Sep 23, 2015 at 04:05:33PM +1000, Neil Brown wrote:
>> Shaohua Li <shli@fb.com> writes:
>>=20
>> > If faulty disks of an array are more than allowed degraded number, the
>> > array enters error handling. It will be marked as read-only with
>> > MD_CHANGE_PENDING/RECOVERY_NEEDED set. But currently recovery doesn't
>> > clear CHANGE_PENDING bit for read-only array.  If MD_CHANGE_PENDING is
>> > set for a raid5 array, all returned IO will be hold on a list till the
>> > bit is clear. But recovery nevery clears this bit, the IO is always in
>> > pending state and nevery finish. This has bad effects like upper layer
>> > can't get an IO error and the array can't be stopped.
>> >
>> > Signed-off-by: Shaohua Li <shli@fb.com>
>> > ---
>> >  drivers/md/md.c | 1 +
>> >  1 file changed, 1 insertion(+)
>> >
>> > diff --git a/drivers/md/md.c b/drivers/md/md.c
>> > index 95824fb..c596b73 100644
>> > --- a/drivers/md/md.c
>> > +++ b/drivers/md/md.c
>> > @@ -8209,6 +8209,7 @@ void md_check_recovery(struct mddev *mddev)
>> >  			md_reap_sync_thread(mddev);
>> >  			clear_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
>> >  			clear_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
>> > +			clear_bit(MD_CHANGE_PENDING, &mddev->flags);
>> >  			goto unlock;
>> >  		}
>> >=20=20
>> > --=20
>> > 1.8.1
>>=20
>> Hi,
>>  I can see that clearing MD_CHANGE_PENDING there is probably correct -
>>  bug introduced by
>>    Commit: c3cce6cda162 ("md/raid5: ensure device failure recorded befor=
e write request returns.")
>>=20
>>  However I don't understand your reasoning.  You say that the array is
>>  marked as read-only, but I don't see how that would happen.  What
>>  causes the array to be marked "read-only"?
>
> It's set read-only by mdadm. I didn't look carefully, but looks there is
> disk failure event, mdadm is invoked automatically by some background
> daemon. It's a ubuntu distribution.

Thanks.
This raises a couple of questions.

1/ What should md_set_readonly do if it finds that MD_CHANGE_PENDING is
   set?
  Maybe it should wait for md_check_recovery to get run which should
  clear the bit, after probably writing out the metadata.

2/ Why didn't md_check_recovery already do that before mdadm had a
   chance to set the array read-only?
  I guess that is just a timing thing.  md_check_recovery could be
  delayed, and mdadm could get called by udev rather quickly.

I think I'll get md_set_readonly to
	wait_event(mddev->sb_wait,
		   !test_bit(MD_CHANGE_PENDING, &mddev->flags));

because I think that is the right thing to do.  But if the array is
already read-only that won't help, so I'll still need you patch.

Would you be able to test that the following patch (without your patch)
also fixes the symptom?

Thanks.
NeilBrown

From=20a0a21b57523c41e87e0a50333b15f6c7ca02d714 Mon Sep 17 00:00:00 2001
From: NeilBrown <neilb@suse.com>
Date: Thu, 24 Sep 2015 14:00:51 +1000
Subject: [PATCH] md: wait for pending superblock updates before switching to
 read-only

If a superblock update is pending, wait for it to complete before
letting md_set_readonly() switch to readonly.
Otherwise we might lose important information about a device having
failed.

Reported-by: Shaohua Li <shli@fb.com>
Signed-off-by: NeilBrown <neilb@suse.com>

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 23651bf8dd80..9882f70f45e1 100644
=2D-- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5432,6 +5432,8 @@ static int md_set_readonly(struct mddev *mddev, struc=
t block_device *bdev)
 	mddev_unlock(mddev);
 	wait_event(resync_wait, !test_bit(MD_RECOVERY_RUNNING,
 					  &mddev->recovery));
+	wait_event(mddev->sb_wait,
+		   !test_bit(MD_CHANGE_PENDING, &mddev->flags));
 	mddev_lock_nointr(mddev);
=20
 	mutex_lock(&mddev->open_mutex);

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWA3YpAAoJEDnsnt1WYoG5zUsQAJs6MkAsYVJwVmLPv1k3CqmX
eEc0Z7+YlZH0DHUUSZ9be55ZqJ3uvmP4/WUtaAEAy0mMckyFrMu989WIlbQcFjFz
5y4LEKBDqUWT3w3kUOIH+4jztrtgqCpbdMoiODybfKp9ZOgB1Ffr056t7pnSoOLV
JuTGfjO+uYrnfrey3E/A0hQkAHxLEJvll4C8E63B6Aas3oPQZtyWiCigdJDz5FE5
IVhI7QHr0+r9d/rB7LO/xP1PvxJV+WYD4eODmUvmHGR0K0aU5TOvi4moGelP7Zqi
B/YmHpe/Dtv9OQ/UG5rqBfIbUuaM1Gp1CShwA9J2/9kj8HU3OLFb8XVmIrU2ED36
wsrdG8I0HuqFUVcUeR3/KoUb4quLMekE2GG5FhBwhFPuuHb+ENIdn8GIyb7ykApk
3liYqe5uQ+DXmhssld/daRcZ6qge8kYuX6paJhRXo+rooBRvkRE5QLdzhClqpQ0m
SdcZXADj2tHcFLRRBrGF0U+Dtft8lOWIsSKY7a9tdgAmshyvzuRBTYHHju8GPMqr
mRMkBqo76/Nzduj+Edbx3uuHJL5FBZc9I78dzLgJH0wvNvj0raDBrXYzpdAuAFn8
MdEyaBtKv+ryrWZ+0xZtJz/VcPx9aDMNCMrlRhlZ1CnUZcTIahS9Jchp2RWwR0NV
/iVY0pMNxXn1Hg0LsMpj
=z3H4
-----END PGP SIGNATURE-----
--=-=-=--
