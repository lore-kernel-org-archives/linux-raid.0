From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: RAID5 spare change
Date: Thu, 11 Aug 2005 20:08:22 +1000
Message-ID: <17147.9110.577486.974589@cse.unsw.edu.au>
References: <20050811171720.10115.patches@notabene>
	<E1E37OV-0002jQ-5u@notabene.cse.unsw.edu.au>
	<010201c59e52$460d22a0$0400a8c0@LocalHost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from djani22@dynamicweb.hu on Thursday August 11
Sender: linux-raid-owner@vger.kernel.org
To: djani22@dynamicweb.hu
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday August 11, djani22@dynamicweb.hu wrote:
> 
> It is possible to mirror only one drive, and after it is synced, remove the
> old, or similar?
> 

That would be nice, wouldn't it.
It isn't possible yet.
When we get the bitmap intent logging working for raid5, it will be
possible to do it with just 2 small windows while the array is
degraded. 
Whether it will ever be possible to do it with no window, I don't
know.

NeilBrown
