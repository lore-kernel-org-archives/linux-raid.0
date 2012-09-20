From: Kasper Sandberg <kontakt@sandberg-consult.dk>
Subject: Re: raid6 low performance 8x3tb drives in singledegraded mode(=7x3tb)
Date: Thu, 20 Sep 2012 02:26:41 +0200
Message-ID: <505A62C1.4050706@sandberg-consult.dk>
References: <504FD153.9090602@sandberg-consult.dk> <20120919162557.03df6af2@notabene.brown> <20120919134030.222e4b04@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120919134030.222e4b04@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 19/09/12 09:40, Roman Mamedov wrote:
> On Wed, 19 Sep 2012 16:25:57 +1000
> NeilBrown <neilb@suse.de> wrote:
>
>> RAID5/RAID6 write speed is never going to be brilliant, but there probably is
>> room for improvement.  Hopefully one day I figure out how to effect that
>> improvement.
> "/sys/block/md*/md/stripe_cache_size" is absolutely the first thing one should
> look at when facing a problem with md RAID5/6 write performance. It is
> understandable that the default value can't be high (as it consumes a lot of
> RAM on large disk counts), but increasing it if you have the RAM can increase
> the write speed by 200 to 400%:
>
>   http://peterkieser.com/2009/11/29/raid-mdraid-stripe_cache_size-vs-write-transfer/
>

Thank you for your answer.

I did try this, it had zero effect.

And Neil, thank you for your answer too,

I have now put the disks into the other box, and resynced with the 8th
disk, and things are fast now. How fast i cannot exactly say, as the
filesystem is put on top of dm-crypt, which caps me at about 100MB/s on
this cpu, but that would seem to indicate that things are functioning as
they should.


-- 
Kasper Sandberg
Sandberg Enterprises
+45 51944242
http://www.sandbergenterprises.dk

