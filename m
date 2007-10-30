From: Neil Brown <neilb@suse.de>
Subject: Re: Implementing low level timeouts within MD
Date: Tue, 30 Oct 2007 15:47:43 +1100
Message-ID: <18214.46959.424946.683169@notabene.brown>
References: <1193418753.4771.17.camel@w100>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Alberto Alonso on Friday October 26
Sender: linux-raid-owner@vger.kernel.org
To: Alberto Alonso <alberto@ggsys.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday October 26, alberto@ggsys.net wrote:
> I've been asking on my other posts but haven't seen
> a direct reply to this question:
> 
> Can MD implement timeouts so that it detects problems when
> drivers don't come back?

No.
However it is possible that we will start sending the BIO_RW_FAILFAST
flag down on some or all requests.  That might make drivers fail more
promptly, which might be  good thing.  However it won't fix bugs in
drivers and - as has been said elsewhere on this thread - that is the
real problem.

NeilBrown

