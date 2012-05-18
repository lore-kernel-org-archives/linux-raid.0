From: Doug Ledford <dledford@redhat.com>
Subject: Re: [RFC PATCH 7/7] md: add bcache personality
Date: Fri, 18 May 2012 12:52:27 -0400
Message-ID: <4FB67E4B.6000204@redhat.com>
References: <20120511194327.25770.79292.stgit@dwillia2-linux.jf.intel.com> <20120511194647.25770.88687.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig7E15D72CCDBB6D154FBF0A8A"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120511194647.25770.88687.stgit@dwillia2-linux.jf.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: neilb@suse.de, koverstreet@google.com, linux-raid@vger.kernel.org, linux-bcache@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig7E15D72CCDBB6D154FBF0A8A
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 5/11/2012 3:46 PM, Dan Williams wrote:
> "Backing
> device" vs "cache device" is determined by slot number whereby the
> backing device slot is the highest number index.

That needs fixing.  We used to do things by slot number long ago, and it
turned out to create lots of races on reconfiguring slot indexes and
moving devices around on rebuilds and stuff like that.  I would have to
see us undo that fix when it comes to bcache.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: 0E572FDD
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enig7E15D72CCDBB6D154FBF0A8A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJPtn5MAAoJELgmozMOVy/dxjkQALl3s5c6M7Ik7TlItnU1yaxh
ai6UaFin012GMoDv86qtaGWNEMsR7+I7hEAdzxNFPuDsIEuAxgCSUe6V+FSe7hvs
Mso+POhohsNRYyZ0TVNz/bvw6WJz2uWdpRDntLP+yhejMuhcsZKWB5SPWAwAD7pa
GaKNeibbml1OO0XjLnLtxSLsZqmCbMz23jMGmFsPb86FeBMU/gOnNk+yuAywVIyA
p1/Lc7gvKERP9amHuqhNsWpRzajpfqv7Kjy7nlnFEAC9Y5jQnuoyhff/cEsLcTJm
ltFj8l4MYj/mLTHKbu5ZwNlU0/0G0RQuQW0s+ILrSjxtG0WmlvW3IWX7LKPvxRni
uj53ALhtNed1mO4Czr7C5PAlL/CVSmB+wNY/ZEiGXTAN23YbYSyOddj3YNZTNlEt
b+7pD/W8Atwxv0O5GVk0A2VaDbYzT1+7IorepfwpIhDkq52SQUMxMmeZt/DmAg3w
MBpA8mb/jqIZkHywUEM6iZOL9dNjPXWJMeyjc/iRR2M0sZsT/QlnG7OY1xdpEf9b
0WWlmKz5teqsd3dREhWaCb+2JLIE2t+uoAFNk2x1K6iycHW9lTZV8jRyDpQSJEHv
BGN/3IUB5OjE5ajqcukzXPoOi26Hof3ygn2wxgc6B4y3prcCv+Pd6geNT4jIVtyk
GbeIYtEMFF1OznL/CIM6
=tWrm
-----END PGP SIGNATURE-----

--------------enig7E15D72CCDBB6D154FBF0A8A--
