From: Neil Brown <neilb@suse.de>
Subject: Re: modifying degraded raid 1 then re-adding other members is bad
Date: Wed, 9 Aug 2006 08:33:24 +1000
Message-ID: <17625.4404.778981.728665@cse.unsw.edu.au>
References: <or8xlztvn8.fsf@redhat.com>
	<17624.29070.246605.213021@cse.unsw.edu.au>
	<44D8732C.2060207@tls.msk.ru>
	<m3fyg7m40e.fsf@defiant.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Krzysztof Halasa on Tuesday August 8
Sender: linux-raid-owner@vger.kernel.org
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Michael Tokarev <mjt@tls.msk.ru>, Alexandre Oliva <aoliva@redhat.com>, linux-raid <linux-raid@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

On Tuesday August 8, khc@pm.waw.pl wrote:
> Michael Tokarev <mjt@tls.msk.ru> writes:
> 
> > Why we're updating it BACKWARD in the first place?
> 
> Another scenario: 1 disk (of 2) is removed, another is added, RAID-1
> is rebuilt, then the disk added last is removed and replaced by
> the disk which was removed first. Would it trigger this problem?
> 

No.  The removing and the adding will all move the event count clearly
forward and the removed drive will have an old event count and so will
not be considered for easy inclusion.


> > Also, why, when we adding something to the array, the event counter is
> > checked -- should it resync regardless?
> 
> I think it's a full start, not a hot add. For hot add contents of
> the new disk should be ignored.

See my other post for why I want to sometimes not do a recovery on a
hot-add.

NeilBrown
