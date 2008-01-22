From: Iustin Pop <iusty@k1024.org>
Subject: Re: One Large md or Many Smaller md for Better Peformance?
Date: Tue, 22 Jan 2008 16:32:46 +0100
Message-ID: <20080122153246.GB28324@teal.hq.k1024.org>
References: <4793AE0E.609@pobox.com> <20080120215734.GD17584@teal.hq.k1024.org> <47940F31.7020907@pobox.com> <18325.21933.337369.104689@fisica.ufpr.br> <4795D4B6.4070908@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4795D4B6.4070908@pobox.com>
Sender: linux-raid-owner@vger.kernel.org
To: Moshe Yudkowsky <moshe@pobox.com>
Cc: Carlos Carvalho <carlos@fisica.ufpr.br>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Jan 22, 2008 at 05:34:14AM -0600, Moshe Yudkowsky wrote:
> Carlos Carvalho wrote:
>
>> I use reiser3 and xfs. reiser3 is very good with many small files. A
>> simple test shows interactively perceptible results: removing large
>> files is faster with xfs, removing large directories (ex. the kernel
>> tree) is faster with reiser3.
>
> My current main concern about XFS and reiser3 is writebacks. The default  
> mode for ext3 is "journal," which in case of power failure is more  
> robust than the writeback modes of XFS, reiser3, or JFS -- or so I'm  
> given to understand.
>
> On the other hand, I have a UPS and it should shut down gracefully  
> regardless if there's a power failure. I wonder if I'm being too 
> cautious?

I'm not sure what your actual worry is. It's not like XFS loses
*commited* data on power failure. It may lose data that was never
required to go to disk via fsync()/fdatasync()/sync. If someone is
losing data on power failure is the unprotected write cache of the
harddrive.

If you have properly-behaved applications, then they know when to do an
fsync and if XFS returns success on fsync and your linux is properly
configured (no write-back caches on drives that are not backed by NVRAM,
etc.) then you won't lose data.

regards,
iustin
