From: Matt <matt@lpbproductions.com>
Subject: Re: Raid chunksize...
Date: Wed, 28 May 2003 17:40:56 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200305281740.57652.matt@lpbproductions.com>
References: <200305280334.52979.matt@lpbproductions.com> <20030528225546.GD6785@zero>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20030528225546.GD6785@zero>
Content-Description: clearsigned data
Content-Disposition: inline
To: Tom Vier <tmv@comcast.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

what about using raidreconf , to reconfigure the array ?? 

Matt


On Wednesday 28 May 2003 03:55 pm, you wrote:
> On Wed, May 28, 2003 at 03:34:49AM -0700, Matt wrote:
> > raid-level              0
> > chunk-size              4
> >
> > Both drives are 80 gig .. so the total comes out to 160 gig w/ raid0 ..
> > Now is a chunksize of 4k to small (??), or is it optimal (??). Also I'am
> > curios is
>
> yes, i definetly think that's too small. try 16, 32, and 64. i'm using 32
> w/ reiserfs. the only way to really find the optimal size, is of course to
> try different sizes timing what you typically use the drives for.
>
> > there anyway to change the chunksize w/o lossing the raid array and the
> > contents inside that array ?
>
> nope.
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD4DBQE+1VcYleY/n9G/oZ8RAhV7AJ4spTMuOdqn/xItQdWy6ajlguOKnACYpTvN
7LZNH5e8qIX86xx3zGLuaA==
=CQ5j
-----END PGP SIGNATURE-----
