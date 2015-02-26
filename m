From: Alireza Haghdoost <alireza@cs.umn.edu>
Subject: Re: RAID6 write I/O amplification?
Date: Wed, 25 Feb 2015 18:40:46 -0600
Message-ID: <CAB-428mPydqGoku-RnhZUDVyHVnzb73Yz=5bL7DOd+G88siDtg@mail.gmail.com>
References: <20150224045835.14e40dcb@natsu> <12EF8D94C6F8734FB2FF37B9FBEDD1735F9E168E@EXCHANGE.collogia.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <12EF8D94C6F8734FB2FF37B9FBEDD1735F9E168E@EXCHANGE.collogia.de>
Sender: linux-raid-owner@vger.kernel.org
To: Markus Stockhausen <stockhausen@collogia.de>
Cc: Roman Mamedov <rm@romanrm.net>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Feb 24, 2015 at 12:29 AM, Markus Stockhausen
<stockhausen@collogia.de> wrote:
>> Von: linux-raid-owner@vger.kernel.org [linux-raid-owner@vger.kernel.org]&quot; im Auftrag von &quot;Roman Mamedov [rm@romanrm.net]
>> Gesendet: Dienstag, 24. Februar 2015 00:58
>> An: linux-raid@vger.kernel.org
>> Betreff: RAID6 write I/O amplification?
>>
>> Hello,
>>
>> Got a bit of a "how does it actually work" question...
>>
>> Suppose I have an MD RAID6 of 8 drives, with 64KB chunk size.
>>
>> I am rewriting a 4KB filesystem sector somewhere on that RAID (not crossing
>> the stripe boundary).
>>
>> What's the amount of disk I/O in total this will result in?
>>
>> I assume the RAID will need to read data from all drives, recompute parity,
>> then write to the data stripe where the updated piece happened to be, and also
>> write to two parity stripes.
>>
>> Is this done at a stripe granularity, so 6x64KB reads, 3x64KB writes?
>> Or down to individual sectors (pages), i.e. 6x4KB reads, 3x4KB writes?
>> Or am I describing this algorithm correctly at all?
>
> Implementation will work on "internal" stripe granularity and that is 4K
> So your case will be 6x4KB read + 3x4KB write.

Having said that, does it mean that following description of "chunk
size"  is wrong:
'[chunk size] is the smallest "atomic" mass of data that can be
written to the devices'
since in this case chunk size is 64KB but 4KB is written atomically (?).
I have find it in the kernel.org wiki page [1]

---
Alireza
1. https://raid.wiki.kernel.org/index.php/RAID_setup
