From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10 crashing repeatedly and hard)
Date: Wed, 5 Jan 2005 09:29:10 +1100
Message-ID: <16859.6326.605501.431357@cse.unsw.edu.au>
References: <l1nna2-e9i.ln1@news.it.uc3m.es>
	<20050104024108.GK99565@caffreys.strugglers.net>
	<895qa2-0qa.ln1@news.it.uc3m.es>
	<200501042002.32292.maarten@ultratux.net>
	<j6dra2-9vs.ln1@news.it.uc3m.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Peter T. Breuer on Tuesday January 4
Sender: linux-raid-owner@vger.kernel.org
To: "Peter T. Breuer" <ptb@lab.it.uc3m.es>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday January 4, ptb@lab.it.uc3m.es wrote:
> Bits flip on our client disks all the time :(.  

You seem to be alone in reporting this.  I certainly have never
experienced anything quite like what you seem to be reporting.

Certainly there are reports of flipped bits in memory.  If you have
non-ecc memory, then this is a real risk and when it happens you
replace the memory.  Usually it happens with a sufficiently high
frequency that the computer is effectively unusable.

But bits being flipped on disk, without the drive reporting an error,
and without the filesystem very quickly becoming unusable, is (except
for your report) unheard of.

md/raid would definitely not help that sort of situation at all.

NeilBrown
