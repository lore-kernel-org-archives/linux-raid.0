From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: RAID5 created by 8 disks works with xfs
Date: Mon, 02 Apr 2012 09:01:38 +0100
Message-ID: <4F795CE2.9050106@anonymous.org.uk>
References: <CACwgYDPQBNa7z7WcyUjV2Rx8Qf47r7eaRCowNKxjLBz+fYcfvQ@mail.gmail.com> <CADNH=7H_rgiY4fkB0SHo0yPhSBib7Gq-E_fu18yuJx=enn-eGg@mail.gmail.com> <4F776492.4070600@hardwarefreak.com> <CACwgYDOSrEYUps2VLpFSZ-irH7Mn_-BWrOYYDgXS=ULrmVuEPw@mail.gmail.com> <4F77D0B2.8000809@hardwarefreak.com> <CACwgYDMx6nQF-OwYj-BA+sZivUK=kmv2tPukgf5JGwA1vMTGrA@mail.gmail.com> <4F77EA55.6090004@hardwarefreak.com> <jl9ate$2me$1@dough.gmane.org> <4F784A06.1@anonymous.org.uk> <CA+res+QkLi7sxZrD-XOcbR47CeJ5gADf7P6pa1w1oMf8CKSB4g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+res+QkLi7sxZrD-XOcbR47CeJ5gADf7P6pa1w1oMf8CKSB4g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jack Wang <jack.wang.usish@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/04/2012 04:15, Jack Wang wrote:
> 2012/4/1 John Robinson <john.robinson@anonymous.org.uk
> <mailto:john.robinson@anonymous.org.uk>>
[...]
>     Now that you've suggested that, it occurs to me that for an
>     application like this, the OP might be better doing his multiple
>     slow streams to a spool folder on SSD, and copying over to the big
>     array of spinning rust when each stream completes. 200 streams of
>     500MB is 100GB of data, so a pair of slightly larger SSDs in RAID1
>     (or RAID10, to balance the reads coming off) would do nicely as a
>     spool area.
>
>     This might also be a good application for bcache, FlashCache or
>     whatever.
>
> Using bcache/flashcache is what I'm considering, does above
> configuration option still needed?

Using a pair of SSDs? I think if you're adding a cache to a redundant 
array, you ought to make the cache redundant too.

Using RAID10 to balance reads coming off the redundant pair of SSDs? 
That would depend on how bcache or flashcache is written; if it's 
single-threaded or does large copies from cache to the backing, then 
yes, you may see better performance or at least more balanced usage of 
the two SSDs, and surely won't see worse performance.

Cheers,

John.
