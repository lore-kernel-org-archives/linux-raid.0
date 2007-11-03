From: Rik van Riel <riel@redhat.com>
Subject: Re: [RFC PATCH 2.6.23.1] md: add dm-raid1 read balancing
Date: Sat, 3 Nov 2007 10:29:39 -0400
Message-ID: <20071103102939.219c502d@bree.surriel.com>
References: <1194084522.1353.10.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1194084522.1353.10.camel@localhost>
Sender: linux-raid-owner@vger.kernel.org
To: konstantin.sharlaimov@gmail.com
Cc: linux-raid <linux-raid@vger.kernel.org>, "Ingo Molnar  <mingo@redhat.com>, Neil Brown" <neilb@suse.de>
List-Id: linux-raid.ids

On Sat, 03 Nov 2007 20:08:42 +1000
Konstantin Sharlaimov <konstantin.sharlaimov@gmail.com> wrote:

> This patch adds RAID1 read balancing to device mapper. A read
> operation that is close (in terms of sectors) to a previous read or
> write goes to the same mirror.
> 
> Signed-off-by: Konstantin Sharlaimov <konstantin.sharlaimov@gmail.com>
> ---
> Please give it a try, it works for me, yet my results might be
> system-specific. Any feedback (bug-reports, suggestions) will be
> greatly appreciated.

I like your approach.  I have no dm-raid1 array here to test with,
but I am curious what your results are :)

The code looks nice.

-- 
"Debugging is twice as hard as writing the code in the first place.
Therefore, if you write the code as cleverly as possible, you are,
by definition, not smart enough to debug it." - Brian W. Kernighan
