From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: PROBLEM: Kernel 2.6.10 crashing repeatedly and hard
Date: Thu, 30 Dec 2004 18:39:43 +0100
Message-ID: <v3rda2-hjn.ln1@news.it.uc3m.es>
References: <m3is6k4oeu.fsf@reason.gnu-hamburg> <m38y7fn4ay.fsf@reason.gnu-hamburg>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, dm-crypt@saout.de
List-Id: linux-raid.ids

In gmane.linux.raid Georg C. F. Greve <greve@fsfeurope.org> wrote:
> The message I saw on the remote console when it crashed with pure ext3
> on raid5 was:
> 
>  Assertion failure in journal_start() at fs/jbd/transaction.c:271: "handle->h_transaction->t_journal == journal"
> 

Yes, well, don't put the journal on the raid partition. Put it
elsewhere (anyway, journalling and raid do not mix, as write ordering
is not - deliberately - preserved in raid, as far as I can tell).

Peter

