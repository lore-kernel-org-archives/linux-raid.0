From: "John Robinson" <john.robinson@anonymous.org.uk>
Subject: Re: Subject: Raid0 Reshape . Preface
Date: Wed, 17 Jun 2009 13:17:19 +0100 (BST)
Message-ID: <51950.194.105.184.77.1245241039.squirrel@www.yuiop.co.uk>
References: <1245189072.3478.92.camel@raz>
    <19000.55700.831349.967378@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <19000.55700.831349.967378@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, June 17, 2009 12:55 pm, Neil Brown wrote:
>  The more I think about it, the more I feel I would prefer to use the
>  raid5 module for all restriping.

That doesn't make sense to me, for various reasons including those for
having separate RAID personality modules in the first place. On the other
hand, if you're keeping the raid0 module simple, perhaps the raid5 module
could also be simplified and all objectives could be served by shipping
out all restriping to a new, separate restriping module? Or even to
userspace?

Cheers,

John.

