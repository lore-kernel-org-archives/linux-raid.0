From: Krzysztof Halasa <khc@pm.waw.pl>
Subject: Re: modifying degraded raid 1 then re-adding other members is bad
Date: Tue, 08 Aug 2006 21:17:05 +0200
Message-ID: <m3fyg7m40e.fsf@defiant.localdomain>
References: <or8xlztvn8.fsf@redhat.com>
	<17624.29070.246605.213021@cse.unsw.edu.au>
	<44D8732C.2060207@tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <44D8732C.2060207@tls.msk.ru> (Michael Tokarev's message of "Tue, 08 Aug 2006 15:19:08 +0400")
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Neil Brown <neilb@suse.de>, Alexandre Oliva <aoliva@redhat.com>, linux-raid <linux-raid@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

Michael Tokarev <mjt@tls.msk.ru> writes:

> Why we're updating it BACKWARD in the first place?

Another scenario: 1 disk (of 2) is removed, another is added, RAID-1
is rebuilt, then the disk added last is removed and replaced by
the disk which was removed first. Would it trigger this problem?

> Also, why, when we adding something to the array, the event counter is
> checked -- should it resync regardless?

I think it's a full start, not a hot add. For hot add contents of
the new disk should be ignored.
-- 
Krzysztof Halasa
