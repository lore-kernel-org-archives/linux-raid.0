From: =?ISO-8859-1?Q?=F7=C9=D4=C1=CC=C9=CA?= <manushkinvv@desnol.ru>
Subject: Re: filesystems for large arrays
Date: Tue, 11 Feb 2003 12:47:10 +0300
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030211124710.76032750.manushkinvv@desnol.ru>
References: <200302110925.BAA08326@astra.scripps.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="pgp-sha1"; boundary="5qI_fz=.+B=GjS?D"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200302110925.BAA08326@astra.scripps.edu>
To: Andy Arvai <arvai@scripps.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--5qI_fz=.+B=GjS?D
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

As i know,

xfs designed for big files
it's good for multimedia...

reiserfs for small files and large dirs, saves a lot of space aggregating file tails (joins parts of files which are less then one block together).

ext3 -- classic... :-) but require more knowlegde about fs content, inodes...

Agri

On Tue, 11 Feb 2003 01:25:56 -0800 (PST)
Andy Arvai <arvai@scripps.edu> wrote:

> Hi,
> 
> Does anyone have comments about the various filesystems typically used
> with large (terabyte) arrays, regarding performance and reliability?
> 
> The three most common filesystems seem to be ext3, reiser and xfs. Ext3
> and reiser are part of the standard linux kernel (not sure about xfs),
> implying that they are fairly robust. I've been using reiser and
> haven't had any problems, but I've heard that when the filesystem gets
> full there may be problems and it's also optimized for many small files
> instead of larger files. Ext3 sounds like it is very robust (since it
> is based on ext2), although I've heard the performance is worse than
> reiser. I've heard some good things about xfs, but have never used it.
> 
> If anyone has any real-world experiences or benchmarks I would be
> interested.
> 
> Andy
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

--5qI_fz=.+B=GjS?D
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.7 (GNU/Linux)

iD8DBQE+SMamXLqYWeM+eNsRAs7BAKCudrLKIvCMMBIoLJPdssTJ5ZQ6QQCeOlOo
7rGNFrxyE7MoAzWgJHeE1o4=
=J8Bn
-----END PGP SIGNATURE-----

--5qI_fz=.+B=GjS?D--
