From: "Dan Williams" <dan.j.williams@intel.com>
Subject: Re: [PATCH 001 of 006] raid5: Move write operations to a work queue
Date: Thu, 27 Jul 2006 11:53:34 -0700
Message-ID: <e9c3a7c20607271153i3bc9ae80u64adf56d2915a959@mail.gmail.com>
References: <E1G67BP-000MnP-00.yur_t-mail-ru@f73.mail.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <E1G67BP-000MnP-00.yur_t-mail-ru@f73.mail.ru>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Yuri Tikhonov <yur_t@mail.ru>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 7/27/06, Yuri Tikhonov <yur_t@mail.ru> wrote:
>
>  Hello, Dan.
>
>  I've looked through your patches, and have some suggestions about write operations processing.

Thanks for reviewing the code.

>
>  In the current implementation of the Raid5 driver the RMW operation won't begin until old blocks in the stripe cache,
> which are to be rewritten, become UPTODATE.
>  But if you have dedicated h/w DMA engines, then, while an IOC(input/output contoller) performs transmition of the
> old strip data from the disk to the stripe cache, it may make sense to start a DMA engine, which will transmit new
> strip data from the bio requested to write. So, when an IOC operation complete, we'll already have all necessary data
> to compute new parity value.
>
> 1) For the current implementation:
>
>  Trmw = Tioc1 + Txor1 + Tdma + Txor2 + Tioc2,
>  where Tioc1 is the time it takes to update stripe cache with old data, Txor1 is the time it takes to substract
> old data from old parity value, Tdma is the time it takes to update strip with new data, Txor2 is the time it takes
> to compute new parity, and Tioc2 is the time it takes to transfer updated data to disks.
>  So, Trmw = 2*Tioc + 2*Txor + Tdma
>
> 2) If copying old and new data to stripe cache is performed simultaneously, then time to complete the whole RMW
> operation will take:
>
>  T'rmw = max(Tioc1, Tdma) + 2*Txor + Tioc2,
>  where Tioc1 is the time it takes to update stripe cache with old data, Tdma is the time it takes to update strip
> with new data, 2*Txor is the time it takes to compute new parity, and Tioc2 is the time it takes to transfer updated
> data to disks.
>  So, T'rmw = 2*Tioc + 2*Txor.
> (in any case, i think that Tioc > Tdma, because Tioc corresponds to the time spent reading from disk, and
> Tdma corresponds to operations with SDRAM, which are faster).
>
>  Also, 2*Txor for (2) is less then 2*Txor for (1), because in (2) approach we have to prepare XOR engine descriptors only
> once, but in the (1) approach - twice.
>
>  Does it make sense to revise your Raid5 driver implementaion to allow IOC and DMA to have separate destination buffers? That is, some kind of a stripe shadow. IOC will copy to the regular buffer in the stripe cache, DMA - to the shadow one.
>
The issue I see with this is that Tioc1 is orders of magnitude greater
than Tdma.  So while I agree there may be room to get some pre-work
done while the reads are in flight I do not expect that the
performance increase would be significant, and definitely not worth
the design complexity of adding a "shadow buffer".

>  Regards, Yuri.
>
Regards,

Dan
