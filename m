From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH] super-intel: ensure suspended region is removed when reshape completes.
Date: Fri, 19 Feb 2016 08:57:39 +1100
Message-ID: <87povtptpo.fsf@notabene.neil.brown.name>
References: <871t8ar54j.fsf@notabene.neil.brown.name> <wrfjk2m1zvq9.fsf@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <wrfjk2m1zvq9.fsf@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-raid@vger.kernel.org, Ken Moffat <zarniwhoop@ntlworld.com>, Artur Paszkiewicz <artur.paszkiewicz@intel.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 19 2016, Jes Sorensen wrote:

> NeilBrown <neilb@suse.com> writes:
>> A recent commit removed a call to abort_reshape() when IMSM reshape
>> completed.  An unanticipated result of this is that the suspended
>> region is not cleared as it should be.
>> So after a reshape, a region of the array will cause all IO to block.
>>
>> Re-instate the required updates to suspend_{lo,hi} coped from
>> abort_reshape().
>>
>> This is caught (sometimes) by the test suite.
>>
>> Also fix a couple of typos found while exploring the code.
>>
>> Reported-by: Ken Moffat <zarniwhoop@ntlworld.com>
>> Cc: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
>> Fixes: 2139b03c2080 ("imsm: don't call abort_reshape() in imsm_manage_re=
shape()")
>> Signed-off-by: NeilBrown <neilb@suse.com>
>> ---
>>  super-intel.c | 7 +++++--
>>  1 file changed, 5 insertions(+), 2 deletions(-)
>>
>> diff --git a/super-intel.c b/super-intel.c
>> index 90b7b6dee5d0..80b48d0fdd47 100644
>> --- a/super-intel.c
>> +++ b/super-intel.c
>> @@ -10465,7 +10465,7 @@ int check_degradation_change(struct mdinfo *info,
>>   * Function:	imsm_manage_reshape
>>   * Description:	Function finds array under reshape and it manages resha=
pe
>>   *		process. It creates stripes backups (if required) and sets
>> - *		checheckpoits.
>> + *		checkpoints.
>>   * Parameters:
>>   *	afd		: Backup handle (nattive) - not used
>>   *	sra		: general array info
>> @@ -10595,7 +10595,7 @@ static int imsm_manage_reshape(
>>=20=20
>>  		start =3D current_position * 512;
>>=20=20
>> -		/* allign reading start to old geometry */
>> +		/* align reading start to old geometry */
>>  		start_buf_shift =3D start % old_data_stripe_length;
>>  		start_src =3D start - start_buf_shift;
>>=20=20
>> @@ -10700,6 +10700,9 @@ static int imsm_manage_reshape(
>>  	ret_val =3D 1;
>>  abort:
>>  	free(buf);
>> +	sysfs_set_num(sra, NULL, "suspend_lo", 0x7FFFFFFFFFFFFFFFULL);
>> +	sysfs_set_num(sra, NULL, "suspend_hi", 0);
>> +	sysfs_set_num(sra, NULL, "suspend_lo", 0);
>>=20=20
>>  	return ret_val;
>>  }
>
> This does indeed match the behavior of abort_reshape(), however looking
> through git history, I cannot find any explanation as to why the code
> sets suspend_lo twice.
>
> Any chance you can enlighten me why this is necessary?

This is what I never got when I was maintainer - people insisting
(rightly) that I explain the details...  Thanks!


Prior to
Commit: 23ddff3792f6 ("md: allow suspend_lo and suspend_hi to decrease as w=
ell as increase.")
you could only increase suspend_{lo,hi} unless the region they covered
was empty.  So to reset to 0, you need to push suspend_lo up past
suspend_hi first.
So to maximize the chance of mdadm working on all kernels, we want to keep
doing that.

Maybe you could add that to the change comment?  Or should there be a
comment in abort_reshape()??

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWxj5TAAoJEDnsnt1WYoG58REQAJgSqeeIE6LJSsWQpnXwcheD
8m9rVcXd4LhJSsRhQ3wtrrlocroHCQ6vbqLlabPUsIdzvl9o18VZjeP3sdNZ2V9K
LXjbzkXEziXWjROrMg8jZGqbC/Me+2/sNik6Lpe1PCb9dc7a3rOJR66SX0+1Mrkl
TMO1QLJxbTk16ZXC3jjw5SWW/JekYpykhVy16AQ46R/FP7M4F4qVQuUIIqqP9xIe
0BCE93zwWIEwaUTD6SwuboteLtn5D+81bP9E6W/M9JrJLFULm4jXEMMK6rnvtcSr
71rz5eTi+OLO4MZseuHsRfLht8gYM3A8uDWdt5kotfGLwL3WpSCEUtpwXwj8HOkv
+hE03BX70g9hbEZdrv5bMxw3CcQSUxpHu+g5s3wuZwZhOlGkufiK+vTx6sz9cRjb
v8yaEttAgs4D8qZ+dcUgGWy8edg30qio+W7TpTYU95afDE9GSZ7S+POLVZnB1xcR
+a8IHgpMBLFcAvWUuUkU+ssKnQzhCOQ8lykhWbbWzpAjzd2q1ZUlywQCik1FhO5U
4rQs05XJhuF0Sz3NDgvE8A9SNyv5RNXqG8b/Uga4B/78DmRh7+OXkE4TtacFh+p9
aAI/SuVd3f72fI0IDS8DCwgU5/Vf8V/R9I/dx89NSfEN2OT2ZG78RvUvRJdHoo3U
dT68K8lFl8DMVeIdomiY
=YJUb
-----END PGP SIGNATURE-----
--=-=-=--
