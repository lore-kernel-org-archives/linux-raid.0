From: NeilBrown <neilb@suse.de>
Subject: Re: On mdadm 3.2 and bad-block-log
Date: Mon, 16 Jul 2012 13:41:38 +1000
Message-ID: <20120716134138.0f1c9cfc@notabene.brown>
References: <4FD7738D.3040403@shiftmail.org>
	<CAGRgLy5Eryf_kT69a3SSPi8-MVpVmhEL96tNWJZQd9-vf4iYZQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_//9C89w2on5Ud4qtqzNgjFFT"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRgLy5Eryf_kT69a3SSPi8-MVpVmhEL96tNWJZQd9-vf4iYZQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Lyakas <alex.bolshoy@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, Asdo <asdo@shiftmail.org>
List-Id: linux-raid.ids

--Sig_//9C89w2on5Ud4qtqzNgjFFT
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 11 Jul 2012 12:40:57 +0300 Alexander Lyakas <alex.bolshoy@gmail.com>
wrote:

> Hi Neil,
> can you pls clarify whether the bad block management code in existing
> kernels is still considered experimental, and that's the reason there
> is no mdadm 3.3.x release yet?

Given that you are finding bugs in it - yes, it is still experimental :-)

The reason there is no 3.3.x release yet is that the amount of stuff that I
want to include in 3.3 has grown substantially and as the bad block code is
clearly still buggy, I probably don't want to rush it out :-)
I'm hoping for August or September for 3.3.  Probably September.

> If yes, which kernel do you recommend to experiment with this feature?

Always the latest.

> If no, should we then use the "devel-3.3" branch of mdadm, which was
> last updated ~1 year ago?

Yes. I'll be pulling that code into 'master' once I've finished some
code-cleanup that I want to do first.

Thanks,
NeilBrown



>=20
> Thanks,
> Alex.
>=20
>=20
>=20
> On Tue, Jun 12, 2012 at 7:51 PM, Asdo <asdo@shiftmail.org> wrote:
> > Hello
> > is it possible to keep mdadm 3.2 installed in the system (e.g. 3.2 as t=
he
> > monitoring daemon) and have an array with bad-block functionality (crea=
ted
> > with 3.3) running, or this will do a mess?
> >
> > Bad-block functionality is in mdadm-3.3 but this has not been released =
yet.
> > I was thinking about using it only once to create the array.
> >
> > However I am still missing the manual for mdadm-3.3, where is that? wit=
hout
> > that I don't know how I should launch it to create an array with bad bl=
ocks.
> >
> > Another question: are older kernels such as 3.0 capable to run an array
> > created with bad-block-log, obviously without using the bad-block-log
> > functionality? oh but that could be dangerous, couldn't it...
> >
> > Thank you
> > A.
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_//9C89w2on5Ud4qtqzNgjFFT
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUAONcjnsnt1WYoG5AQJmYBAAkz8Ofw0whpIeG6pQRXiRSNCbqycdQtN6
Ea3eBcA4lUazqNkWhdxzjMoo9EW8A+HSQnAD08DxiSDV4MPsB8RvbquqBu3qGgvz
3seo55a/1NEK/syEClSOCyJP10xUBa6H5Vy4A9Prcbym7klLKw1v2f9MFXlphK/Z
gFjLZEHjFrlECnVO1YxfmwMIyX9f5bkNVY7v1mT3TqaShf2Y/BoInBmlKZ+Uq7TL
Gf/H7xcSqtVd0MnuDm9cMUvZoZMvVrvsku61l6Sw4wqm4G9cpGNscEBybCfZo8mY
hF5vmGaRefLN4LXEBUbP8EbvPdbQtzoo6qsKFPTRz5b09v9L2aphT0J7qFRrpbYZ
/iLdR23kw/iDzXyICtJTHgqe/qa39/1oD6acu38BlgkHO/2zLaALTfdq6Kkn/EBg
ZIyzmjULgTXiL91yZyGIMgDNlSi6BK0j+Vy6Lg8b7kyD+ZnuMrOO/WxxiXDAqMSd
XPTJvJ9esG0YL62QuauI9BB1sN6PVH73JcteVTEQqqir8lBth7Ptc6GtAoIs8HIt
q6YIsIqCSdkGI4HIInezO1pzCWK/UW/xo92Razbji8yULur2ktbYmaBHar4+bIr6
XawFMyyAEorQo14FFZxFW+d95QaATRxcUofAsemGY2hoq8+4At//2kNOLMV3PtMy
VToMApo8zLQ=
=4iOs
-----END PGP SIGNATURE-----

--Sig_//9C89w2on5Ud4qtqzNgjFFT--
