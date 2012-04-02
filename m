From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: RAID5 created by 8 disks works with xfs
Date: Mon, 02 Apr 2012 11:28:22 +0100
Message-ID: <4F797F46.10600@anonymous.org.uk>
References: <CACwgYDPQBNa7z7WcyUjV2Rx8Qf47r7eaRCowNKxjLBz+fYcfvQ@mail.gmail.com> <CADNH=7H_rgiY4fkB0SHo0yPhSBib7Gq-E_fu18yuJx=enn-eGg@mail.gmail.com> <4F776492.4070600@hardwarefreak.com> <CACwgYDOSrEYUps2VLpFSZ-irH7Mn_-BWrOYYDgXS=ULrmVuEPw@mail.gmail.com> <4F77D0B2.8000809@hardwarefreak.com> <CACwgYDMx6nQF-OwYj-BA+sZivUK=kmv2tPukgf5JGwA1vMTGrA@mail.gmail.com> <4F77EA55.6090004@hardwarefreak.com> <jl9ate$2me$1@dough.gmane.org> <4F784A06.1@anonymous.org.uk> <CA+res+QkLi7sxZrD-XOcbR47CeJ5gADf7P6pa1w1oMf8CKSB4g@mail.gmail.com> <4F795CE2.9050106@anonymous.org.uk> <CA+res+SSJ49cPubOdmXi6Z3jnE+4wzsh1MJehs78U82e3iDhaA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+res+SSJ49cPubOdmXi6Z3jnE+4wzsh1MJehs78U82e3iDhaA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jack Wang <jack.wang.usish@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/04/2012 11:01, Jack Wang wrote:
> 2012/4/2 John Robinson<john.robinson@anonymous.org.uk>
>> On 02/04/2012 04:15, Jack Wang wrote:
>>> 2012/4/1 John Robinson<john.robinson@anonymous.org.uk
>>> <mailto:john.robinson@anonymous.org.uk>>
>> [...]
>>>     This might also be a good application for bcache, FlashCache or
>>>     whatever.
>>>
>>> Using bcache/flashcache is what I'm considering, does above
>>> configuration option still needed?
[...]
> Thanks for reply , I mean using SSD as cache device, and raid5
> 16*7200rpm disks, is this works for streaming workload above?
>
> I know bcache is try to turn rand write to seqencial write, but most
> ssd is not good at RAND write as I know.

I don't know where you got that from; SSDs are absolutely brilliant at 
small random writes and reads, hundreds of times better than spinning 
hard discs. bcache and flashcache were written specifically to take 
advantage of SSDs' high I/Os per second for small (random) reads and writes.

I wouldn't touch RAID5 for anything other than 3 drives; I'd use RAID6 
or RAID60 for 4-plus where I didn't need the better small/random write 
performance of RAID10. I haven't actually used bcache or flashcache, 
which is why I introduced them with "might".

My fantasy configuration in your 16-drive chassis would be 2 6-drive 
RAID6s, striped together in RAID0, with an SSD cache over the top built 
from two SSDs in RAID10 (or if I was feeling really paranoid, 3 SSDs in 
RAID10,n3), with the remaining slot containing a hot spare for the RAID6s.

Cheers,

John.
