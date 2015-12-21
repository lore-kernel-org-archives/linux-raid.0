From: NeilBrown <nfbrown@novell.com>
Subject: Re: Stop resync operation
Date: Mon, 21 Dec 2015 15:22:58 +1100
Message-ID: <87mvt44ehp.fsf@notabene.neil.brown.name>
References: <CAF8SPVLYv4fq1Wf80RGHuiO0bLwCK7EU+yp3M3bBXk2_23Nf4Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAF8SPVLYv4fq1Wf80RGHuiO0bLwCK7EU+yp3M3bBXk2_23Nf4Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: d4lamar <d4lamar@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Fri, Nov 06 2015, d4lamar wrote:

> Dear Developers,
>
> I have a question for you.
>
> I have a raid10 md array:
>
> Is it theoretically possible to stop a running resync operation and
> mark the array as clean without stopping the array ?


Firstly stop the resync with:

  echo frozen > /sys/block/mdXXX/md/sync_action

Then mark the resync as complete with
  echo none > /sys/block/mdXXX/md/resync_start

then re-enable sync with

  echo idle > /sys/block/mdXXX/md/sync_action

But maybe 6 weeks was too long to wait for a reply :-(

NeilBrown

>
> I do not want the resync to be respawned automatically.
>
> Thanks and Best Regards,
> d4lamar
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWd36iAAoJEDnsnt1WYoG5f80QAIMMiDpmpNTBtkqZdkYeUdb1
HzVcfMOGgBYWxhHQo5ProUJmURaME8vdK9xyjQvaNIY0H5TNdwErovIFKvsyjqon
VDK17Fi4kFENJ1ZB4sSZz8N4GCJ1fHNuBueeZAq10VAkENXSPujnWaIcX36T5LOj
8N3Dz4yCCSpTxJc0WdNM6/LiK37wf4R48Bv7Z+3N+5se9+wbWmEFrsK67mmPlnnf
WWfvQHX70hAkfpbF7R3F/+j7MBe0kjGFbRD2eHgvlu7kqaf4UUQXp43ImsIf332I
di7YLt7Eq+zMRN9w2ZgDIH9ptidLxCzd+NSLQuFHJti5BipIlNeQ+hNE7p6zio3a
OdPEOAbCRRCOZx7sRAtJucPctdxdgudLOOHq/IiSIdrkLOM2Npk3eEkk6lPPuWd1
9Q2Bjl14O4IVbEF80HITBKysBXgS7lgl8L9PkdGXWJ67VkbCrxJv4xpqYv7ocoD1
7I8KebHB/IJp3fazhNw2QydtYmjX9QTghYol7JmGpix6QQzKQAs68ggq/c0Ha9d6
Ocb4P/ZBJ8CWDyMzXPAOIvkbzySrGI25E+UWhlmVqkhUS2IMxBp/A31Xn+lg0QsI
NPve6f0FloaMEO+49x8QBNIvdOvMls6nLn1+A+9lu3up1Gjk6V+XOCtnS0+M8XwX
KcCLwwstUbbZYLxlQty1
=Azuh
-----END PGP SIGNATURE-----
--=-=-=--
