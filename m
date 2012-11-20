From: NeilBrown <neilb@suse.de>
Subject: Re: Where can i download mdadm 3.3
Date: Tue, 20 Nov 2012 12:26:22 +1100
Message-ID: <20121120122622.34f9bacd@notabene.brown>
References: <CAGmni9ozPTrqeg+RLBu=J8NEqqK95nwf0ymK7qA7DgpZNRHX=A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/ZE_.HuBUZGCM2ZpuTej1uc2"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGmni9ozPTrqeg+RLBu=J8NEqqK95nwf0ymK7qA7DgpZNRHX=A@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Salatiel Filho <salatiel.filho@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/ZE_.HuBUZGCM2ZpuTej1uc2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 18 Nov 2012 10:42:22 -0300 Salatiel Filho <salatiel.filho@gmail.com>
wrote:

> Hi guys, i will be building a few arrays very soon and i'd like to
> test the badblock feature and the replaceable feature, but i haven`t
> found where i can download the source of mdadm 1.3. Where can i get it
> ?
>
You can't.  3.3 doesn't exist yet.

However
  git clone git://neil.brown.name/mdadm
  cd mdadm
  make

will get you code that supports bad blocks and replaceable devices.

Alternately you can get a tar file at

   http://git.neil.brown.name/git?p=3Dmdadm.git;a=3Dsnapshot;h=3Dmaster

NeilBrown

--Sig_/ZE_.HuBUZGCM2ZpuTej1uc2
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUKrcPjnsnt1WYoG5AQIZ+A/+I0+dxrG950DeVR81doJFOONGN7aBvzvs
OlHRTrf4PM09nmNbI9wdXoc1Y1N2WE87G3BOwfngP6Lqaqq2jrs01JxQVsX/dFJJ
hIKgyM1B2qq3g6RMzmnR+z6ZjejMqS2PHhY/SPi8nmIZcHkRvlQFi9GHR2EIFfs/
/oPIl9uPyiQ5mafw4o00MXzu4tzf0vts9ReST+eXRLnJyzTLLvXZUus4ptDH3Yqb
ojgKtfjwycuVaE7feBM2x8PyNTrsi+Abny1eR4g2DWxvfFD/lEwrYw6r4z9M+82d
AVn0EcvRdmWq5QgyyhnodkKKnvJ3ifpXmJbM4MH2/iGreHLbiU9jb5+nTcFIT5Fx
HItmtCKvBqIGUCz6HoEkC/gM3q15HtAiPR07wpwJ5U2SyyqdL0IavOEm6JFO2JTg
jArBq+LIjg+VV8Xx1+gwTBk0IBLUgt53uiYZj3GPKpLHHvdMAl3BFU9MSYz4FwxV
dyA1+D96YfOQvoahlquT0XFLVakJ8tUBKBbLrlR0yQyADY2GGhRhdUnPyWgsCbeW
3/Ud/rwEO4fmX3VVWiZp0ZhwILCaeSohVaUkO0UKuq2hU5cOaZZePyN1xYgDq+/I
TkdG6GufTuX7tyiKwU/+W3JGuIruoTuZQfmOhkpd8NOpGC/0iWDr32l+lEI+ikf4
5BZJQzqAeE8=
=BXgY
-----END PGP SIGNATURE-----

--Sig_/ZE_.HuBUZGCM2ZpuTej1uc2--
