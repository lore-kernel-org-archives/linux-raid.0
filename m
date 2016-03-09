From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH] md/raid5: preserve STRIPE_PREREAD_ACTIVE in break_stripe_batch_list
Date: Thu, 10 Mar 2016 06:19:42 +1100
Message-ID: <87lh5rjw6p.fsf@notabene.neil.brown.name>
References: <87r3fkjttq.fsf@notabene.neil.brown.name> <20160309172652.GA8073@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160309172652.GA8073@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: Shaohua Li <shli@fb.com>, linux-raid@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Martin Svec <martin.svec@zoner.cz>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 10 2016, Shaohua Li wrote:

> On Wed, Mar 09, 2016 at 12:58:25PM +1100, Neil Brown wrote:
>>=20
>> break_stripe_batch_list breaks up a batch and copies some flags from
>> the batch head to the members, preserving others.
>>=20
>> It doesn't preserve or copy STRIPE_PREREAD_ACTIVE.  This is not
>> normally a problem as STRIPE_PREREAD_ACTIVE is cleared when a
>> stripe_head is added to a batch, and is not set on stripe_heads
>> already in a batch.
>>=20
>> However there is no locking to ensure one thread doesn't set the flag
>> after it has just been cleared in another.  This does occasionally happe=
n.
>>=20
>> md/raid5 maintains a count of the number of stripe_heads with
>> STRIPE_PREREAD_ACTIVE set: conf->preread_active_stripes.  When
>> break_stripe_batch_list clears STRIPE_PREREAD_ACTIVE inadvertently
>> this could becomes incorrect and will never again return to zero.
>>=20
>> md/raid5 delays the handling of some stripe_heads until
>> preread_active_stripes becomes zero.  So when the above mention race
>> happens, those stripe_heads become blocked and never progress,
>> resulting is write to the array handing.
>>=20
>> So: change break_stripe_batch_list to preserve STRIPE_PREREAD_ACTIVE
>> in the members of a batch.
>>=20
>> URL: https://bugzilla.kernel.org/show_bug.cgi?id=3D108741
>> URL: https://bugzilla.redhat.com/show_bug.cgi?id=3D1258153
>> URL: http://thread.gmane.org/5649C0E9.2030204@zoner.cz
>> Reported-by: Martin Svec <martin.svec@zoner.cz> (and others)
>> Tested-by: Tom Weber <linux@junkyard.4t2.com>
>> Fixes: 1b956f7a8f9a ("md/raid5: be more selective about distributing fla=
gs across batch.")
>> Cc: stable@vger.kernel.org (v4.1 and later)
>> Signed-off-by: NeilBrown <neilb@suse.com>
>
> Applied, thanks Neil! I'll split the WARN_ON_ONCE and do it for each bit,=
 so
> next time we can have clear clue.

I personally think that would look ugly and increase the in-line code
size for minimal gain.
If you want to make a change (which I'm in two minds about) I think it
would be much cleaner to do
  if (WARN_ON_ONCE(...)) printk(....);

Then at least the extra code will be out of line - not even loaded into
the instruction cache until needed.

Thanks,
NeilBrown

>
> Thanks,
> Shaohua
>
>> ---
>>  drivers/md/raid5.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>=20
>> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
>> index b4f02c9959f2..2e7d253be6ce 100644
>> --- a/drivers/md/raid5.c
>> +++ b/drivers/md/raid5.c
>> @@ -4236,7 +4236,6 @@ static void break_stripe_batch_list(struct stripe_=
head *head_sh,
>>  		WARN_ON_ONCE(sh->state & ((1 << STRIPE_ACTIVE) |
>>  					  (1 << STRIPE_SYNCING) |
>>  					  (1 << STRIPE_REPLACED) |
>> -					  (1 << STRIPE_PREREAD_ACTIVE) |
>>  					  (1 << STRIPE_DELAYED) |
>>  					  (1 << STRIPE_BIT_DELAY) |
>>  					  (1 << STRIPE_FULL_WRITE) |
>> @@ -4251,6 +4250,7 @@ static void break_stripe_batch_list(struct stripe_=
head *head_sh,
>>  					      (1 << STRIPE_REPLACED)));
>>=20=20
>>  		set_mask_bits(&sh->state, ~(STRIPE_EXPAND_SYNC_FLAGS |
>> +					    (1 << STRIPE_PREREAD_ACTIVE) |
>>  					    (1 << STRIPE_DEGRADED)),
>>  			      head_sh->state & (1 << STRIPE_INSYNC));
>>=20=20
>> --=20
>> 2.7.2
>>=20

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJW4HdOAAoJEDnsnt1WYoG5lyEQAJzNnamKeEYKs0CyujrX7GwB
CaqsIcQkpLU0snGYWDzMWkUvmQhWayvnt0B2/jQQWf1ZSJVgGs1Hrj5c03llMSfV
ANXW771wxee7fV04HmVa05S+SCpRdjSFlQFy31qpC7h7zFMMNnLIwFyWqQDECZwA
PRfz2hJIYOdKCAMY0UAeO948v2fpiL469jeq1PXCzcZIcuhKrZOXkfTS6c8la3mf
Lvioux4LIRlghxM8eU9YVSlqYYQJR7pvDcFBmJbFA6My0viFXJa02c8jH2S9Cz0s
Zg0uZVwrIQbhEjRIdILcn92y0mk4s7NwvVYh5NW/xN2nCyJMfeC7nhLbsHLM3qJk
tWrQCLo2g5C8VT0836OsVze5N5fSvYkmDpRigQhp0nMYVhE20+1RfWsAZE7NMifH
MD+QT075zYVGnM4Isv5aX6tFhKO7D1RDHj1TobwC3sEPUWE7QilxSN/o6SsrY1OZ
Uu/+0crlfZL6+bCRmcZcvTd6XAFwWZpF4EOTxmAf49uf+KLgAYkHBIU0Sc/Qu+x2
4H5DK9JzXu+ic5Dh5L6v/cVnLUvh7EKf1tGbxWPeyu72CalhB1RH2E3K2cmCv1H0
aHMMC9MjyzPcXUbVMeagGjnFzGIup9bujGs/ddh/yxufPTlaFeWuKCJtJeF1YAco
lU4q0OtugTmas2NIba2o
=JIaC
-----END PGP SIGNATURE-----
--=-=-=--
