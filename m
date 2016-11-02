From: NeilBrown <neilb@suse.com>
Subject: Re: [md PATCH 0/9] replace printk() with pr_*()
Date: Thu, 03 Nov 2016 08:14:34 +1100
Message-ID: <87d1idr3d1.fsf@notabene.neil.brown.name>
References: <147805657658.23566.1748253447749986766.stgit@noble> <5cd6d570-6d72-07b4-34a4-5b75503fcbf4@suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5cd6d570-6d72-07b4-34a4-5b75503fcbf4@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 02 2016, Hannes Reinecke wrote:

> On 11/02/2016 04:16 AM, NeilBrown wrote:
>> This series removes all printk() calls from md code, preferring
>> pr_warn(), pr_err() etc.
>>
>> All strings that were split over multiple lines are not joined
>> back together because being able to search for a message is more
>> important that not having long lines in the code.
>> Lots of printk(KERN_DEBUG... are not pr_debug() which means the
>> messages won't get printed unless they are explicitly disabled.
>>
>> I included some rough guidelines on which pr_* to choose in md.c.
>> Many things became pr_debug(), most of the rest are pr_warn().
>> pr_err() and pr_crit() are used sparingly.
>>
>> I simplified some code in multipath.c too.
>>
>> A particular benefit of this is that the various "print_conf()"
>> functions are not silent by default.
>> On very large arrays (raid10 with hundreds of devices), these can
>> be very noisy.
>>
> Any specify reason why you didn't move to use dev_*() style of errors?
> Generally I prefer having the messages prefixed with the device which=20
> caused them; making debugging _so_ much easier ...

I was already a bit concerned about how much change was in the one set
of patches:
 - rejoining large strings
 - changing printk to pr_*
 - revising log levels

I wouldn't want to add more change.  But as something to be added
afterwards I support the idea in principle, but in practice.....
What device would you pass to dev_*() ??
  disk_to_dev(mddev->gendisk)
  ??

That wouldn't work when dm-raid is in the picture, as mddev->gendisk is
NULL in that case.

Is some cases we already include the md_name().  If there a specific
places were it could be added, I would certainly support adding the dev
name.  I just don't think dev_*() is the way to do it for md.

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJYGlc6AAoJEDnsnt1WYoG5QvwP/RY34JBU/aqC3UnLl1LL7KiK
XCSKCXfnhbPW1ho8ZRELHXiDMH2CI35W7Z6/Zg/cns0FdyjBHuwHOw0NEJrjfwYu
9xzHr6/NcFj4ONYKQfaQPE6ktRfvnVjbtNSV6moMYPKIdkEUHGPYgLRtuQtX3JkY
M8A02NoHWD1Y6LqTdl09npE6nlDqtBJggCUVniq3aNWg1GWMRI8gsrVvKQJGmPrv
a1QcF3atF+cB/+x/M8T6OHC6m4MvOnXLhe2aIg/8MtFMkQj6kU4nsu3uvtDFNulG
pbiJSgqpUdyRLs+RRihHGAOxCAJRcv/ibq/aGbKVs1Zwva7+KTUXlJ6VLm0xDHdc
MAsHENBgxNwmgCIO08o3KJhuPNeliu92emc/RD2n0AqfsmmKIOekUDv14v33YzfG
0TN+gMKdD9KU/8zEoRu1z9muiAgncwUFP1KN6vECeBhY6opswlnlCeLtbrWOB+mG
H3tf6iidCCqoG9el/XF9aXh7mo33QCLH4jJJ8wb/g5Wr34v19HL0Tw7ujiQxK1LM
arY434NoeY1jaikwWi4rYYookYCqOiloLf6Vl18jEuw8yfRAc1lWc/jfhUJjZZaz
QrU0EdKIwG08kWjx2EEsqUUIbJf8TdbVWVJivp8fxLk/HEiZQp606od7zpQa6lI0
lauDsUQvdupzt2iEfr+A
=dgsE
-----END PGP SIGNATURE-----
--=-=-=--
