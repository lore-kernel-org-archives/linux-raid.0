From: Gordon Henderson <gordon@drogon.net>
Subject: Re: raid6 rebuild
Date: Thu, 5 Apr 2007 07:03:08 +0100 (BST)
Message-ID: <Pine.LNX.4.64.0704050701310.20368@lion.drogon.net>
References: <20070404194638.GB3712@xi.wantstofly.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070404194638.GB3712@xi.wantstofly.org>
Sender: linux-raid-owner@vger.kernel.org
To: Lennert Buytenhek <buytenh@wantstofly.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 4 Apr 2007, Lennert Buytenhek wrote:

> (please CC on replies, not subscribed to linux-raid@)
>
> Hi!
>
> While my RAID6 array was rebuilding after one disk had failed (which
> I replaced), a second disk failed[*], and this caused the rebuild
> process to start over from the beginning.
>
> Why would the rebuild need to start over from the beginning in this
> case?  Why couldn't it just continue from where it was?

I can't answer your question, just make the comment: Hurrah for RAID-6!

I presume the restarted rebuild went OK?

> [*] probably an entirely defective batch of 14 Samsung Spinpoint 500G disks

Lets hope not... Keep checking those SMART values...

Gordon
