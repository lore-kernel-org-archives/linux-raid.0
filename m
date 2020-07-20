From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 04/24] fs: move the putname from filename_create to the callers
Date: Mon, 20 Jul 2020 11:05:50 -0700
Message-ID: <CAHk-=wimKMPiGP6n_HQUJ1rQ_6cT6hZH5rjQa_nfAgjB1mug+A@mail.gmail.com>
References: <20200720155902.181712-1-hch@lst.de> <20200720155902.181712-5-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20200720155902.181712-5-hch@lst.de>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Jul 20, 2020 at 8:59 AM Christoph Hellwig <hch@lst.de> wrote:
>
> This allows reusing the struct filename for retries, and will also allow
> pushing the getname up the stack for a few places to allower for better
> handling of kernel space filenames.

I find this _very_ confusing.

Now the rule is that filename_create() does the putname() if it fails,
but not if it succeeds.

That's just all kinds of messed up.

It was already slightly confusing how "getname()" was paired with
"putname()", and how you didn't need to check for errors, but at least
it was easy to explain: "filename_create() will  check errors and use
the name we got".

That slightly confusing calling convention made the code much more
compact, and nobody involved needed to do error checks on the name
etc.

Now that "slightly confusing" convention has gone from "slightly" to
"outright", and the whole advantage of the interface has completely
gone away, because now you not only need to do the putname() in the
caller, you need to do it _conditionally_.

So please don't do this.

The other patches also all make it *really* hard to follow when
putname() is done - because depending on the context, you have to do
it when returning an error, or when an error was not returned.

I really think this is a huge mistake. Don't do it this way. NAK NAK NAK.

Please instead of making this all completely messy and completely
impossible to follow the rule about exactly who does "putname()" and
under what conditions, just leave the slight duplication in place.

Duplicating simple helper routines is *good*. Complex and
hard-to-understand and non-intuitive rules are *bad*.

You're adding badness.

                 Linus
