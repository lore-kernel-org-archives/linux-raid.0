From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH] md: don't use flush_signals in userspace processes
Date: Fri, 9 Jun 2017 00:27:28 -0300
Message-ID: <20170609032728.GA25899@khazad-dum.debian.net>
References: <alpine.LRH.2.02.1706071834250.22850@file01.intranet.prod.int.rdu2.redhat.com>
 <87h8zrart4.fsf@notabene.neil.brown.name>
 <alpine.LRH.2.02.1706081847150.3603@file01.intranet.prod.int.rdu2.redhat.com>
 <87shja9b7s.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87shja9b7s.fsf@notabene.neil.brown.name>
Sender: linux-kernel-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
List-Id: linux-raid.ids

On Fri, 09 Jun 2017, NeilBrown wrote:
> Or maybe it could be discarded - the md_check_recovery() thing.
> The idea was that if you alt-sysrq-K to kill all processes, md arrays
> would go into immediate-safe-mode where the metadata is marked clean
> immediately after writes finish, rather than waiting a few seconds.  The
> chance of having a clean array after shutdown is hopefully improved.
> 
> I've never actually used this though, and I doubt many people know about
> it.  And bitmaps make it fairly pointless.

Hmm, I have, although I had no idea this was why my arrays were getting
far less frazzled than expected...  It is really useful behavior, now
that I know it can do that.

If you can teach SysRq+S, and especially SysRq+U, to force all arrays
into safe-mode *after* they carried their current meanings
(sync/umount), that would be more useful though, and it would help a lot
of people to avoid dirty arrays without them even knowing why...

-- 
  Henrique Holschuh
