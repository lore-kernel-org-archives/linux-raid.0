From: Tejun Heo <htejun@gmail.com>
Subject: Re: Possible data corruption sata_sil24?
Date: Thu, 19 Jul 2007 17:03:02 +0900
Message-ID: <469F1AB6.3000105@gmail.com>
References: <20070706012432.GB29789@jabberwocky.com> <4693A5A0.5070306@gmail.com> <20070713014252.GA17811@jabberwocky.com> <46972AEE.2040805@gmail.com> <20070713115919.GC17811@jabberwocky.com> <469DD513.7070202@gmail.com> <20070718123100.GB3932@jabberwocky.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070718123100.GB3932@jabberwocky.com>
Sender: linux-raid-owner@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>, linux-ide@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

David Shaw wrote:
>> I'm not sure whether this is problem of sata_sil24 or dm layer.  Cc'ing
>> linux-raid for help.  How much memory do you have?  One big difference
>> between ata_piix and sata_sil24 is that sil24 can handle 64bit DMA.
>> Maybe dma mapping or something interacts weirdly with dm there?
> 
> The machine has 640 megs of RAM.  FWIW, I tried this with 512 megs of
> RAM with the same results.  Running Memtest86+ shows the memory is
> good.

Hmmm... I see, so no DMA to the wrong address problem then.  Let's see
whether dm people can help us out.

Thanks.

-- 
tejun
