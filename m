From: Maurice Hilarius <maurice@harddata.com>
Subject: Re: RAID5 recovery trouble, bd_claim failed?
Date: Wed, 19 Apr 2006 08:04:24 -0600
Message-ID: <44464368.2080406@harddata.com>
References: <1145106091.18173.18.camel@nemo.qabal.org>	 <44456474.9040201@harddata.com> <1145403579.15773.1.camel@nemo.qabal.org> <44463E0A.8090906@harddata.com> <444640F1.3020008@qabal.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <444640F1.3020008@qabal.org>
Sender: linux-raid-owner@vger.kernel.org
To: Nate Byrnes <nate@qabal.org>
Cc: linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids

Nate Byrnes wrote:
> Hi All,
>    I'm not sure that is entirely the case. From a hardware
> perspective, I can access all the disks from the OS, via fdisk and dd.
> It is really just mdadm that is failing.  Would I still need to work
> the jumper issue?
>    Thanks,
>    Nate
>
IF the disks are as we suspect (master and slave relationships) and IF
you now have either a failed or a removed drive, then you  MUST correct
the jumpering.
Sure, you can often see a disk that is misconfigured.
It is almost certain, however, that when you write to it you will simply
cause corruption on it.

Of course, so far this is all speculation, as you have not actually said
what the disks, controller interfaces, and jumpering and so forth are at.
I was merely speculating, based on what you have said.

No amount of software magic will "cure" a hardware problem..


-- 

With our best regards,


Maurice W. Hilarius        Telephone: 01-780-456-9771
Hard Data Ltd.  FAX:       01-780-456-9772
11060 - 166 Avenue         email:maurice@harddata.com
Edmonton, AB, Canada       http://www.harddata.com/
   T5X 1Y3

