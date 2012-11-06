From: Holger Kiehl <Holger.Kiehl@dwd.de>
Subject: Re: Problem with DISCARD and RAID10
Date: Tue, 6 Nov 2012 19:55:35 +0000 (GMT)
Message-ID: <alpine.LRH.2.02.1211061951500.11872@diagnostix.dwd.de>
References: <5098D92A.3000503@fnarfbargle.com> <20121106114017.GB19182@kernel.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20121106114017.GB19182@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: Brad Campbell <brad@fnarfbargle.com>, linux RAID <linux-raid@vger.kernel.org>, martin.petersen@oracle.com
List-Id: linux-raid.ids

Hello,

just wanted to report that I see the same messages with 3.7.0-rc4 and a
Raid0 on two SSD's (Crucial M4):

    Nov  6 20:46:06 yoda kernel: [ 5583.447345]   bio ffff8803fe73aa80, biotail ffff8803fe73aa80, buffer           (null), len 0
    Nov  6 20:46:06 yoda kernel: [ 5583.455443] request botched: dev sda: type=1, flags=122d8081
    Nov  6 20:46:06 yoda kernel: [ 5583.455446]   sector 11433985, nr/cnr 0/1024
    Nov  6 20:46:06 yoda kernel: [ 5583.455448]   bio ffff8803fe73a9c0, biotail ffff8803d6a3b9c0, buffer           (null), len 0
    Nov  6 20:46:06 yoda kernel: [ 5583.456452] request botched: dev sdb: type=1, flags=122d8081
    Nov  6 20:46:06 yoda kernel: [ 5583.456454]   sector 11433985, nr/cnr 0/1024
    Nov  6 20:46:06 yoda kernel: [ 5583.456456]   bio ffff8803fe73a900, biotail ffff8803d6a3b540, buffer           (null), len 0
    Nov  6 20:46:06 yoda kernel: [ 5583.457256] request botched: dev sda: type=1, flags=122d8081
    Nov  6 20:46:06 yoda kernel: [ 5583.457258]   sector 11433986, nr/cnr 0/1024
    Nov  6 20:46:06 yoda kernel: [ 5583.457260]   bio ffff8803fe73a840, biotail ffff8803d6a3b9c0, buffer           (null), len 0
    Nov  6 20:46:06 yoda kernel: [ 5583.458315] request botched: dev sdb: type=1, flags=122d8081
    Nov  6 20:46:06 yoda kernel: [ 5583.458317]   sector 11433986, nr/cnr 0/1024

Regards,
Holger


On Tue, 6 Nov 2012, Shaohua Li wrote:

> On Tue, Nov 06, 2012 at 05:32:26PM +0800, Brad Campbell wrote:
>> G'day Shaohua,
>>
>> I'm testing Vanilla 3.7.0-rc4 and bumping up against squillions of these :
>>
>> [   41.094726] request botched: dev sdc: type=1, flags=122d8081
>> [   41.094774]   sector 28317178, nr/cnr 0/32
>> [   41.094815]   bio ffff8807fe885300, biotail ffff8807fe887300,
>> buffer           (null), len 0
>> [   41.100045] request botched: dev sda: type=1, flags=122d8081
>> [   41.100094]   sector 28317403, nr/cnr 0/32
>> [   41.100134]   bio ffff8807fe885840, biotail ffff8807fe887840,
>> buffer           (null), len 0
>> [   41.100718] request botched: dev sdb: type=1, flags=122d8081
>> [   41.100767]   sector 28317179, nr/cnr 0/224
>> [   41.100808]   bio ffff8807fe885a80, biotail ffff8807fe887d80,
>> buffer           (null), len 0
>> [   41.104649] request botched: dev sdc: type=1, flags=122d8081
>> [   41.104697]   sector 28317179, nr/cnr 0/224
>> [   41.104738]   bio ffff8807fe886000, biotail ffff8807fe887300,
>> buffer           (null), len 0
>
> cc Martin to check if he has idea.
>
> Hmm, I thought such problem is already fixed by Martin's discard merge patches
> and my last test in SATA SSD doesn't show this problem. Maybe there is still
> a corner case we didn't handle discard request merge well. Time run out today,
> I'll check tomorrow.
>
> Thanks,
> Shaohua
