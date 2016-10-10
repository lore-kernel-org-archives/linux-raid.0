From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
Subject: Re: [PATCH 24/54] md/raid1: Improve another size determination in setup_conf()
Date: Mon, 10 Oct 2016 15:57:57 +0200
Message-ID: <87y41wqpay.fsf@miraculix.mork.no>
References: <566ABCD9.1060404@users.sourceforge.net>
        <786843ef-4b6f-eb04-7326-2f6f5b408826@users.sourceforge.net>
        <9831fce9-d689-89e4-dec8-50cadcd13fdd@users.sourceforge.net>
        <CAFLxGvx0Fr-WNvKYACdvNiZwYzHW4ocna9HPH8J_WPSXWc+ngg@mail.gmail.com>
        <20161010110050.GA5687@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161010110050.GA5687@mwanda> (Dan Carpenter's message of "Mon,
        10 Oct 2016 14:12:34 +0300")
Sender: linux-raid-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Richard Weinberger <richard.weinberger@gmail.com>, SF Markus Elfring <elfring@users.sourceforge.net>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Guoqing Jiang <gqjiang@suse.com>, Jens Axboe <axboe@fb.com>, Mike Christie <mchristi@redhat.com>, Neil Brown <neilb@suse.com>, Shaohua Li <shli@kernel.org>, Tomasz Majchrzak <tomasz.majchrzak@intel.com>, LKML <linux-kernel@vger.kernel.org>, "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-raid.ids

Dan Carpenter <dan.carpenter@oracle.com> writes:

> I am ignoring Markus patches and have told him that he should focus on
> bug fixes.  These patches don't add any value and regularly introduce
> bugs.

I think there should be a big fat warning in CodingStyle:

 THIS DOCUMENT DOES NOT APPLY TO ANY EXISTING KERNEL CODE.


Preserving existing style is more important than any minor style issue
anyway.  Style changes for the only purpose of style change should be
considered harmful and destructive behaviour. You'd think that is bloody
obvious, but evidently it isn't.  Not only are the untested, buggy,
churning patches still being submitted - some of them are even applied!

Adding such a statement will not prevent style changes, even changes
to bring code more in line with CodingStyle, as long as the patches are
part of some work of substance.  E.g. cleaning up before fixing bugs. If
you submit new code, then you can of course fix the style of any touched
context.

Oh well, I can dream..


Bj=C3=B8rn

