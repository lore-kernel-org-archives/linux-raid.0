From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10 crashing repeatedly and hard)
Date: Tue, 4 Jan 2005 18:46:28 +0100
Message-ID: <kc1ra2-amt.ln1@news.it.uc3m.es>
References: <0h5qa2-0qa.ln1@news.it.uc3m.es> <200501041642.j04GgD920166@www.watkins-home.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Guy <bugzilla@watkins-home.com> wrote:
> This may be a stupid question...  But it seems obvious to me!
> If you don't want your journal after a crash, why have a journal?

Journalled fs's have the property that their file systems are always
coherent (provided other corruption has not occurred).  This is often
advantageous in terms of providing you with the ability to at least
boot. The fs code is oranised so that everuthig is set up for a
metadata change, and then a single "final" atomic operation occurs that
finalizes the change.

It is THAT property that is desirable. It is not intrinsic to journalled
file systems, but in practice only journalled file systems have
implemented it.

In other words, what I'd like here is a journalled file system with a
zero size journal.

Peter

