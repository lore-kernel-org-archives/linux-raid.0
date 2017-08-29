From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH 2/2] mdadm: save previous journal_clean when reload super
Date: Tue, 29 Aug 2017 10:49:54 +1000
Message-ID: <87val7gpu5.fsf@notabene.neil.brown.name>
References: <20170828222036.3278481-1-songliubraving@fb.com> <20170828222036.3278481-3-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170828222036.3278481-3-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Song Liu <songliubraving@fb.com>, shli@fb.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, jes.sorensen@gmail.com
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Mon, Aug 28 2017, Song Liu wrote:

> In Incremental.c:count_active(), max_events is tracked to show to
> which devices are up to date. If a device has events==max_events+1,
> getinfo_super() is called to reload the superblock from this
> device. getinfo_super1() blindly set journal_clean to 0, which is
> wrong. This patch fixes this issue by saving previous
> journal_clean before calling getinfo_super().
>
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>  Incremental.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/Incremental.c b/Incremental.c
> index 6cf2174..b17b37f 100644
> --- a/Incremental.c
> +++ b/Incremental.c
> @@ -747,13 +747,16 @@ static int count_active(struct supertype *st, struct mdinfo *sra,
>  				;
>  			else if (info.events == max_events+1) {
>  				int i;
> +				int journal_clean;
>  				max_events = info.events;
>  				for (i = 0; i < raid_disks; i++)
>  					if (avail[i])
>  						avail[i]--;
>  				avail[info.disk.raid_disk] = 2;
>  				best[info.disk.raid_disk] = devnum;
> +				journal_clean = bestinfo->journal_clean;
>  				st->ss->getinfo_super(st, bestinfo, NULL);
> +				bestinfo->journal_clean = journal_clean;
>  			} else { /* info.events much bigger */
>  				memset(avail, 0, raid_disks);
>  				max_events = info.events;


This is a hack to work around a symptom.  It is not a real fix.

I'm not sure what the real fix is.
Maybe when you find "raid_disk == MD_DISK_ROLE_JOURNAL" you set
"journal_events = info.events", then after the loop, if
"journal_events >= max_events-1", you set "bestinfo->journal_clean = 1",
or something like that.
But you need to make it obvious that the code is correct, and the above
code looks like a hack.

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlmkujMACgkQOeye3VZi
gbkCBQ/7BtzefsztgnpxPgRwsSwwpYqUzM4zIYNKvOwxlGuHEVPR5vyf+fRZiXg+
hxi2Zo+eGzlbY3Q0UPaU8NBthsbK4yuujAI8HXbXRjqazoyJzBP63iXEyULUUJzF
YsU11bBOMWOtZ54/CCT+uzv0yCcyDs97B+blstVuMyMcRjCBcOiTL3iWPVfoGpw9
p2w6Z2ahFyaijs2okoxoMyZgdxXZehd++vEQnxWAy3qlwssAot0buAjkObeMqId9
cPxxNNuH5WatpUAFXy1smC/CAFZyhov8zvFDkXEWK0aMVQNIH6KJog/9LIJi3hCU
81BUKdtjfEx9TMCkwMDQ4qpbBJeuXLy5azw7aMYEGwbQep1mD+xyA97DsVmEG9nm
tgOgJ6qzIOjNGspuVETW0PaSoMKR5D93Mxra4AWB9W0V7divzr1zoa2N0vkeeLK4
xm/byfQzrh6w82iJINbyyOBEWEZcIG9hR8i5Pb+pOAV05w7AXiJOHZso9sA2rwA3
WE/MfyeXw19xIvHZFqjpaQJsTJ02GPb4/SmkJamSdjSG0dxK922gtWTdTIT2v121
jft/E96VYKs/k4wvppQKz4oAq+IEdlWyGLEliY1k5BHRnI+k+Y8TI1vwFn8NtqhL
QgS0V+bKEPX0HXrmcxv57RY4/hZbhL9VSAFdeG9BcUkA3ybnJaU=
=iN2O
-----END PGP SIGNATURE-----
--=-=-=--
