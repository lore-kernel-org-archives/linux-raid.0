From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10 crashing repeatedly and hard)
Date: Tue, 4 Jan 2005 11:42:07 -0500
Message-ID: <200501041642.j04GgD920166@www.watkins-home.com>
References: <0h5qa2-0qa.ln1@news.it.uc3m.es>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <0h5qa2-0qa.ln1@news.it.uc3m.es>
Sender: linux-raid-owner@vger.kernel.org
To: "'Peter T. Breuer'" <ptb@lab.it.uc3m.es>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This may be a stupid question...  But it seems obvious to me!
If you don't want your journal after a crash, why have a journal?

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Peter T. Breuer
Sent: Tuesday, January 04, 2005 4:51 AM
To: linux-raid@vger.kernel.org
Subject: Re: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10
crashing repeatedly and hard)

Neil Brown <neilb@cse.unsw.edu.au> wrote:
> On Tuesday January 4, andy@strugglers.net wrote:
> > Except that Peter says that the ext3 journals should be on separate
> > non-mirrored devices and the reason this is not mentioned in any
> > documentation (md / ext3) is that everyone sees it as obvious.
> > Whether it is true or not it's clear to me that it's not obvious to
> > everyone.
> 
> If Peter says that, then Peter is WRONG.

But Peter does NOT say that.

> ext3 journals are much safer on mirrored devices than on non-mirrored

That's irrelevant - you don't care what's in the journal, because if
your system crashes before committal you WANT the data in the journal
to be lost, rolled back, whatever, and you don't want your machine to
have acked the write until it actually has gone to disk.

Or at least that's what *I* want. But then everyone has different
wants and needs. What is obvious, however, are the issues involved.

Peter

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

