From: NeilBrown <neilb@suse.de>
Subject: Re: Can extremely high load cause disks to be kicked?
Date: Mon, 4 Jun 2012 14:13:12 +1000
Message-ID: <20120604141312.175ec480@notabene.brown>
References: <20120531083158.GE3867@bitfolk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/w09upRI1lt+=sxGTKqFsmAv"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120531083158.GE3867@bitfolk.com>
Sender: linux-raid-owner@vger.kernel.org
To: Andy Smith <andy@strugglers.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/w09upRI1lt+=sxGTKqFsmAv
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 31 May 2012 08:31:58 +0000 Andy Smith <andy@strugglers.net> wrote:


> Now, is this sort of behaviour expected when under incredible load?
> Or is it indicative of a bug somewhere in kernel, mpt driver, or
> even flaky SAS controller/disks?

This sort of high load would not affect md, except to slow it down.
My guess is that the real bug is in the mpt driver, but as I know nothing
about the mpt driver, you should treat that guess with a few kilos of NaCl.

>=20
> Root cause of failure aside, could I have made recovery easier? Was
> there a better way than --create --assume-clean?

The mis-step was to try to add the devices back to the array.  A newer
mdadm would refuse to let you do this because of the destructive effect.

The correct step would have been to stop the array and re-assemble it,
with --force.

Once you had turned the devices to spares with --add, --create --assume-cle=
an
was the correct fix.


>=20
> If I had done a --create with sdc5 (the device that stayed in the
> array) and the other device with the closest event count, plus two
> "missing", could I have expected less corruption when on 'repair'?

Possibly.  You certainly wouldn't expect more.

NeilBrown


--Sig_/w09upRI1lt+=sxGTKqFsmAv
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT8w12Dnsnt1WYoG5AQJmKBAAxDGn/Gq+lyFzI9sqp5Ar6/HsTTwyaLrC
MtIYYRq3SMlDnD1EpbT0OjP0J02KitKwRim1gctALrZgw8fFQWsudT+vIeheFrtQ
p6apf2alNitF0OWS1ZDdPtC0MY6IH8d+3jLjn0pCPjIZnesKk5ZDqmx11IvLsTKf
UJ068t6B5gEEKtMZrpttyYs80CgiwUzrZj/uxm8L45j96gU/QzPkH/ILyrCaLxeQ
7wT1MUc/nPZE/sLM1ZTVWONkQeUXJJnPXr+YN4CmPziiimh7wYPn1v+rKwDUbUk1
67NstIcqwWTGS4nAUan7myg/pv1wkiNpcU+JzBmoSIiOwUn3wjK7eAMrL9CH3zgX
N5SPGRqva5PiE/ujC7cPdmoKVdBQAikO6tEj2b1lUEw9dkcIbQOzj2xx4ekCzdgY
FdSh46LLxcwN2nRjxUCSzW1lTKIMvef+iPvuiZGGVZab0d3FiMblcBwshNyjyywe
AlDezidPR0bjYmSwIutIZkEeQEc3JlBQ0Nwo/I21LDzeUxzjqYqfNvbVQfHA2ZU4
eyxw0ktYxOwHISBQsS2koHHmniME/jQ5D1jb63BaWhyzcPkq8bHl8Ok04zqyId67
Ixwe+MA0HULrItnWSHrGd2OYk/hXaFRegGCCn4n12DgMSIJrp5woAsGknYwN/QJw
zRYyZ+UvJ+w=
=chOl
-----END PGP SIGNATURE-----

--Sig_/w09upRI1lt+=sxGTKqFsmAv--
