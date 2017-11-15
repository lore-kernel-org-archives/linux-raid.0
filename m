From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [GIT PULL] MD update for 4.15-rc1
Date: Tue, 14 Nov 2017 20:14:26 -0500
Message-ID: <20171115011426.GA3179@redhat.com>
References: <20171114195651.zxo3hz3odpc2j24d@kernel.org>
 <CA+55aFy5r9cz=28G8G6pjY5mfGFRdwKatPJJ+DULOUvEFsokGw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFy5r9cz=28G8G6pjY5mfGFRdwKatPJJ+DULOUvEFsokGw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Shaohua Li <shli@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Nov 14 2017 at  7:14pm -0500,
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> So I've pulled this, but have a question:
> 
> On Tue, Nov 14, 2017 at 11:56 AM, Shaohua Li <shli@kernel.org> wrote:
> >
> > Mike Snitzer (1):
> >       md: rename some drivers/md/ files to have an "md-" prefix
> 
> is this really sensible? I know I absolutely hate what things like
> this does to tab-completion, because everything now has the same
> prefix.
> 
> And it's not like it adds any value - the "md" is already there in the
> directory name.
> 
> So honestly, if this was code that I regularly looked at (it isn't),
> I'd probably not be happy. As it is, I don't really care all that
> much, just wanted to check.
> 
> Why is it "md-faulty,c", but "raid5.c", for example?
> 
> And if it's to try to separate the "dm-xyz" vs "md-xyz" ones, maybe
> making this an actual directory structure rather than a prefix would
> be better?
> 
> Just throwing this out.

I see you already took the change; but regardless the idea of splitting
MD and DM files into separate directories was explored briefly (by me).
I stopped short of that because dm-raid.c does share code with md (see
all the md includes at the top of dm-raid.c).

Would require more extensive work to formalize the MD interfaces through
include/linux/ which wasn't a priority to tackle.  I was just after
stopping the various janitor DM patch submissions from spamming
linux-raid and shli.  So went with the quickest way to express discrete
MD and DM files within the MAINTAINERS file.

Mike

