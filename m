From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Unable to convert raid1 to raid5
Date: Sun, 7 Aug 2016 00:59:05 +0100
Message-ID: <57A679C9.3060204@youngman.org.uk>
References: <57A4F436.9080402@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <57A4F436.9080402@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 05/08/16 21:16, Wols Lists wrote:
> In my testing of xosview, I've been mucking about with a vm and raid.
> xosview is looking quite promising (I've got a few comments about it,
> but never mind).
> 
> BUT. In mucking about with raid 1, I increased my raid devices to three.
> I now just can NOT convert the array to raid 5! I've been mucking around
> with all sorts of things trying to get it to work, but finally two error
> messages make things clear.
> 
Following up to myself - suddenly thought "I know what's wrong". So I
stopped the array, and of course couldn't access it, it was no longer
there. So I assembled but didn't run it, and it worked fine.

Simples, once you realise what's wrong - you can ADD devices to a
running array, but you can't REMOVE them.

Cheers,
Wol

