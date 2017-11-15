From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] MD update for 4.15-rc1
Date: Tue, 14 Nov 2017 16:14:44 -0800
Message-ID: <CA+55aFy5r9cz=28G8G6pjY5mfGFRdwKatPJJ+DULOUvEFsokGw@mail.gmail.com>
References: <20171114195651.zxo3hz3odpc2j24d@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20171114195651.zxo3hz3odpc2j24d@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, Mike Snitzer <snitzer@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

So I've pulled this, but have a question:

On Tue, Nov 14, 2017 at 11:56 AM, Shaohua Li <shli@kernel.org> wrote:
>
> Mike Snitzer (1):
>       md: rename some drivers/md/ files to have an "md-" prefix

is this really sensible? I know I absolutely hate what things like
this does to tab-completion, because everything now has the same
prefix.

And it's not like it adds any value - the "md" is already there in the
directory name.

So honestly, if this was code that I regularly looked at (it isn't),
I'd probably not be happy. As it is, I don't really care all that
much, just wanted to check.

Why is it "md-faulty,c", but "raid5.c", for example?

And if it's to try to separate the "dm-xyz" vs "md-xyz" ones, maybe
making this an actual directory structure rather than a prefix would
be better?

Just throwing this out.

              Linus
