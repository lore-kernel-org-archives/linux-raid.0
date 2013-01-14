From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: [PATCH] imsm: Forbid spanning between multiple controllers.
Date: Mon, 14 Jan 2013 09:45:06 -0500
Message-ID: <50F419F2.9050809@ubuntu.com>
References: <20121109144636.2215.91684.stgit@localhost.localdomain> <50EF3961.5050306@ubuntu.com> <8565BDA60DEA9E4C91B1047AD1958FBE1DEC8F5B@IRSMSX104.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8565BDA60DEA9E4C91B1047AD1958FBE1DEC8F5B@IRSMSX104.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Tomczak, Marcin" <marcin.tomczak@intel.com>
Cc: "neilb@suse.de" <neilb@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Patelczyk, Maciej" <maciej.patelczyk@intel.com>, "Dorau, Lukasz" <lukasz.dorau@intel.com>
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 1/14/2013 8:02 AM, Tomczak, Marcin wrote:
> Hi. Yes, mdadm will refuse any commands, when you try to use disks
> attached to multiple controllers. Also mdadm supports IMSM metadata
> only if you have a machine with Intel OROM (and the patch "Forbid
> spanning" changes nothing about it).

Why is this?  One of the nice things about dmraid was that since it
really was just software raid, if your controller blew you could
recover your data by moving the drives to another machine and still
recognize them.  Why should mdadm care about the controller?

I suppose it is nice to warn people that they are trying to create an
array that the bios won't recognize, but mdadm should not refuse to
run an array just because some hardware that is completely unnecessary
is not found.


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJQ9BnyAAoJEJrBOlT6nu75tikH/jQAsx4waselA6rrKC8aFD7+
oG5pphTskS10iukkJGX8d+o/HiiMM66IuMqM3vRSNZO40P6arhAETE02jvNY9vFN
fI61AMpCv0FvBFv83RRmh19HkHLQEgiztcLRI7GeTNl5aOnC4wk8NY/Rqt022bhV
MGHickXUDNXtoWSXE3x03aXm9cwjIwfPbDrt3jOyrf9EqgZZW2j8uqY3PbH5Zcav
slKjFOaVt98nvLeDLpBJ6pR4vKq3Qax+pOPNdvlGG0GAqftH/iEYHsopmM4D4o5L
21cI1CRfmyaF8ro0ryZPJkQVe46Ya41Qb1wd9Y6pg5mfbqGiwbQvMHi7o53Mc70=
=NumJ
-----END PGP SIGNATURE-----
