From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Awful RAID5 random read performance
Date: Mon, 01 Jun 2009 13:01:57 +0100
Message-ID: <4A23C335.30306@anonymous.org.uk>
References: <4A21A938.6050907@harddata.com>	<4A2222E6.2070705@msgid.tls.msk.ru>	<200905310147.58119.tfjellstrom@shaw.ca>	<4A227832.1090808@anonymous.org.uk> <874ov1w5po.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <874ov1w5po.fsf@frosties.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 31/05/2009 18:19, Goswin von Brederlow wrote:
> John Robinson <john.robinson@anonymous.org.uk> writes:
>> Clearly when you're doing this over 4 drives you can have ~400
>> seeks/second but that's still limiting you to ~400 reads/second for
>> smallish block sizes.
> 
> Note that that only holds true for writes or multithreaded reads.
> Reading from a single thread will randomly pick one drive (depending
> on where it wants to read), wait for it to seek, read one block of
> data and repeat. So you get the speed of a single drive no matter how
> many drives there are in the raid.

Sure, that's why I said "can", but I thought iozone was multi-threaded. 
Maybe it needs an option specified, in which case using more threads 
than there are discs would be a good idea.

Cheers,

John.
