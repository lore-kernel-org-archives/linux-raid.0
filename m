From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] md: make suspend range wait timed out
Date: Wed, 21 Jun 2017 10:09:08 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1706211007560.29243@file01.intranet.prod.int.rdu2.redhat.com>
References: <d95473d287e196a86a83390cb9c136913643bd61.1497037210.git.shli@fb.com> <877f0c7gvr.fsf@notabene.neil.brown.name> <20170616155204.myffyxp5tuoctcoo@kernel.org> <87vant3rw5.fsf@notabene.neil.brown.name> <20170620005443.hil23ffizavctgkq@kernel.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170620005443.hil23ffizavctgkq@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: NeilBrown <neilb@suse.com>, linux-raid@vger.kernel.org, Shaohua Li <shli@fb.com>
List-Id: linux-raid.ids



On Mon, 19 Jun 2017, Shaohua Li wrote:

> > Write errors only get back to the application if it calls fsync(), and
> > many don't do that.  Write errors can easily cause a filesystem to go
> > read-only, and require an fsck.  I think we should be very cautious
> > about triggering write errors.
> > 
> > NFS will hang indefinitely rather then return an error if the server is
> > not available.  That can certainly be annoying, but the alternative has
> > been tried, and it leads to random data corruption.
> > The two cases are only comparable at a very high level, but I think
> > this result should encourage substantial caution.
> 
> It's hard to say if an IO error or an infinite wait is better, but since there
> is better option in this case, I don't want to argue. I'll repost a patch to
> reset suspend range after a timeout, assume this is your suggestion.
> 
> Thanks,
> Shaohua

Automatically resetting the suspend range could result in data corruption, 
so it is even worse than a deadlock.

Mikulas
