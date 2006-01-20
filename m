From: ross@lug.udel.edu (Ross Vandegrift)
Subject: Re: [PATCH 000 of 5] md: Introduction
Date: Fri, 20 Jan 2006 12:29:32 -0500
Message-ID: <20060120172932.GC27141@lug.udel.edu>
References: <26A66BC731DAB741837AF6B2E29C1017D47EA0@xmb-hkg-413.apac.cisco.com> <Pine.LNX.4.61.0601181427090.19392@yvahk01.tjqt.qr> <17358.52476.290687.858954@cse.unsw.edu.au> <43D00FFA.1040401@cfl.rr.com> <17360.5011.975665.371008@cse.unsw.edu.au> <43D02033.4070008@cfl.rr.com> <17360.9233.215291.380922@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <17360.9233.215291.380922@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Phillip Susi <psusi@cfl.rr.com>, Jan Engelhardt <jengelh@linux01.gwdg.de>, "Lincoln Dale (ltd)" <ltd@cisco.com>, Michael Tokarev <mjt@tls.msk.ru>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, "Steinar H. Gunderson" <sgunderson@bigfoot.com>
List-Id: linux-raid.ids

On Fri, Jan 20, 2006 at 10:43:13AM +1100, Neil Brown wrote:
> dm and md are just two different interface styles to various bits of
> this.  Neither is clearly better than the other, partly because
> different people have different tastes.

Here's why it's great to have both: they have different toolkits.  I'm
really familiar with md's toolkit.  I can do most anything I need.
But I'll bet that I've never gotten a pvmove to finish sucessfully
because I am doing something wrong and I don't know it.

Becuase we're talking about data integrity, the toolkit issue alone
makes it worth keeping both code paths.  md does 90% of what I need,
so why should I spend the time to learn a new system that doesn't
offer any advantages?

[1] I'm intentionally neglecting the 4k stack issue

-- 
Ross Vandegrift
ross@lug.udel.edu

"The good Christian should beware of mathematicians, and all those who
make empty prophecies. The danger already exists that the mathematicians
have made a covenant with the devil to darken the spirit and to confine
man in the bonds of Hell."
	--St. Augustine, De Genesi ad Litteram, Book II, xviii, 37
