From: NeilBrown <neilb@suse.de>
Subject: Re: raid1 repair: sync_request() aborts if one of the drives has
 bad block recorded
Date: Tue, 31 Jul 2012 12:11:41 +1000
Message-ID: <20120731121141.109cbfd6@notabene.brown>
References: <CAGRgLy6j3pEeXGXJbVc4Sz3gdShWWfaT7hyXnurgO-6N-_E_ZA@mail.gmail.com>
	<20120716133753.1a34e149@notabene.brown>
	<CAGRgLy6JZXiHFg11Z-_3krj8iKp_Wk7X_wz8OyikyvhLpxzcxg@mail.gmail.com>
	<20120717111753.178d53d5@notabene.brown>
	<CAGRgLy6jDTGXu1Yk2tCnHKDVTfCKjA2P6L-qgrD8EcPb8gCaBA@mail.gmail.com>
	<CAGRgLy5FXG9gFgq+QR_OknhNVtEMuSj6d-Hso5PYcjaD2rzXcQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/TCizFmTscuQB.Bi_63tzG7I"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRgLy5FXG9gFgq+QR_OknhNVtEMuSj6d-Hso5PYcjaD2rzXcQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Lyakas <alex.bolshoy@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/TCizFmTscuQB.Bi_63tzG7I
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 24 Jul 2012 22:30:33 +0300 Alexander Lyakas <alex.bolshoy@gmail.com>
wrote:

> Hi Neil,
> apparently you decided not to apply that patch?

No, worse than that.  I marked your email as 'needs attention'.  That appea=
rs
to be an almost-certain guarantee that I'll never look at it again - must be
a bug in my brain.  Apologies.

> On Tue, Jul 17, 2012 at 4:17 PM, Alexander Lyakas
> <alex.bolshoy@gmail.com> wrote:
> > Thanks for your comments, I got confused with the REQUESTED bit.
> > I prepared the patch, with couple of notes:
> >
> > 1/ I decided to be more careful and schedule a write only in case of
> > resync or repair. I was not sure whether we should try to correct bad
> > blocks on device X, when device Y is recovering. Pls change it if you
> > feel otherwise.

That looks sensible.  I've left it as it is.

> >
> > 2/ I tested and committed the patch on top of ubuntu-precise 3.2.0-25.
> > I looked at your "for-next" branch, and saw that there is some new
> > code, which handles hot-replace, which I am not familiar with at this
> > point.

It shouldn't make any important change to this patch.
For RAID1, hot-replace just means there can be twice as many devices as you
would expect.


> >
> > Final note: I noticed that badblocks_show() fails if there are too
> > many bad blocks. It returns value larger than PAGE_SIZE, and then the
> > following linux code complains:
> > fs/sysfs/file.c:fill_read_buffer()
> >         /*
> >          * The code works fine with PAGE_SIZE return but it's likely to
> >          * indicate truncated result or overflow in normal use cases.
> >          */
> >         if (count >=3D (ssize_t)PAGE_SIZE) {
> >                 print_symbol("fill_read_buffer: %s returned bad count\n=
",
> >                         (unsigned long)ops->show);
> >                 /* Try to struggle along */
> >                 count =3D PAGE_SIZE - 1;
> >         }
> >
> > So I am not sure how to solve it, but it would be good for
> > user/application to receive the full list of bad blocks. Perhaps
> > application can pass fd via some ioctl (I feel you don't like ioctls),
> > and then kernel can use vfs_write() to print all the bad blocks to the
> > fd. Or simply return the bad blocks list through the ioctl output to
> > mdadm, and mdadm would print them. Perhaps some other way.

It isn't possible to get a full list of bad blocks from sysfs, much as it is
not possible to read the write-intent-bitmap or other metadata.

The main purpose for the two bad-blocks files in sysfs is to allow a
user-space metadata manager (mdmon) to find out when the kernel discovers a
bad block, to record in the metadata, and then to acknowledge it.
It is always possible to read the first entry from
the unacknowledged_bad_blocks file, then acknowledge it and so remove it fr=
om
the list, and in that way you can get all unacknowledged bad blocks.
Acknowledged bad blocks will be listed in the metadata already.

Still... I should probably fix the code so that it never displays a partial
truncated number, but stops before PAGE_SIZE..


Thanks,
NeilBrown



--Sig_/TCizFmTscuQB.Bi_63tzG7I
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUBc+3Tnsnt1WYoG5AQL6CA//VgGDWmJPgmhUpYkgCSHeEv0xIYMMlWow
2Zj3cF7gk+G0K+NOT8FkBJogPpJfw8DD0Ta4mZx8M0nVtsemLXA1SrZOQO1MQLhL
/9dm5X6auY13fpMbf1MSRIPw8aiwjhY6IUPVXYn1s6h1klpTrT8gN/3MXAIhpfrJ
r+s21KqIzK8PHnu1I9w43q2jIgLgWQWQkSxX/+W9Xv6wTqlNG5zH/IntrcWAaM8s
wIb9Oa596sUIu6IdiBm04MTAv6oFwNRbN/AUjGV50hWV97IZZ4Tl0YoeQCmVuv1l
V2f7ubnmrlfMy7cVA/I945ElL/Je7w+VauRPtnK5iZ7ZyXnbNC8mzulh6wedmTmw
RdNX4xEaP7WTfxzDwBegUbc2xO4Vaq/bG9vCjGqdprLMt9bf4A/sc+o0SInZBN+B
U0meWToIOui701S5eyApIZtIgmF0DxG+ynPfTGE+4ksBztHgO90XXiTLYLxzJpZs
XbQejJcYucYyi+N/jyz3EUOK+BTviiIVmt7uHTTSl7UArBkrxvOg6jQegtKP3xgi
2+wxicSwQAG6ELyiz2rvRbyg+6F80X1XOKAnDXhh1zG5qWjS61bwImtPuD18kWN0
NbjtWsS0En9nzMMoYI1hcC3Ta5p/QKwrTUo/jYDTwPb9Ettex8KnzLNUHh27NDF4
3OtR8HZQgVw=
=zGsL
-----END PGP SIGNATURE-----

--Sig_/TCizFmTscuQB.Bi_63tzG7I--
