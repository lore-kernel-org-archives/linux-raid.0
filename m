From: NeilBrown <neilb@suse.de>
Subject: Problems with bdev_write_page().
Date: Sun, 17 May 2015 17:02:00 +1000
Message-ID: <20150517170200.0d966434@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/=9GgOTUQl2ajXohVJw1zYeL"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Matthew Wilcox <matthew.r.wilcox@intel.com>, Charles Bertsch <cbertsch@cox.net>
Cc: linux-raid@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/=9GgOTUQl2ajXohVJw1zYeL
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable



Hi Matthew,
 I've just been looking at bdev_write_page().
You can read about why here:

  http://marc.info/?t=3D142984068300001&r=3D1&w=3D2

it ends with a "git bisect" which points the finger at you.

If I look at bdev_write_page() it says:

 * On entry, the page should be locked and not currently under writeback.
 * On exit, if the write started successfully, the page will be unlocked and
 * under writeback.  If the write failed already (eg the driver failed to
 * queue the page to the device), the page will still be locked.  If the
 * caller is a ->writepage implementation, it will need to unlock the page.

So the page is unlocked on success.

In __mpage_writepage() I find

			if (!bdev_write_page(bdev, blocks[0] << (blkbits - 9),
								page, wbc)) {
				clean_buffers(page, first_unmapped);


so if bdev_write_page() succeeds, i.e. if it returns '0', then
clean_buffers() is called.  At this point the page is unlocked remember.

clean_buffers may call

		try_to_free_buffers(page);

(without first locking the page, so still unlocked)..
try_to_free_buffers starts:

	BUG_ON(!PageLocked(page));


Opps.

Can you propose a fix for Charles, who can trigger this bug and nicely
bisected it for us - thanks Charles!!!

Also while looking at the code, I notice that brd_rw_page() unconditionally
calls page_endio() and, in the WRITE case, page_endio unconditionally calls
end_page_writeback(), which has

	if (!test_clear_page_writeback(page))
		BUG();


and so cannot tolerate being called twice in a row.
So if brd_rw_page() ever returned an error (which seems possible though not
likely), end_page_writeback() would be called once by page_endio() and once
in the error path of bdev_write_page(), and the BUG above would be triggere=
d.

I'll leave that for you to sort out too :-)

Thanks,
NeilBrown

--Sig_/=9GgOTUQl2ajXohVJw1zYeL
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVVg86Tnsnt1WYoG5AQJQhBAAlQ1y27P9YGaM/NaOSlDEUwp0FxuomZdv
TDjBbynnBKo4Chvzk5G0kkSFQOvgfD+1p4XsZ442nQ1hFQsFhKOzO4EvCVsWLluC
vgJKGt4R7Tl2lcUlWnyhWIX/fMR9a27H7kVRJDq7UngF+HBcvGgSYnNbs0HXdOoe
fwfY/nDZS7Ta3Ke+2ibcw/zgkSOqUIBE+JuM3mCzljvz09l/oBuWNabe7hZ8S4mC
7QdZoYuaBM52vCXDufnC9KI8YTItT8fmBuO1PvMqj10qBzqCPTnEBzpId5P9+fCP
qBrOubtqCjTeGgo7JTV7YLE4ByAGLGfTzy7ZvtpoelLc/6WQhmB8kH3aPF7c6ANT
PwZzeIttbXTOTlRBBthNL9pT8gpRe1MzxRlnvmZ3Lf3+uoHlsH6X3kuTDlnKbFL+
+A6uMeribSrsW2afA9PWh6zmV/tPNSVEcZAY/Q4vGjYvcSf+v/zk8QHEY1Xm+2yK
dNAr3dwYg0fOz4AWjLm0nCQh2V25z4khWJxYSOG5WCc/dwIQp+RjpPBXLLhgDKdg
WW3i7L6lVGT7ooscL+n+oPMHt45WnYd//oPdxVUq80RniS7IRa+KC4g26LGgl55J
Kj6qoIRzr2Ii0cCMSU6SRoyCmf5iGZGGFNKIWk1uUwbgiyKo3e1sTnhvvcrPwKpJ
ftSJQfESJaI=
=sa95
-----END PGP SIGNATURE-----

--Sig_/=9GgOTUQl2ajXohVJw1zYeL--
