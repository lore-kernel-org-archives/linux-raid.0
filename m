From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: resync performance drop in RAID 5
Date: Fri, 28 May 2004 11:35:32 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16566.38756.925340.819674@cse.unsw.edu.au>
References: <1085684100.19703.33.camel@w-jlilienk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Joel Lilienkamp on  May 27
To: Joel Lilienkamp <joellilienkamp@alum.mit.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On  May 27, joellilienkamp@alum.mit.edu wrote:
> We are observing a strange performance drop on resync, using the
> md/raid5 support in Linux 2.4.20.  It is observable on at least two
> different disk controllers, so it doesn't appear to be a specific
> hardware limitation.
> 
> To reproduce:
> 
> 
>     Create a RAID5 device, /dev/md5, from four partitions, chunk-size
>     256k.
>     
>     Observe resync performance via 'cat /proc/mdstat'.  We are seeing
>     around 30MB/Sec on one controller, and 50+MB/sec on another.
>     
>     Do a small read from the device, such as 'dd if=/dev/md5
>     of=/dev/null bs=1024 count=1'
>     
>     Re-observe resync performance via 'cat /proc/mdstat'.  We are seeing
>     it drop by 60%+, to 12MB/Sec on one controller, and 15MB/sec on the
>     other.

You will probably also see a message in the kernel logs like:
             raid5: switching cache buffer size, 4096 --> 1024

The raid5 stripe cache must match the request size used by any client.
It is PAGE_SIZE at start up, but changes whenever is sees a request of
a difference size.
Reading from /dev/mdX uses a request size of 1K.
Most filesystems use a request size of 4k.

So, when you do the 'dd', the cache size changes and you get a small
performance drop because of this.
If you make a filesystem on the array and then mount it, it will
probably switch back to 4k requests and resync should speed up.

NeilBrown


> 
> The performance never recovers to its higher level, short of a reboot or
> of reconstructing the device.  I do not observe similar issues with
> RAID1, though I have not worked that as thoroughly.
> 
> 
> I have scoured the various lists and postings to find anything about
> this, but haven't located anything.  As always, any help is greatly
> appreciated.
> 
> 
> Joel Lilienkamp
> 
