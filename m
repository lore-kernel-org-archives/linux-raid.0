From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: [RFC] using mempools for raid5-cache
Date: Wed, 9 Dec 2015 13:51:54 +0000
Message-ID: <566831FA.7030503@youngman.org.uk>
References: <1449072638-15409-1-git-send-email-hch@lst.de>
 <876108qwz5.fsf@notabene.neil.brown.name>
 <20151209012812.GA2403138@devbig084.prn1.facebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20151209012812.GA2403138@devbig084.prn1.facebook.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>, NeilBrown <neilb@suse.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 09/12/15 01:28, Shaohua Li wrote:
> It does remove the scary __GFP_NOFAIL, but the approach is essentially
> idential to a 'retry after allocation failure'. Why not just let the mm
> (with __GFP_NOFAIL) to do the retry then?

Because that's almost as dangerous?

Forgive me if I'm talking out of my hat, but I remember an article on
lwn reasonably recently about kernel memory allocation, and it was
something to do with small allocations never failing and the actual
behaviour being COMPLETELY different to what most users THINK is happening.

(iirc, the actual behaviour was NOFAIL, whether it was requested or not,
so if you think that adding NOFAIL to your code is going to help, you
may be in for a nasty shock.)

Whatever, if the disk code is prone to deadlocks, and it's calling
memory code which is prone to deadlocks, then better safe than sorry...

Cheers,
Wol
