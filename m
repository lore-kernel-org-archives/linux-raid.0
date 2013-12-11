From: NeilBrown <neilb@suse.de>
Subject: Re: Rebuild events while scrubbing - problems or just
 informational?
Date: Wed, 11 Dec 2013 12:38:26 +1100
Message-ID: <20131211123826.0942ea22@notabene.brown>
References: <CAK2H+ed3vEJVF8To8FWD_Ltj7jGKgrBAvz-Aum4viR=VZE+gww@mail.gmail.com>
	<20131210085225.GA441@cthulhu.home.robinhill.me.uk>
	<52A7476A.9060307@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/mwA__qf9IZWdocOcPSsdLN3"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52A7476A.9060307@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Can Jeuleers <can.jeuleers@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/mwA__qf9IZWdocOcPSsdLN3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 10 Dec 2013 17:55:06 +0100 Can Jeuleers <can.jeuleers@gmail.com>
wrote:

> On 12/10/2013 09:52 AM, Robin Hill wrote:
> >> Dec  8 14:30:01 c2RAID6 mdadm[1838]: RebuildStarted event detected on
> >> md device /dev/md/3
> >> Dec  8 15:03:21 c2RAID6 mdadm[1838]: Rebuild26 event detected on md
> >> device /dev/md/3
> >> Dec  8 15:36:41 c2RAID6 mdadm[1838]: Rebuild49 event detected on md
> >> device /dev/md/3
> >> Dec  8 16:10:01 c2RAID6 mdadm[1838]: Rebuild70 event detected on md
> >> device /dev/md/3
> >> Dec  8 16:43:21 c2RAID6 mdadm[1838]: Rebuild87 event detected on md
> >> device /dev/md/3
> >>
> >=20
> > They're perfectly normal if you're doing a repair - I don't think they
> > should be there for a check though. It's just mdadm in monitor mode
> > reporting the progress (the numbers are the percentage completed) to
> > syslog.  According to the manual the default reporting interval is 20
> > percent, but I think it actually triggers on a completed stripe (or
> > block of stripes) so the numbers aren't exactly on the interval.
>=20
> I see them as well during checks. Although I can't find documentation
> stating so I regard them as normal.
> --

% man mdadm

Search for "RebuildStarted"

           RebuildStarted
                  An  md array started reconstruction. (syslog priority: Wa=
rn-
                  ing)


           RebuildNN
                  Where NN is a two-digit number (ie. 05, 48). This  indica=
tes
                  that  rebuild has passed that many percent of the total. =
The
                  events are generated with fixed increment since 0. Increm=
ent
                  size  may be specified with a commandline option (default=
 is
                  20). (syslog priority: Warning)



This is in a section which starts

MONITOR MODE
       Usage: mdadm --monitor options... devices...


       This usage causes mdadm to periodically poll a number of md arrays  =
and
       to report on any events noticed.  mdadm will never exit once it deci=
des
       that there are arrays to be checked, so it should normally  be  run =
 in
       the background.


I guess that doesn't explicitly say it is normal, but that is the intent :-)

They should be generated from recovery, resync, reshape, check, repair and
anything else that might be added which processes the whole array like that.
I guess "Rebuild" isn't a very generic word.. but
   "StuffStarted"
   "Stuff20"
   "StuffFinished"
probably wouldn't go down well either.


Thanks,
NeilBrown


--Sig_/mwA__qf9IZWdocOcPSsdLN3
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUqfCEjnsnt1WYoG5AQITpg/9Eh+WD/koYxkUJFp8H5mEfEqEsdRXuEnc
K4J2CxPnRpUSkLmTcMpDDhhiLiQI6l1xaVXOBhyB0xjK+ymQZgmWXhkY+hVMN871
8w81L0DNrrQ2XPFKO1KsOr5q+Wz7l9uGYd4FZer8D5eGzXmJYhFRoqJoyOG3D84W
HwIDszZd41QUW2Xwsov9m74CqbcQt0YTunkIOdrb0Xk7qU0Cg50PvZGkHlRX2DNp
2ePfBrTplK7F2DPHo+X2+y19MLrFs9nvqF2eQOQ99NB4+HH+ELo0EqbtKkj+aNBs
PYIXjU+M73u99gOdvP7UtptatD2pMNjhHHUQlIFekT2a0m3z0wHPtEBu3JHiyoT2
qClVwKE5m1ICk/gnTO8Qxg4mJxJN2xk64ZNJojSBJXBc78bx5GWh/gak7olPoo8K
6pM2IBYq+NkxDrA8pJ7UW0S2GquBt69/A9j3uj27ZmOf8AHg2wGXKVyUb/h9bu3v
EunOZeGptBeNJKqoqQMMJGopuGP5YibvlSd9W0NdJx2XhMdUxsX2ubf+ONzHjyN2
cnsz1Wb2Y6NlzgZRpmwSfYWVm9iCjfCrMuRhSVke2VtRX9cgspEJvco8pWZJ8Hmx
8vwaFxkCEWRM89bxUnIVJgnvOtMrL+dPXbq0FxEtkAC+odH/JCu9n1CXQNLcFFlW
23MssUrs/C8=
=6YGn
-----END PGP SIGNATURE-----

--Sig_/mwA__qf9IZWdocOcPSsdLN3--
