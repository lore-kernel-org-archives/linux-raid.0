From: Lars Ellenberg <lars.ellenberg@linbit.com>
Subject: Re: [RFC PATCHSET block#for-2.6.36-post] block: convert to
	REQ_FLUSH/FUA
Date: Tue, 24 Aug 2010 11:51:36 +0200
Message-ID: <20100824095136.GA28256@mail.linbit.com>
References: <1281977523-19335-1-git-send-email-tj@kernel.org> <20100823164709.GA31221@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100823164709.GA31221@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: philipp.reisner@linbit.com, Tejun Heo <tj@kernel.org>, jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Aug 23, 2010 at 06:47:09PM +0200, Christoph Hellwig wrote:
> Phillipp and Lars,
>=20
> can you look at the changes in
>=20
> 	http://www.spinics.net/lists/linux-fsdevel/msg35884.html
>=20
> and
>=20
> 	http://www.spinics.net/lists/linux-fsdevel/msg36001.html
>=20
> and see how drbd can be adapted to it?

Yes of course.
I have been closely following the discussion related to this patchset.

> It's one of two drivers still
> missing, and because it's not quite intuitive what it's doing it's
> very hard for Tejun and me to help.

I'm currently on vacation, actually, and Phil is likely very busy,
but we should have a patche ready within the next few days anyways.

--=20
: Lars Ellenberg
: LINBIT | Your Way to High Availability
: DRBD/HA support and consulting http://www.linbit.com

DRBD=AE and LINBIT=AE are registered trademarks of LINBIT, Austria.
