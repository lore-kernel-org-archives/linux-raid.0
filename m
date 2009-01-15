From: David Greaves <david@dgreaves.com>
Subject: Re: Interesting article
Date: Thu, 15 Jan 2009 11:09:00 +0000
Message-ID: <496F194C.2050002@dgreaves.com>
References: <496E44DE.7090200@harddata.com> <f3177b9e0901141455i460f09cs69e38e24842e9c62@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <f3177b9e0901141455i460f09cs69e38e24842e9c62@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Worley <worleys@gmail.com>
Cc: Maurice Hilarius <maurice@harddata.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Chris Worley wrote:
> On Wed, Jan 14, 2009 at 1:02 PM, Maurice Hilarius <maurice@harddata.com> wrote:
>> I read this today:
>> http://blogs.zdnet.com/storage/?p=162
>>
>> Would anyone who knows enough about this care to comment?
> 
> We need disks continuously scanned in spare cycles, and offline the
> drives (or remap the sectors) as soon as an error is found.
> 
> Also, when rebuilding an array, don't stop due to a read failure.
> mark the sector as bad and complete the rebuild.
> 
> Waiting for a drive to fail has been too late to recover the array, in
> my experience.

Agreed - and I think another huge gap is that when you lose a block you really
should be able to find out what file was affected. Doable on ext3 but not
(AFAIK) xfs.

Though that is a filesystem issue, not a RAID issue.

David

