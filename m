From: "George Spelvin" <linux@horizon.com>
Subject: Re: RAID6 syncing at 24 MB/s?
Date: 18 Apr 2012 01:22:35 -0400
Message-ID: <20120418052235.27608.qmail@science.horizon.com>
References: <20120418150502.41d6305d@notabene.brown>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120418150502.41d6305d@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux@horizon.com, neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> Can you try an experiment for me (if you don't have anything useful on the
> array yet)?
> 
> Stop the array.  Recreate it exactly the same way as before, and see if it
> goes faster.  I think it might - at least until it got up to where it was up
> to.

Um, unfortunately, I do (I didn't actually make the posting until after
the sync finished), but it should actually be non-destructive to do that
to an existing array, right?

It's just like deleting and re-creating a partition; as long as you're
*damn* sure you kept the parameters the same, it's a no-op.  Right?

I still have the data on the backup drives, so it's "only" a day's
lost work if I fry it (I did some reorganization as well as simple bulk
copying), so it's not *deadly* dangerous...

Thank you for the response!
