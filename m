From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: [PATCH 0/3] md bitmap-based asynchronous writes
Date: Tue, 22 Mar 2005 09:35:44 +0100
Message-ID: <0025h2-rvq.ln1@news.it.uc3m.es>
References: <422F7621.8090602@steeleye.com> <16949.5768.392061.95882@cse.unsw.edu.au> <4239EDCA.4030502@steeleye.com> <16958.19415.701152.371199@cse.unsw.edu.au> <423EF6F7.2040201@steeleye.com> <16959.17969.933940.657178@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown <neilb@cse.unsw.edu.au> wrote:
> However I want to do raid5 first.  I think it would be much easier
> because of the stripe cache.  Any 'stripe' with a bad read would be

There's the FR5 patch (fr5.sf.net) which adds a bitmap to raid5. It
doesn't do "robust read" for raid5, however.

> flagged, kept in the cache and just get processed a different way to
> other stripes.  For raid1, you need some extra data structure to keep
> track of which blocks have seen bad reads, so I would rather leave

One can simply count the untried disks using the "remaining" field,
which is otherwise unused on the read side.  The count will be accurate
unless one changes the number of disks _during_ the read retry, and then
the worst that can happen is that one misses out on trying to retry the
read from the new disk, which surely will not yet be up to date anyway.

Or one can always try to read "one more for luck".

> that until I have familiarity with other issues through raid5.

I would love to know of _any_ starting point you see to doing it in
raid5.  It was not clear to me how to.

Peter

