From: NeilBrown <neilb@suse.com>
Subject: Re: [md PATCH 1/5 v2] md: always hold reconfig_mutex when calling mddev_suspend()
Date: Mon, 23 Oct 2017 11:02:23 +1100
Message-ID: <87sheaenow.fsf@notabene.neil.brown.name>
References: <150820826980.1646.6380214598725492144.stgit@noble> <150820840340.1646.12365558035859364361.stgit@noble> <20171018061107.42kpztc3nbnhbavi@kernel.org> <87efq0j4d2.fsf@notabene.neil.brown.name> <87lgk8gcmb.fsf@notabene.neil.brown.name> <20171019034420.sdxvirpv454vgx4h@kernel.org> <8760bbhcql.fsf@notabene.neil.brown.name> <20171020042820.iredht4f7lvatdst@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20171020042820.iredht4f7lvatdst@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 19 2017, Shaohua Li wrote:
>> >
>> > For this one, my point is:
>> >
>> > 	wait_event(mddev->sb_wait, conf->log =3D=3D NULL ||
>> > 		   !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags));
>> > 	if (conf->log =3D=3D NULL)
>> > 		return;
>> >
>> > 	mddev_suspend(mddev);
>> > 	log->r5c_journal_mode =3D R5C_JOURNAL_MODE_WRITE_THROUGH;
>> > 	mddev_resume(mddev);
>> >
>> > does it work?
>>=20
>> The
>> 	lockdep_assert_held(&mddev->reconfig_mutex);
>> in mddev_suspend() will complain.
>>=20
>> If you put an mddev_lock() call in there to stop the complaint, and if
>> the work item doesn't start before the reconfig_mutex is taken prior to
>> stopping the array, then r5l_exit_log() can deadlock at
>> 	flush_work(&log->disable_writeback_work);
>
> Ok, got it now. But really don't like this patch. The mddev_unlock is str=
ange,
> r5c_disable_writeback_async could skip disabling writeback too. Could we =
add a
> new callback like .prepare_free, and flush workqueue there. After we drop=
 the
> reconfig_mutex in do_md_stop, we call the prepare_free. We can probably s=
et a
> flag, so later r5c_disable_writeback_async will bail out doing nothing. I=
 think
> this should work, right?

Might work, though it sounds more messy to me (assuming I understand).

I would like to get rid of disable_writeback_work altogether.
Just set  log->r5c_journal_mode =3D R5C_JOURNAL_MODE_WRITE_THROUGH in
r5c_update_on_rdev_error(), and make sure that does the right thing.

The distinction between write-through and write-back should be able to
be a per-stripe_head distinction.  Once we set r5c_journal_mode, new
stripe_heads will get the new mode, old ones are allowed to continue how
they are.
Maybe we could keep a counter of how many stripes are in WRITE_BACK
mode, and test that counter in r5c_is_writeback()??

I don't know what all the issues are so it would need careful review,
preferably by someone familiar with the code.

Short of that, I think my current patch is the best interim step.  I
agree that it isn't the most elegant thing ever, but it is localized and
I believe it works correctly.
The "mddev_unlock()" shouldn't look too strange, it perfectly balances
he mddev_try_lock().

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlntMZAACgkQOeye3VZi
gbn0UBAAoy+mCSvVU/Hz0VdhIm2Bds/5t/ls7WXoEH4JJz6uy52B1mWEEXW23dtA
oB0HWEZ3LpZCUVQmhRjo215gtryutcci9mAgS3tGFpnIkAkE2IIuBJ3Y9Q7mAu3z
tepDb40B6JPCCMds55ROzf9dfW+s7e2TviYGdeFGlo0JTROM85jvoI7VogrEsyUE
suTEvEDwJ4/Iiy06szlnRt8s7MMfYDZ0khTCmgamrOSNnac+piGBU+yg0ky2yHUM
WOogUSFnflQgE7ejYMfym+dhenO8q3jeVtL8OQuACbV6ZVsPEfytSfWk+heHS3Y7
/AcNTwolsssJavCA6FK9fCqev2/a/twyh87GOpa7MR+ApP05HHdHAqEHrfGjUXgk
wFpKDWW9BEtQ20RrhYPfPC34En6XJBix/K+pCTqBpl7/gzNc3kTiI2pDSZ/15STp
ZAVaXVCIvQ6FfGCCuxCfN28T99b4wTrWSgr5sqXY4xh5itEB3noJeyjgr1k4zioc
6KdjSvs/61Oqfs6Zg3aGpEdT8aKUq8BjqEd8UDZfdDoj8lLviLMkgoCpJNfCzzVV
olxaaM+264DuctuIcxhBu2NTfxbTZwIxBfCqqs/JMQ/4q7/rhgiS9PM4wLb/eRex
36+1VMtUvUKkEDxSDijrPMw0xVaWbxNm6B7vYk63gnFEgEBvaqU=
=+9H0
-----END PGP SIGNATURE-----
--=-=-=--
