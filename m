From: Maurice Hilarius <maurice@harddata.com>
Subject: Re: mdadm and TLER (Time Limited Error Recovery)
Date: Tue, 08 Sep 2009 19:33:56 -0600
Message-ID: <4AA70604.7020709@harddata.com>
References: <299cc2790909071735x6eefd8bsc05ad76fa782cae1@mail.gmail.com> <slrnhacpsm.2i5.Mario.Holbe@darkside.dyn.samba-tng.org> <20090908184837.GA28217@teal.hq.k1024.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090908184837.GA28217@teal.hq.k1024.org>
Sender: linux-raid-owner@vger.kernel.org
To: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Cc: linux-raid@vger.kernel.org, iusty@k1024.org
List-Id: linux-raid.ids

Iustin Pop wrote:
> ..
>> Anyways, clarification...
>> The only reason for TLER (Time Limited Error Recovery) is to behave
>> "friendly" toward RAID controllers that timeout disks.
>> In fact, md does not timeout disks as many Hardware RAID controllers do.
>> So, from md's point of view, TLER is useless, i.e. it has no benefit.
>>     
>
> I'm sorry but I disagree here. *Especially* because md is used over
> normal SATA controllers most of the time, TLER is beneficial because the
> drive doesn't go catatonic for minutes at a time trying to recover a bad
> sector, which would (because md doesn't timeout disks) cause md to hung
> up the whole device. TLER will allow md to see the error quickly and
> attempt to rewrite (read) or retry/fail the disk (write) for a bad the
> sector.
>
> Just my understanding of the md stack.
>
> regards,
> iustin
>
>   
I agree.
Before WD implemented this we would see cases quite often where a 
perfectly good drive would get "kicked out"
of a RAID as frequently or even more often, than on a hardware RAID.
TLER management seems to have eliminated most of these cases.



-- 
Regards, Maurice
