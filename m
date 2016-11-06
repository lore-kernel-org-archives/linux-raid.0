From: NeilBrown <neilb@suse.com>
Subject: Re: [md PATCH 4/4] md/bitmap: Don't write bitmap while earlier writes might be in-flight
Date: Mon, 07 Nov 2016 09:53:42 +1100
Message-ID: <87r36onrt5.fsf@notabene.neil.brown.name>
References: <147823807607.6764.8460942745584467311.stgit@noble> <147823836359.6764.7855525110697020696.stgit@noble> <20161105003325.qnmcu363ocbli74x@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161105003325.qnmcu363ocbli74x@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Sat, Nov 05 2016, Shaohua Li wrote:

> On Fri, Nov 04, 2016 at 04:46:03PM +1100, Neil Brown wrote:
>> As we don't wait for writes to complete in bitmap_daemon_work, they
>> could still be in-flight when bitmap_unplug writes again.  Or when
>> bitmap_daemon_work tries to write again.
>> This can be confusing and could risk the wrong data being written last.
>
> Applied the first 3 patches, thanks!
>
> This one seems not completely solving the race condition. It's still possible
> bitmap_daemon_work clears BITMAP_PAGE_NEEDWRITE but hasn't dispatch the IO yet,
> bitmap_unplug then does nothing and thinks bitmap is updated to disk. Why don't
> we add locking here?

Thanks for the review!

BITMAP_PAGE_NEEDWRITE is set for pages that need to be written out in
order to clear bits that don't need to be set any more.  There is never
any urgency to do this.
BITMAP_PAGE_DIRTY is set of pages that need to be written out in order
to set bits representing regions that are about to be written to.  These
have to be flushed by bitmap_unplug().
Pages can have both bits set, in which case bitmap_daemon_work() will
leave them for bitmap_unplug() to deal with.

So if bitmap_daemon_work() clears BITMAP_PAGE_PENDING on a page, then it
is a page that bitmap_unplug() doesn't need to wait for.


Does that answer your concerns?

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJYH7R2AAoJEDnsnt1WYoG56NQP/iUbemlGcTia7pt/7LZviUax
Uj4QZNXW9QTFFJdhs+QWwsX7tUpRWZvQ1hZ0xOLQI7psYp4QiWuLqz0BIS3DIkS8
/rKIf4Uf0xi432jFGSPBpM0obY035iymlclVSgrgmPSlKlHt/me/s0BzDTz85GeO
pEPcdKLIBl2mCeQNmq25Xz8/MUFKaifLopd/wv6JOab/GBRowhg7vaozP7OtCJyX
kNPkshvn+QKq2uEJFo7SC6XnOo+bq1Cv9bFjz92mvL7pOOznfGZqw1Z/9SnnyD1x
RXh+AvfMib2Ejv3vOWv0yDCYr5ceqAO23ECM/N1yvSDzzbhRwAAd9gfS+h0wTVKI
TyNkk8VF8+UQpsKFdnCcCeEQXe7je+fHqW045JtXzQ0owxbF7LdLDKoe9iqWddcd
TWTBjlk8E2sel7rf6APPlLQXJYUT/hVTHIivGH/9zBeVSPOViq2l56UdP5tnbygl
+lc7i8/VuVGrFMXnMKNsx+HEV1FTrjH8ZXHWQZ6W/nojgqWC47aBX3TIqs2vbVnG
C25Y63O+HL7Ol4H/TCUOGFkAErvfF3xTOpj/ASyPvfywjtKaE/LuvLDzK5ZEkTUS
isqva6PVEkiKD2BWbTncZAE4n6PnHgweINAGu5V8LrRsYFrNWtiX3OPCEVmZ7shq
R/2LoBCCUiBc9XxY7ML0
=3UgV
-----END PGP SIGNATURE-----
--=-=-=--
