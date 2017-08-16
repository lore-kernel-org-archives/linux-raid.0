From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: [PATCH V2 8/9] nullb: emulate cache
Date: Wed, 16 Aug 2017 18:00:10 +0100
Message-ID: <59947A1A.6040602@youngman.org.uk>
References: <cover.1502746933.git.shli@fb.com>
 <727aaf4b878c064945b15c2b6e2d5fad487a3b54.1502746933.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <727aaf4b878c064945b15c2b6e2d5fad487a3b54.1502746933.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, linux-block@vger.kernel.org, linux-raid@vger.kernel.org
Cc: kernel-team@fb.com, Kyungchan Koh <kyungchan.koh@gmail.com>, Shaohua Li <shli@fb.com>
List-Id: linux-raid.ids

On 14/08/17 23:04, Shaohua Li wrote:
> From: Shaohua Li <shli@fb.com>
> 
> Software must flush disk cache to guarantee data safety. To check if
> software correctly does disk cache flush, we must know the behavior of
> disk. But physical disk behavior is uncontrollable. Even software
> doesn't do the flush, the disk probably does the flush. This patch tries
> to emulate a cache in the test disk.
> 
> All write will go to a cache first, when the cache is full, we then
> flush some data to disk storage. A flush request will flush all data of
> the cache to disk storage. A FUA write will write to memory store
> directly and revalidate data in cache. If there is a power failure (by
> writing to power attribute, 'echo 0 > disk_name/power'), we discard all
> data in the cache, but preserve the data in disk storage. Later we can
> power on the disk again as usual (write 1 to 'power' attribute), then we
> can check data integrity and very if software does everything correctly.
> 
> A new attritue 'cache_size' (in MB) is added to configure cache size.

c/attritue/attribute/

Cheers,
Wol
