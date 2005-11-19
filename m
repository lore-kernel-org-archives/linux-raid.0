From: Farkas Levente <lfarkas@bppiac.hu>
Subject: Re: raid5 write performance
Date: Sat, 19 Nov 2005 12:59:48 +0100
Message-ID: <437F13B4.1070308@bppiac.hu>
References: <200511190440.jAJ4efw15919@www.watkins-home.com>	<437EB0A6.8040807@h3c.com> <17278.48635.585763.580503@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17278.48635.585763.580503@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:

> The other is to use a filesystem that allows the problem to be avoided
> by making sure that the only blocks that can be corrupted are dead
> blocks.
> This could be done with a copy-on-write filesystem that knows about the
> raid5 geometry, and only ever writes to a stripe when no other blocks
> on the stripe contain live data.
> I've been working on a filesystem which does just this, and hope to
> have it available in a year or two (it is a back-ground 'hobby'
> project). 

why are you waiting so long? why not just release the project plan, and 
any pre-pre-alpha code? that's the point of the cathedral and the 
bazaar. may be others can help, find bugs, write code, etc..

-- 
   Levente                               "Si vis pacem para bellum!"
