From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: PROBLEM: Kernel 2.6.10 crashing repeatedly and hard
Date: Thu, 30 Dec 2004 22:50:55 +0300
Message-ID: <41D45C1F.5030307@tls.msk.ru>
References: <m3is6k4oeu.fsf@reason.gnu-hamburg> <m38y7fn4ay.fsf@reason.gnu-hamburg> <v3rda2-hjn.ln1@news.it.uc3m.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <v3rda2-hjn.ln1@news.it.uc3m.es>
Sender: linux-raid-owner@vger.kernel.org
To: "Peter T. Breuer" <ptb@lab.it.uc3m.es>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, dm-crypt@saout.de
List-Id: linux-raid.ids

Peter T. Breuer wrote:
> In gmane.linux.raid Georg C. F. Greve <greve@fsfeurope.org> wrote:
> 
> Yes, well, don't put the journal on the raid partition. Put it
> elsewhere (anyway, journalling and raid do not mix, as write ordering
> is not - deliberately - preserved in raid, as far as I can tell).

This is a sort of a nonsense, really.  Both claims, it seems.
I can't say for sure whenever write ordering is preserved by
raid -- it should, and if it isn't, it's a bug and should be
fixed.  Nothing else is wrong with placing journal into raid
(the same as the filesystem in question).  Suggesting to remove
journal just isn't fair: the journal is here for a reason.
And, finally, the kernel should not crash.  If something like
this is unsupported, it should refuse to do so, instead of
crashing randomly.

/mjt
