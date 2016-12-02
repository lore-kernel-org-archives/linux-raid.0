From: NeilBrown <neilb@suse.com>
Subject: Re: Feature request, resumable raid check action
Date: Fri, 02 Dec 2016 17:09:46 +1100
Message-ID: <87y3zy6evp.fsf@notabene.neil.brown.name>
References: <CAEtPA0Aosn6q0pJxsh69EpHQehiSsyeyVfJf98cDhu6kORkE1g@mail.gmail.com> <8737i76idm.fsf@notabene.neil.brown.name> <CAEtPA0C=xH0gCaigs-THNZRspmwD6d4WCrecjL-30M3PP0vxHw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAEtPA0C=xH0gCaigs-THNZRspmwD6d4WCrecjL-30M3PP0vxHw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Patrick Dung <mpatdung@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Fri, Dec 02 2016, Patrick Dung wrote:

> Thanks for reply, NeilBrown.
>
> In my testing:
> I had run the mdcheck script, then reboot.
> After rebooted, then I  run the mdcheck script again, it did not
> resume from where it stopped before reboot.
>
> Is there something that I may had missed?

Did you reboot while it was running, or after it had finished its
aloted time?
You need to let it finish and record where it got up to.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlhBECoACgkQOeye3VZi
gbnk2Q//byb1g6xlFx5agRG5GWCoFfTD2vHdrTTlJCByRP4JavuMCSCeJi3R2O7V
dboWR6rhXB0EhBDjpV/bplBdqN5aHnxStY5fbEYQD4+G7uE/wz4jHKN1bnWsEi9y
V3a90ONLn8WccaWgM7NWWhozEOI4gEcpCcgWF1mKmTJnE3sw/xkVovMZz8uBdDl7
cJ9i3APh+Mma+T315ereL2EZ7wGx5mNNQuQsr/jqLdFDIS6dJxtsGtZXdLu5orcj
XLdHlIEJn7kRrwUpLHdfmQDZGZ66j5kI23pxLG6JBMw5JTTtcfzAx0mkzW+HU0sr
uR+UzKMklVcRrAJOanWJ0UYOwtBAhvo8gTU0s5fXZ94/C6DM/+sB6oAljqabWHda
g6Fdw59vWfjfk+SxerUnlup1fA9JHdapG+TdQz1nVqANYsakTyt36X7xhMG8LoTK
2KbGDQN7YNd3MIKaiodod9VB+xMD3cQrwCRzNzszzrADUC29QQLC1D2kV5U4iU/n
f2xRM8OBVccjJIrY0XBHWetVnh0LEqQSFiLConNRl5MSX/4Pdt7+Wk78oPbz4A1I
lBgiOXdd2vh0pRo0YIcthtYyNKz1aKkvv/su2oY0EJVjvddtdoHiTtDZWfFpxtHP
wCt7geIvM3UqhkbwriFMjlX/aJ1EF5i7JTJlIifoU67z3/jN1Hc=
=T2g0
-----END PGP SIGNATURE-----
--=-=-=--
