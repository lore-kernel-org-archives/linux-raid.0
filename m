From: aragonx@dcsnow.com
Subject: Re: How to boost performance
Date: Thu, 17 Jun 2010 15:46:05 -0400
Message-ID: <db120b2f917a2de03cbb3834ef56be7f.squirrel@www.dcsnow.com>
References: <ea83c7a1ddca01e0a1535f130502a0f2.squirrel@www.dcsnow.com>
    <20100617100109.32a20ffa@natsu>
    <d98b7022efc6988e47f7e4114aa83f62.squirrel@www.dcsnow.com>
    <20100617221300.3e30afe0@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100617221300.3e30afe0@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <roman@rm.pp.ru>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> On Thu, 17 Jun 2010 09:49:42 -0400
> A more consistent way to test would be to cd into a directory on the
> array,
> and repeatedly run something like:
>
> dd if=/dev/zero of=zerofile bs=1M count=2048 conv=fdatasync,notrunc
>
> ...and implement various tweaks you are trying out between the runs, to
> see
> their effect.
>
> Also, the reason you see the write speed dropping off in the end, is
> because
> your server first fills up its write cache almost at the maximum
> attainable sender's (and network) speed, then, as the space in RAM for
> that
> cache runs out, starts flushing it to disk, reducing the rate at which it
> receives new data from the network. So you see that the 70 MB/sec figure
> is
> totally unrelated to the RAID's performance. The dd test described above,
> thanks to these "conv" flags (see the dd man page) will have much more
> sense
> as a benchmark.

Hi Roman,

While I would agree with you if the performance was the same for reads as
it was writes, that is not the case here.  Additionally, I was not SURE
the where my bottleneck was.  It did not have to be storage related. 
Although I had my suspicions.  That is why I included all the information
I thought was relevant.

That being said, I did try two different DD tests that appear to provide
the same results.  This is a more clean method of testing the storage
subsystem though and will use it for further testing on this issue.

time dd if=/dev/zero of=zerofile bs=1M count=2048 conv=fdatasync,notrunc
2048+0 records in
2048+0 records out
2147483648 bytes (2.1 GB) copied, 28.728 s, 74.8 MB/s

real    0m28.732s
user    0m0.004s
sys     0m23.600s

time dd if=/dev/zero of=zerofile bs=1M count=6144 conv=fdatasync,notrunc
6144+0 records in
6144+0 records out
6442450944 bytes (6.4 GB) copied, 196.618 s, 32.8 MB/s

real    3m16.622s
user    0m0.012s
sys     0m27.726s



-- 
This message has been scanned for viruses and
dangerous content by MailScanner, and is
believed to be clean.

