From: Al Boldi <a1426z@gawab.com>
Subject: Re: Linux Software RAID 5 + XFS Multi-Benchmarks / 10 Raptors Again
Date: Thu, 17 Jan 2008 00:19:04 +0300
Message-ID: <200801170019.04836.a1426z@gawab.com>
References: <alpine.DEB.0.999999.0801161105510.16168@p34.internal.lan> <200801162027.00791.a1426z@gawab.com> <alpine.DEB.0.999999.0801161243380.1151@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.0.999999.0801161243380.1151@p34.internal.lan>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: xfs@oss.sgi.com, linux-raid@vger.kernel.org, Alan Piszcz <ap@solarrain.com>
List-Id: linux-raid.ids

Justin Piszcz wrote:
> On Wed, 16 Jan 2008, Al Boldi wrote:
> > > Also, can you retest using dd with different block-sizes?
>
> I can do this, moment..
>
>
> I know about oflag=direct but I choose to use dd with sync and measure the
> total time it takes.
> /usr/bin/time -f %E -o ~/$i=chunk.txt bash -c 'dd if=/dev/zero
> of=/r1/bigfile bs=1M count=10240; sync'
>
> So I was asked on the mailing list to test dd with various chunk sizes,
> here is the length of time it took
> to write 10 GiB and sync per each chunk size:
>
> 4=chunk.txt:0:25.46
> 8=chunk.txt:0:25.63
> 16=chunk.txt:0:25.26
> 32=chunk.txt:0:25.08
> 64=chunk.txt:0:25.55
> 128=chunk.txt:0:25.26
> 256=chunk.txt:0:24.72
> 512=chunk.txt:0:24.71
> 1024=chunk.txt:0:25.40
> 2048=chunk.txt:0:25.71
> 4096=chunk.txt:0:27.18
> 8192=chunk.txt:0:29.00
> 16384=chunk.txt:0:31.43
> 32768=chunk.txt:0:50.11
> 65536=chunk.txt:2:20.80

What do you get with bs=512,1k,2k,4k,8k,16k...


Thanks!

--
Al

