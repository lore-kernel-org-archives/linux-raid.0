From: Francis Moreau <francis.moro@gmail.com>
Subject: Re: Guess the size of a RAID{5,6} device
Date: Sat, 12 Apr 2014 10:12:00 +0200
Message-ID: <5348F550.2040609@gmail.com>
References: <5347A58B.2060308@gmail.com> <20140412095049.6cce32a6@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140412095049.6cce32a6@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello Neil,

On 04/12/2014 01:50 AM, NeilBrown wrote:
> On Fri, 11 Apr 2014 10:19:23 +0200 Francis Moreau <francis.moro@gmail.com>
> wrote:
> 
>> Hello,
>>
>> I'd like to know if it's possible to get the size of a RAID{5,6} which
>> is not created yet but the size of the partitions which will make up the
>> array are.
> 
> How precise does the "guess" need to be?
> 

I just need an approximation in order to report to user some information
about the (raided) partition my tool is about to create.

> If you subtract about 128Meg from the size of the partitions, round down the

Just to be sure the size of the partitions is equal to the min size of
all partitions ?

> a multiple of the chunk size then multiply by the number of data disks, you
> should come quite close.

Thanks, that should do the trick.

