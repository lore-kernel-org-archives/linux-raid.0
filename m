From: "Dan Williams" <dan.j.williams@intel.com>
Subject: Re: ioatdma
Date: Wed, 19 Mar 2008 16:42:18 -0700
Message-ID: <e9c3a7c20803191642t48de79acv7c299198a19a75f9@mail.gmail.com>
References: <frqo2s$tl2$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <frqo2s$tl2$1@ger.gmane.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Bernd Schubert <bs@q-leap.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Mar 19, 2008 at 2:57 AM, Bernd Schubert <bs@q-leap.de> wrote:
> Hello,
>
>  from my understanding of ioatdma it just should be loaded before raid456 to
>  make use it, shouldn't it?
>
>  I just wonder why memcpy_count and bytes_transferred in /sys/class/dma/* is
>  always zero.
>

Currently only network traffic will update these counts.  They are not
currently hooked up for the raid/async_tx case.  NET_DMA uses
dma_async_memcpy_*() whereas MD uses async_memcpy().

In my tests with the iop-adma driver on an iop342.  I look at
/proc/interrupts to check that things are alive and kicking.

You could add the following to async_memcpy():
        cpu = get_cpu();
        per_cpu_ptr(chan->local, cpu)->bytes_transferred += len;
        per_cpu_ptr(chan->local, cpu)->memcpy_count++;
        put_cpu();


--
Dan
