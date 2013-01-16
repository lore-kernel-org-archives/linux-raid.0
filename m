From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: [PATCH] imsm: Forbid spanning between multiple controllers.
Date: Wed, 16 Jan 2013 09:26:18 -0500
Message-ID: <50F6B88A.5000102@ubuntu.com>
References: <20121109144636.2215.91684.stgit@localhost.localdomain> <50EF3961.5050306@ubuntu.com> <8565BDA60DEA9E4C91B1047AD1958FBE1DEC8F5B@IRSMSX104.ger.corp.intel.com> <50F419F2.9050809@ubuntu.com> <679865E03F4C71419D9847EA3AACB16316215258@IRSMSX102.ger.corp.intel.com> <50F56E52.1090302@ubuntu.com> <679865E03F4C71419D9847EA3AACB1631621D637@IRSMSX102.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <679865E03F4C71419D9847EA3AACB1631621D637@IRSMSX102.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Patelczyk, Maciej" <maciej.patelczyk@intel.com>
Cc: "Tomczak, Marcin" <marcin.tomczak@intel.com>, "neilb@suse.de" <neilb@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Dorau, Lukasz" <lukasz.dorau@intel.com>
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 1/16/2013 4:58 AM, Patelczyk, Maciej wrote:
> I agree. That is why you have IMSM_NO_PLATFORM flag. Just do: 
> $export IMSM_NO_PLATFORM=1 $mdadm ...

That should do, and a man page entry would be nice ;)

> Of course I agree in general. This is standard Unix way to do it. 
> I'm root and I take full responsibility. I think that
> IMSM_NO_PLATFORM should handle spanning too. I will discuss it
> internally.
> 
> Errr..., "I know what I'm doing, go ahead anyway" - well not quite
> so... Do you really know the target platform OROM's capabilities?
> Do you?

Maybe I do, maybe I don't, but as you said, I'm root and I take full
responsibility.  You did me a favor by warning me, now let me take the
safety off and if I shoot myself in the foot, so be it.


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJQ9riJAAoJEJrBOlT6nu75hVQH/0AJjr6yLe8Dts103npPSjPZ
D3N9TaloCiBVVsn9Txl7Ws4oOeV771by0PyK858jMNZR47tvlRDcR4x1xQPV7o3G
TtOFLLTl+3HDdXzUz9QTJA5xpggEt3AskKFz/FZCvbSFt9btqX7/MOPApY8K2ulY
vIsqBmGnw61RsgvzjXsWIqSqouzXFBb5pFOqKBpstUWWc1H2Ug0rJuTJjilLxtGy
rcxPuBgBZcn38bdRmzYB3qHhVPmz+k6bndCjQbmefgq9FS5J5jKFlA2J3Djt5LVy
LONGSKog1+y42X8f3mozpK47xSX1vdgU5ef3U5RANzWzC52yPST+XAxzBjj+z/s=
=FXt6
-----END PGP SIGNATURE-----
