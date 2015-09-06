From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL REQUEST] md updates for 4.3
Date: Sat, 5 Sep 2015 18:03:48 -0700
Message-ID: <CA+55aFwM2e9sTVtYjrnPjh5RsZafBXbJ5FFYkYi730ojOn+8-w@mail.gmail.com>
References: <87si6t6wc9.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87si6t6wc9.fsf@notabene.neil.brown.name>
Sender: linux-kernel-owner@vger.kernel.org
To: Neil Brown <neil@brown.name>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Goldwyn Rodrigues <rgoldwyn@suse.com>, Guoqing Jiang <gqjiang@suse.com>, Lidong Zhong <ldzhong@suse.com>, Sasha Levin <sasha.levin@oracle.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Markus Stockhausen <stockhausen@collogia.de>, Yi Zhang <yizhan@redhat.com>, Benjamin Randazzo <benjamin@randazzo.fr>
List-Id: linux-raid.ids

On Sat, Sep 5, 2015 at 2:37 AM, Neil Brown <neil@brown.name> wrote:
>
> Please pull these updates.  I've already merged with the 'block' tree
> to resolve a few simple conflicts.

So for the future, I actually prefer to see and handle the conflicts myself.

I really just prefer knowing what's going on, and merge conflicts are
an indication of cross-maintainer issues which are *exactly* the kinds
of things I want to be aware of.

However, in this case I was "ok, I've already done several other merge
resolutions with the wbole damn bio_endio error handling changes", so
I felt I was aware enough about how that ended up being a
cross-subsystem conflict, and just took your pre-merged version.

If you feel that the conflicts are particularly subtle, or just
generally worry about the merge, or just because you want to do some
merge-testing, what some people end up doing is to send me their
unmerged branch, and then send me a separate ".. and here's the merge
I did". I'll then do the merge myself anyway, but then after doing the
merge I'll switch to a temporary testing branch and re-do the  merge
with the pre-merged state just to verify. Generally the end result is
identical, but when it isn't, that's actually usually interesting
(sometimes it's just a ordering difference, but sometimes it's a merge
error - and so far I think most merge errors have come from
sub-maintainers, for the simple reason that they generally aren't as
used to merging as I am - so even if they know the code better, I
sometimes catch merge gotcha's better).

Thanks,
                          Linus
