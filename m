From: Tim Small <tim@seoss.co.uk>
Subject: RAID mismatches (and reporting thereof)
Date: Wed, 08 Sep 2010 10:40:53 +0100
Message-ID: <4C875A25.5080301@seoss.co.uk>
References: <20100907141904.3696.qmail@science.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100907141904.3696.qmail@science.horizon.com>
Sender: linux-raid-owner@vger.kernel.org
To: George Spelvin <linux@horizon.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 07/09/10 15:19, George Spelvin wrote:
> After some frustration with RAID-5 finding mismatches and not being
> able to figure out which drive has the problem, I'm setting up a rather
> intricate 5-way mirrored (x 2-way striped) system.
>    

Out of interest, what systems are you seeing mismatches on?  Most of the 
ones I've seen are on LSI1068* SAS controllers (with SATA drives, but 
not sure if that counts for anything, don't use many SAS drives) 
including the Dell SAS5* and SAS6* series.  I suspect there are some 
corner cases where they corrupt data on disk.  Should open a kernel.org 
bug really, so that LSI can ignore the issue in public...

Tim.

-- 
South East Open Source Solutions Limited
Registered in England and Wales with company number 06134732.
Registered Office: 2 Powell Gardens, Redhill, Surrey, RH1 1TQ
VAT number: 900 6633 53  http://seoss.co.uk/ +44-(0)1273-808309

