From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: the true behavior of mdadm's raid-1 with regard to vertical parity
 and silent error detection/scrubbing- confirmation or feature request
Date: Wed, 18 Aug 2010 11:45:33 +0400
Message-ID: <4C6B8F9D.50105@msgid.tls.msk.ru>
References: <4C6B59F6.5020001@silcon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C6B59F6.5020001@silcon.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Brett L. Trotter" <brett@silcon.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

18.08.2010 07:56, Brett L. Trotter wrote:
[]
> So- is there any built in parity that helps mdadm decide which copy to
> use when the copies disagree on a raid 1 mirror during a resync?

There's no.

> If not- is there a reason why not beyond the extra space overhead and
> read compute write overhead?

Well.  This sounds pretty much like old discussion about bad
blocks marking in md or filesystems or any other layer like this.
But nowadays - hopefully anyway - all drives are capable of doing
this internally, -- remapping bad blocks.  If a drive is not able
to remap a new bad block anymore, it's time to throw it away or
to RMA it, instead of trying to "cure" it in upper layers.

The same thing is with parity.  All modern drives, at least in
theory, has ways to ensure they either return whatever has been
written, or indicate error.  This is ECC codes, checksums, parity,
whatnot - things supposed to detect errors and sometimes correct
simple ones like bit flips.

I understand you've got real cases where such detection does not
works for some reason.  Well, bad block remapping didn't work in
the past too... ;)

It shouldn't be very difficult to implement checsumming and/or
simple ECC codes in md (storing the parity information within
extra blocks either at the end of underlying device or every,
say, 64th block or so - in order to not reduce sector size into
something like 511 bytes :).  The overhead shouldn't be large
either.  Together with implementing bad block remapping..  But
to me, the question is if there's a real reason/demand of doing
so.

From the other hand, following this theme one may say that whole
md subsystem is obsolete by hardware raid controllers...  :)

> This issue interests me more as I look into SSDs and having flash blocks
> wear out.

And it is even more important for SSDs to have such feature, and
as far as I understand, ths is what they actually have.  I might
be wrong, but...

/mjt
