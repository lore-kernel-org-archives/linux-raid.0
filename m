From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PULL REQUEST] md and related patches for 2.6.38
Date: Wed, 23 Feb 2011 22:01:49 -0800
Message-ID: <AANLkTinm95OYw2Sj0DuABTiG6eWzePcfAZyxOE0c4GsT@mail.gmail.com>
References: <20110224165328.46c1169b@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110224165328.46c1169b@notabene.brown>
Sender: linux-kernel-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Andrew Patterson <andrew.patterson@hp.com>, Jens Axboe <axboe@kernel.dk>, Jeff Moyer <jmoyer@redhat.com>
List-Id: linux-raid.ids

On Wed, Feb 23, 2011 at 9:53 PM, NeilBrown <neilb@suse.de> wrote:
>
> =A0The most noteworthy is :
> =A0 =A0 =A0 Fix over-zealous flush_disk when changing device size.
>
> =A0which I include below in full.

Gah.

Why did you do that butt-ugly "__invalidate_device2()"?

There are something like three users of that existing
__invalidate_device() function, it would have made for a smaller and
cleaner patch to just fix them all, rather than change the calling
convention, create that ugly "2" function, and add the wrapper
function.

It's _doubly_ crazy, because that's exactly what you did to
"invalidate_inodes()", so it has this crazy mix of "change one
function" and "try to maintain another function unchanged".

Why?

                 Linus
