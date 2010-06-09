From: MRK <mrk@shiftmail.org>
Subject: Re: It is possible to put write cache on ssd?
Date: Wed, 09 Jun 2010 13:06:32 +0200
Message-ID: <4C0F75B8.7020306@shiftmail.org>
References: <loom.20100604T102522-67@post.gmane.org> <4C0D44FC.8020908@tmr.com>
 <loom.20100608T092726-796@post.gmane.org>
 <AANLkTikfDks6aTLal8dJLXhMlGxHtMtZ-L_r0r8IQQ4U@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <AANLkTikfDks6aTLal8dJLXhMlGxHtMtZ-L_r0r8IQQ4U@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: CoolCold <coolthecold@gmail.com>
Cc: Mario <mgiammarco@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 06/08/2010 02:23 PM, CoolCold wrote:
> May be something like
> http://github.com/facebook/flashcache/blob/master/doc/flashcache-doc.txt
> will be interesting for you.

There is another one: bcache

http://lkml.indiana.edu/hypermail//linux/kernel/1004.0/01051.html
http://lkml.org/lkml/2010/4/23/376

seems beta stage but nearing completion.
I have not yet investigated all the differences to flashcache. At first 
sight, bcache seems to cache reads, flashcache seems to cache writes.

But be warned that if you use a flash disk as a cache for a big RAID I 
believe it's gonna wear out very quickly.

Consider e.g. bcache caches reads, so on every cache miss it reads 
through the RAID and writes to the flash. If you have indexing programs 
that scrub the whole array (which is clearly larger than the SSD) they 
are going to transform all reads to writes to the flash disk. This is 
going to burn it quickly. I am not sure an SSD is a good medium for 
caching purposes. Try to buy RAM for this.

OTOH caching writes has another big problem:
http://www.legitreviews.com/news/7225/
read the grey box:
There is written that, due to the internal workings of SSDs, without a 
supercapacitor it is not possible to guarantee data integrity upon power 
loss. This is true EVEN if you are running it with cache off (so I 
suppose it is true even if you are using cache flushes or barriers).
Do you really want to lose data upon power loss? Caching writes on an 
SSD is risky...
At least bcache caches only reads, this should be safe I think.

Using a SSD for filesystem journal when the filesystem is on a HDD I 
suppose would not yield big improvements because the bottleneck will 
always be the HDD writes, which won't stay much behind journal commits. 
At most you are going to get the speed you have without a journal (like 
ext2).

Same problem with write-mostly/write-behind I think. I don't know how 
long is the queue that holds data already committed to the SSD and not 
yet committed to the HDD but it can't be too long. I'm reading the "man 
md" right now and it's not extremely clear on this. I have the 
impression the queue between the two it's either the 
/sys/block/hdddevice/queue/nr_requests or it uses the write-intent 
bitmap (if set). In case of the nr_requests, it's gonna be very short so 
the SSD can give you quick bursts but continuous performance will be 
that of the HDD. In case of write-intent bitmap, the delay between the 
two can probably be unbounded, but be warned that if the HDD is even 
just a bit behind the SSD, it's like not having the RAID: if the SSD 
fails, you lose data (might be a lot of data; will also probably need fsck).

What do you think?
