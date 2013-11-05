From: Ivan Lezhnjov IV <ivan.lezhnjov.iv@gmail.com>
Subject: Re: mdadm: /dev/md0 has been started with 1 drive (out of 2).
Date: Tue, 5 Nov 2013 14:02:03 +0200
Message-ID: <5E756798-9940-4EA9-821A-2A49F92E0B03@gmail.com>
References: <C8EFEBC6-4B43-4B71-AA3F-7DC69480220D@gmail.com> <5278C2A6.7060005@websitemanagers.com.au> <E9509E1D-C8FB-4496-ADD5-C6ACBEFC4007@gmail.com> <5278D84C.4040600@websitemanagers.com.au>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5278D84C.4040600@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Nov 5, 2013, at 1:36 PM, Adam Goryachev <mailinglists@websitemanagers.com.au> wrote:

> The problem is if you ignore the different contents, for those small
> sections of disk (which are sections which were actually written to
> recently with live data) you will get different content depending on
> which disk you read, up until that section is re-written.

Sounds like we are assuming /dev/sdd1 in my situation has the newest data simply by virtue of being recognized as "fresh" by mdadm? Does this assumption represent the actual state of data in terms of that it is indeed the most recent version possible prior to array failure? Or is it more like this is the only option there is and it's better than nothing?

> The
> alternative is to force the array, then run a check, and then a repair.
> This will at least allow you to get consistent data regardless of which
> disk you read from, however, you won't determine whether it is the
> "newer" or "older" data (md will choose at random AFAIK).

What are these check and repair commands that you refer to when talking about forcing an array? Are they echo check|repair > /sys/block/mdX/md/sync_action ?

When you say force the array, does it translate to a different set of commands than what you showed in the very first reply? What would be those? I'm just curious to see how these things are done when managing the arrays, and examples help a lot!

Ivan