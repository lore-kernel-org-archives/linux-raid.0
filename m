From: Phil Turmel <philip@turmel.org>
Subject: Re: Looking for the best way to do this
Date: Thu, 23 Jun 2011 18:55:00 -0400
Message-ID: <4E03C444.6060406@turmel.org>
References: <4E00DF31.2020406@gmail.com> <4E03929A.8000503@cdf.toronto.edu> <4E03B8DB.7010607@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E03B8DB.7010607@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: maurice <mhilarius@gmail.com>
Cc: Iordan Iordanov <iordan@cdf.toronto.edu>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi maurice,

On 06/23/2011 06:06 PM, maurice wrote:
> On 6/23/2011 1:23 PM, Iordan Iordanov wrote:
>> Hi Maurice,
>>
>> On 06/21/11 14:13, maurice wrote:
>>> Add 3rd disk to make a 3 disk RAID1
>>> Make a RAID10, missing one disk.
>>
>> Perhaps I misunderstand your supposition, and if I do, please correct me. RAID10 with mdadm does not require a minimum of 4 disks.
> Yes, that was my understanding.
> 
>> For example, mdadm can do RAID10 with 2 copies on 3 disks or RAID10 with 3 copies on 3 disks, yielding the equivalent of RAID1 in terms of data security. It is not confined to mirroring two pairs of disks and then striping across them as is the "conventional" way of doing RAID10.
> Yes, I understand the principle.
>>
>> You can read the man-page of mdadm, where the options for "layout" of RAID10 are discussed. Pay particular attention to the end of the "--layout" option explanation.
> 
> What I do NOT know is the following:
> A) Which is more RELIABLE: R1 with 3 disks or R10 with 3 disks.

R1 with 3 disks is three copies of all sectors.  R10 with three disks can be either two copies of each sector or three copies.  A two-copy layout would have capacity equal to 1.5 * the member disk size.  For reliability, three copies is better than two copies.  R10 and R1 use different algorithms, so you will have different performance pros and cons.

> B) HOW to create either the 3 disk R1 or R10, assuming an existing 2 disk R1.

You can "--grow" the number of disks (copies) in an R1 while running.  R10 does not (yet) support layout or capacity changes, whether running or not.  So if you want R10, you'll have to start from scratch.

If you are willing to give up your redundancy temporarily, you could create a degraded R10 from the new drive and one of the existing drives, copy the partition from the remaining drive in the R1, stop and destroy the R1, then add that disk into the R10.

Phil
