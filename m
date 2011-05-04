From: David Brown <david@westcontrol.com>
Subject: Re: mdadm raid1 read performance
Date: Wed, 04 May 2011 09:48:03 +0200
Message-ID: <ipr099$tp6$1@dough.gmane.org>
References: <BANLkTim8Ehn0fANtibg7X1cMVvOgt7CNMA@mail.gmail.com> <20110504105822.21e23bc3@notabene.brown> <BANLkTimzqu1C+_Z2t5m1bjduXFeRwbgssQ@mail.gmail.com> <4DC0F2B6.9050708@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DC0F2B6.9050708@fnarfbargle.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 04/05/2011 08:31, Brad Campbell wrote:
> On 04/05/11 13:30, Drew wrote:
>
>> It seemed logical to me that if two disks had the same data and we
>> were reading an arbitrary amount of data, why couldn't we split the
>> read across both disks? That way we get the benefits of pulling from
>> multiple disks in the read case while accepting the penalty of a write
>> being as slow as the slowest disk..
>>
>>
>
> I would have thought as you'd be skipping alternate "stripes" on each
> disk you minimise the benefit of a readahead buffer and get subjected to
> seek and rotational latency on both disks. Overall you're benefit would
> be slim to immeasurable. Now on SSD's I could see it providing some
> extra oomph as you suffer none of the mechanical latency penalties.
>

Even on SSD's you'd get some overhead for the skipping - each read 
command has to be tracked by both the host software and the disk firmware.

Such splitting would have to be done on a larger scale to make it 
efficient.  If you request a read for 2 MB, you could take the first MB 
from the first disk and simultaneously the second MB for the second disk.


