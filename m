From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH v2 03/12] raid5-cache: add a new policy
Date: Fri, 09 Dec 2016 08:22:10 +1100
Message-ID: <87vauu15h9.fsf@notabene.neil.brown.name>
References: <20161205153113.7268-1-artur.paszkiewicz@intel.com> <20161205153113.7268-4-artur.paszkiewicz@intel.com> <87d1h44lcj.fsf@notabene.neil.brown.name> <ba67c43b-067e-c565-8c70-4bb5544392a3@intel.com> <87lgvr2uhk.fsf@notabene.neil.brown.name> <a2b7d2a9-4b49-6f11-bbc5-228f28c83389@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <a2b7d2a9-4b49-6f11-bbc5-228f28c83389@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Artur Paszkiewicz <artur.paszkiewicz@intel.com>, shli@kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 08 2016, Artur Paszkiewicz wrote:
>>=20
>> How about we call it "resync_policy" which describes how to cope with
>> unexpected shutdown.  Options include:
>>=20
>>  full     regenerate all redundancy info after a crash
>>  bitmap   only regenerate redundancy info indicated by bitmap
>>           (both these suseptible to write-hole on raid456)
>>  journal  raid456 only, though could theoretically be extended
>>           to raid1, raid10 : log transactions and replay after crash
>>  ppl      raid456 only: log partial-parity before writes.
>>=20
>> With external metadata, this must be set explicitly.  With internal
>> metadata, it is set best on flags etc.
>>=20
>> Thoughts?  I'm not really happy with "full", but I cannot think of a
>> better name.
>
> I'm OK with this approach. A corresponding option will also be needed in
> mdadm. But won't this name be a little misleading because this option is
> not just about unexpected shutdown (where resync applies), but also
> degraded array unexpected shutdown. So maybe something like
> "consistency_policy" and "resync" option instead of "full"?

"consistency_policy" and "resync" sounds good to me.  Thanks.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlhJzwMACgkQOeye3VZi
gbnxCA/9HQUEAhai9DaISQ1ZqvcsbpZbYNpd8tSnFLzX9vIJJAG0TdufEFL7aCfT
jXIgNxJN/zUQlPD9TEb/ahPlvg8sWTlWlmTkSWK95S2YroA2sQFLnZj0Fs1qzcsI
i+ULq2T7qETxsdmVyCxtOvB5VGaLpRl9XCEdBHSubBdyaC3iUhE3T1xuw0utm9An
mAnw+iTd7xOvOigkGPUuEFFyG4iA2BEdw23R2YSk6IB8TBOr4yUw5DHK5/ZGqAAC
6Ww8KkR2aRPind1c413yBI7c8Q2Kd9bWNFPlgeSyjgvy1APViHtAmqpNwDfjV0B7
80lRtzbDdIRAxSTek0C0XNmxkfY9Yl/hCDDa9iRb2uuK6xZXPNR/jDWgaYkXK0/G
u4pq41QIhHTSIEU33T4x8lBti1HOi2fBaoGucuuxTnckZ5+xNoN2QFHdPOIvskIk
MrbiBztxSlS7fHb7bGmVVe0HBp4wdMwGIVxsftRASkSGT67QPqR9CexHTyuZTZw0
Aq4HEggeVYB527eukMmlg8ZU7ba/PNsMH9qpHYt/qiaTut4JB2fLinYK4yF+2c7a
z2HRb4eL42CWq2lt6RO/Vrh/bROugtt7NQ3wZly4yvoTzKB5A6TdcWWJr4sMmEuk
fGVtJ9VwLHFH7aHyAyDNe5uNWlGlzKetKP1S4R6Jq5HfOCkyEo4=
=0j1t
-----END PGP SIGNATURE-----
--=-=-=--
