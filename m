From: Neil Brown <neilb@suse.de>
Subject: Re: modifying degraded raid 1 then re-adding other members is bad
Date: Thu, 10 Aug 2006 09:18:24 +1000
Message-ID: <17626.27968.132243.825703@cse.unsw.edu.au>
References: <or8xlztvn8.fsf@redhat.com>
	<17624.29070.246605.213021@cse.unsw.edu.au>
	<44D8732C.2060207@tls.msk.ru>
	<17625.4242.910985.97868@cse.unsw.edu.au>
	<Pine.LNX.4.61.0608090834060.11585@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751425AbWHIXSg@vger.kernel.org>
In-Reply-To: message from Jan Engelhardt on Wednesday August 9
Sender: linux-kernel-owner@vger.kernel.org
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Michael Tokarev <mjt@tls.msk.ru>, Alexandre Oliva <aoliva@redhat.com>, linux-raid <linux-raid@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

On Wednesday August 9, jengelh@linux01.gwdg.de wrote:
> >> Why we're updating it BACKWARD in the first place?
> >
> >To avoid writing to spares when it isn't needed - some people want
> >their spare drives to go to sleep.
> 
> That sounds a little dangerous. What if it decrements below 0?

It cannot.
md  decrements the event count only on a dirty->clean transition, and
only if it had previously incremented the count on a clean->dirty
transition.  So it can never go below what it was when the array was
assembled.

NeilBrown
