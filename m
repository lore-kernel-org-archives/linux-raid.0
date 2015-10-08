From: Neil Brown <neilb@suse.de>
Subject: Re: raid5-cache I/O path improvements V3
Date: Thu, 08 Oct 2015 13:45:02 +1100
Message-ID: <87k2qy6pu9.fsf@notabene.neil.brown.name>
References: <1444030276-30850-1-git-send-email-hch@lst.de> <20151006181335.GA3367313@devbig084.prn1.facebook.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20151006181335.GA3367313@devbig084.prn1.facebook.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>, Christoph Hellwig <hch@lst.de>
Cc: dan.j.williams@intel.com, Kernel-team@fb.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Shaohua Li <shli@fb.com> writes:

> On Mon, Oct 05, 2015 at 09:31:05AM +0200, Christoph Hellwig wrote:
>> Hi Shaohua, hi Neil,
>>=20
>> this series contains a few updates to the raid5-cache feature, and goes
>> on top of dm/devel + the series Shaohua sent yesterday.
>>=20
>> Besides the rebase the only changes compared to the previous version
>> is that we only bypasss the batch and flush state for devices that
>> do not have a volatile cache at all like persistent memory or high
>> performance flash devices.
>
> Thanks Christoph, patches look great.
>
> Reviewed-by: Shaohua Li <shli@fb.com>

Thanks.  I've applied all these (fixing up minor conflict due to an
earlier patch I didn't accept yet).  They are all in my 'devel' branch.

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWFdiuAAoJEDnsnt1WYoG5PJsP/ipCltphc8G0F1g/9KDBlvvR
jyz7g6G6aHenSwxuhQ2CyLLQPNPqow0k85CdFIfD0wNR03cQAO3FgltrG4pz0PVu
RIx4HD19N5FwPFZLkrGK0/JhcNolYHmLQHR7Qg6oG1JbYTdeA1dMpV72a5vrhVP6
EXpwKMOBj6LNqan/E1X8/zPvuUf95smKrwFYFBrLgvxR0T+LFYwtF1ziJQFeI7cp
7faYitmDLfZ90pznmmMl8/U4/7JB1NYpiHiR3BXgqfz88inKklWEvaRLHPMWrnrI
n/O3a9GDQKPOYcnhSlBCkDOhbxRmAXKaMt3E7k18btQzo7wVQHz3iAV+d1agXbHz
33UnvkLdTm652q6bKxuQSvIVOrS+QyOonGsXqGM/nHZtSFNVD8EOrPNj7d+yQ49C
09dGc1kfvDKRLTaQXCEwQUclBw1SjJRCpQChI5SClk86gF+4ybD8YAIMM79GzWan
cq9CneQ0KH+aE7Tkwl0p51n/5/sqXS8AXoP6uA66jH+BX7ol3fMBH9x4TO3ofV4b
LLeVKU1jnR7BGMZKD5yGxZca/LhawiWPO+xaf34A572OKv2NWEHlw+n6RQlpD/HJ
sCn5VsqY8X5T6SgW5CB7bFtCZuT/4mu+g4BAibZAMjH1hdCEcJIL0rcUMZfVF7pv
Gpi9r+otwOe14VzC5FQ9
=8319
-----END PGP SIGNATURE-----
--=-=-=--
