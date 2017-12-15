From: Phil Turmel <philip@turmel.org>
Subject: Re: Is there any lazy initialization mechanism in linux-raid?
Date: Fri, 15 Dec 2017 07:34:01 -0500
Message-ID: <698d56e7-8edb-fd85-1037-3a365002da02@turmel.org>
References: <46a50eb1-7836-9ec5-109a-59d223708547@bwstor.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <46a50eb1-7836-9ec5-109a-59d223708547@bwstor.com.cn>
Content-Language: en-GB
Sender: linux-raid-owner@vger.kernel.org
To: guomingyang <guomingyang@bwstor.com.cn>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Good morning,

On 12/15/2017 06:50 AM, guomingyang wrote:
> Hi all:
> 
>       Today's disk is becoming larger and larger, and the recovery time
> is becoming longer. I'm thinking about a lazy initialization mechanism
> in linux raid5 to speed up recovery, which contains an un-initializing
> bitmap and a backend thread for initializing stripes lazily only after a
> stripe is write. The major difference is as follows:
> 
>       (1)When a raid4 or raid5 device is created, we don't recovery a
> disk as usual, instead we just set all the bit in un-initialize bitmap.
> 
>       (2)When a write happens and the corresponding un-initializing bit
> is set, we must first clean the bit, then wake up the backend thread to
> resync the stripe, and only do RCW in corresponding stripe before the
> resync is done.

It is interesting, and opens further possibilities.  I'm not sure a
bitmap is the best data structure, but that's be an implementation detail.

>      The major advantage of this mechanism is that when a disk is
> replaced, we can only recovery the stripes which have been initialized,
> so as to speed up recovery.

There's a time penalty added on any operation on the disk to determine
whether the location is initialized or not.  What should reads do when
accessing uninitialized areas?

>      Does linux-raid have similar mechanism today? Or is there anyone
> who has already working on similar mechanism?

By itself I don't think its worth the effort.  However, the accounting
logic could also be used to support trim at the md layer, and the
reduction in actual I/O (supply zeroes when reading uninitialized) might
justify the performance impact of the logic.

I haven't seen any action on anything like this, so I would assume you'd
have to start with some patches.

Regards,

Phil
