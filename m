From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Need to remove failed disk from RAID5 array
Date: Thu, 19 Jul 2012 10:51:01 -0400
Message-ID: <50081ED5.8090908@tmr.com>
References: <CAB1R3shxBWebm13ie5gR0h++-GBTyfZrranHr8tjGkbPipV32w@mail.gmail.com> <50071C0A.8080307@tmr.com> <CAB1R3sjhES1+0XB43oXLomgH7Q6LPiTm11tPSoDJ91RRrfNy=A@mail.gmail.com> <20120719091611.22e16100@natsu> <500818D5.4080208@tmr.com> <20120719203557.62a12bcd@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120719203557.62a12bcd@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Roman Mamedov wrote:
> On Thu, 19 Jul 2012 10:25:25 -0400
> Bill Davidsen <davidsen@tmr.com> wrote:
>
>> That's a good argument for not using "whole disk" array members, a partition can
>> be started at a good offset and may perform better.
>
> Not really, at least with the modern metadata versions this is not a problem,
> as the whole-disk array members will start the actual data at an offset that is
> suitably aligned for the AF drives.
>
When did that start? And how does it handle adding a new drive to an array 
created back under 2.6 which didn't do that? Good to be aware of, though.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot


