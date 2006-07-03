From: David Greaves <david@dgreaves.com>
Subject: Re: [PATCH] enable auto=yes by default when using udev
Date: Mon, 03 Jul 2006 11:56:10 +0100
Message-ID: <44A8F7CA.3020909@dgreaves.com>
References: <20060702224549.GD12733@percy.comedia.it> <17576.21342.685662.432117@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17576.21342.685662.432117@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Luca Berra <bluca@comedia.it>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Neil Brown wrote:
> I guess I could test for both, but then udev might change
> again.... I'd really like a more robust check.
> 
> Maybe I could test if /dev was a mount point?

IIRC you can have diskless machines with a shared root and nfs mounted
static /dev/

David

-- 
