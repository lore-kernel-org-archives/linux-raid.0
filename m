From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: *terrible* direct-write performance with raid5
Date: Wed, 23 Feb 2005 20:38:05 +0300
Message-ID: <421CBF7D.20801@tls.msk.ru>
References: <421B6E5D.6030004@tls.msk.ru> <Pine.LNX.4.62.0502221507160.25248@twinlark.arctic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <Pine.LNX.4.62.0502221507160.25248@twinlark.arctic.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

dean gaudet wrote:
> On Tue, 22 Feb 2005, Michael Tokarev wrote:
> 
> 
>>When debugging some other problem, I noticied that
>>direct-io (O_DIRECT) write speed on a software raid5
>>is terrible slow.  Here's a small table just to show
>>the idea (not numbers by itself as they vary from system
>>to system but how they relate to each other).  I measured
>>"plain" single-drive performance (sdX below), performance
>>of a raid5 array composed from 5 sdX drives, and ext3
>>filesystem (the file on the filesystem was pre-created
>>during tests).  Speed measurements performed with 8Kbyte
>>buffer aka write(fd, buf, 8192*1024), units a Mb/sec.
> 
> with O_DIRECT you told the kernel it couldn't cache anything... you're 
> managing the cache.  you should either be writing 64KiB or you should 
> change your chunksize to 8KiB (if it goes that low).

The picture does not change at all when changing raid chunk size.
With 8kb chunk speed is exactly the same as with 64kb or 256kb chunk.

Yes, increasing write buffer size helps alot.  Here's the write
performance in mb/sec for direct-write into an md device which
is a raid5 array built from 5 drives depending on the write
buffer size (in kb):

  buffer  md raid5    sdX
            speed    speed
      1      0.2       14
      2      0.4       26
      4      0.9       41
      8      1.7       44
     16      3.9       44
     32     72.6       44
     64     84.6       ..
    128     97.1
    256     53.7
    512     64.1
   1024     74.5

I've no idea why there's a drop in speed after 128kb blocksize,
but the more important is a huge drop with 32->16 kb blocksize.

The numbers are almost exactly the same with several chunksizes --
256kb, 64kb (default), 8kb and 4kb.

(note raid5 performs faster than a single drive, it's expectable
as it is possible to write to several drives in parallel).

The numbers also does not depend much on seeking -- obviously the
speed with seeking is worse than the above for sequential write,
but not much worse (about 10..20%, not >20 times as with 72 vs 4
mb/sec).

/mjt

