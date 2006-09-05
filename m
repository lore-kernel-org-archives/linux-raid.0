From: Patrik Jonsson <patrik@ucolick.org>
Subject: Re: Care and feeding of RAID?
Date: Tue, 05 Sep 2006 09:56:22 -0700
Message-ID: <44FDAC36.8040407@ucolick.org>
References: <44FD722C.7050608@waldoware.com> <20060905131454.GA28548@scavenger.homeip.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig54D0D7FCCBD6BE9A3FD4FA8C"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060905131454.GA28548@scavenger.homeip.net>
Sender: linux-raid-owner@vger.kernel.org
To: Benjamin Schieder <blindcoder@scavenger.homeip.net>
Cc: Paul Waldo <pwaldo@waldoware.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig54D0D7FCCBD6BE9A3FD4FA8C
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 05.09.2006 08:48:44, Paul Waldo wrote:
>> Hi all,
>>
>> I have a RAID6 array and I wondering about care and feeding instructio=
ns :-)
>>
>> Here is what I currently do:
>>    - daily incremental and weekly full backups to a separate machine
>>    - run smartd tests (short once a day, long once a week)
>>    - check the raid for bad blocks every week
>>
>> What else can I do make sure the array keeps humming?  Thanks in advan=
ce!
>>    =20
Make sure the drives are adequately cooled. I use this nifty utility to
look at my drive temps:
http://martybugs.net/linux/hddtemp.cgi

mtbf seems to have an exponential dependence on temperature, so it pays
off to keep temp down. Exactly what temp you consider safe is
individual, but my drives only occasionally go above 40C.

cheers,

/Patrik



--------------enig54D0D7FCCBD6BE9A3FD4FA8C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFE/aw2T+KvsdUW5p8RAi6VAJ4mL/xigPH7i2mM9obOEnwrQG0wKACgkBxe
HvHiIzNyfJRbalAsbivVROY=
=bQPh
-----END PGP SIGNATURE-----

--------------enig54D0D7FCCBD6BE9A3FD4FA8C--
