From: Florent Rougon <florent.rougon@free.fr>
Subject: Re: 3 questions...
Date: 30 Sep 2002 21:09:34 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <87fzvrwaz5.fsf@florent.hn.org>
References: <C65F89D1AC0BB54B865127151A24DA780BAD5C7B@nbexchm2.aliant.icn>
	<3D977753.4010401@tls.msk.ru> <87k7l4zb8j.fsf@florent.hn.org>
	<3D978975.2010903@tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3D978975.2010903@tls.msk.ru>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Michael Tokarev <mjt@tls.msk.ru> wrote:

> Hmm, it's always a good idea to have a backup handy, just in
> case, right? ;)

Oh, yes.

> Kernel code does not care about partition table _at all_ while
> disk is in use - kernel reads partition table when disk usage
> goes from 0 to 1, and keeps that table in memory after that, so

[...]

> table (an area that isn't used for anything else)).  So, answer
> to both your question is yes, but see my first statement (in

[...]

Thank you very much for this detailed answer.

-- 
Florent
