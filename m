From: Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH md 3 of 4] Delete unplug timer before shutting down md
 array.
Date: Mon, 1 Nov 2004 20:57:35 -0800
Message-ID: <20041101205735.5fc68d69.akpm@osdl.org>
References: <20041102143440.12019.patches@notabene>
	<E1COpUP-000392-Hw@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <E1COpUP-000392-Hw@notabene.cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

NeilBrown <neilb@cse.unsw.edu.au> wrote:
>
> As the unplug timer can potentially fire at any time, and
>  and it access data that is released by the md ->stop function,
>  we need to del_timer_sync before releasing that data.

raid really shouldn't know about unplug_timer.

Is there some missing block level API?
