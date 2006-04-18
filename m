From: Maurice Hilarius <maurice@harddata.com>
Subject: Re: RAID5 recovery trouble, bd_claim failed?
Date: Tue, 18 Apr 2006 16:13:08 -0600
Message-ID: <44456474.9040201@harddata.com>
References: <1145106091.18173.18.camel@nemo.qabal.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1145106091.18173.18.camel@nemo.qabal.org>
Sender: linux-raid-owner@vger.kernel.org
To: Nathanial Byrnes <nate@qabal.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Nathanial Byrnes wrote:
> Hi All,
> 	Recently I lost a disk in my raid5 SW array. It seems that it took a
> second disk with it. The other disk appears to still be funtional (from
> an fdisk perspective...). I am trying to get the array to work in
> degraded mode via failed-disk in raidtab, but am always getting the
> following error:
>
>   
Let me guess:
IDE disks, in pairs.
Jumpered as Master and Salve.

Right?





-- 

With our best regards,


Maurice W. Hilarius        Telephone: 01-780-456-9771
Hard Data Ltd.  FAX:       01-780-456-9772
11060 - 166 Avenue         email:maurice@harddata.com
Edmonton, AB, Canada       http://www.harddata.com/
   T5X 1Y3

