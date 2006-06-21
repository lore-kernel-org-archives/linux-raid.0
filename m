From: Paul Clements <paul.clements@steeleye.com>
Subject: Re: bitmap status question
Date: Wed, 21 Jun 2006 15:39:35 -0400
Message-ID: <4499A077.4050802@steeleye.com>
References: <44997EFB.8080308@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <44997EFB.8080308@dgreaves.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

David Greaves wrote:
> How do I interpret:
>       bitmap: 0/117 pages [0KB], 1024KB chunk
> in the mdstat output
> 
> what does it mean when it's, eg: 23/117

This refers to the in-memory bitmap (basically a cache of what's in the 
on-disk bitmap -- it allows bitmap operations to be more efficient).

If it's 23/117 that means there are 23 of 117 pages allocated in the 
in-memory bitmap. The pages are allocated on demand, and get freed when 
they're empty (all zeroes). The in-memory bitmap uses 16 bits for each 
bitmap chunk to count all ongoing writes to the chunk, so it's actually 
up to 16 times larger than the on-disk bitmap.

--
Paul
