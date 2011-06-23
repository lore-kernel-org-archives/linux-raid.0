From: maurice <mhilarius@gmail.com>
Subject: Re: Looking for the best way to do this
Date: Thu, 23 Jun 2011 16:06:19 -0600
Message-ID: <4E03B8DB.7010607@gmail.com>
References: <4E00DF31.2020406@gmail.com> <4E03929A.8000503@cdf.toronto.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E03929A.8000503@cdf.toronto.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Iordan Iordanov <iordan@cdf.toronto.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 6/23/2011 1:23 PM, Iordan Iordanov wrote:
> Hi Maurice,
>
> On 06/21/11 14:13, maurice wrote:
>> Add 3rd disk to make a 3 disk RAID1
>> Make a RAID10, missing one disk.
>
> Perhaps I misunderstand your supposition, and if I do, please correct 
> me. RAID10 with mdadm does not require a minimum of 4 disks.
Yes, that was my understanding.

> For example, mdadm can do RAID10 with 2 copies on 3 disks or RAID10 
> with 3 copies on 3 disks, yielding the equivalent of RAID1 in terms of 
> data security. It is not confined to mirroring two pairs of disks and 
> then striping across them as is the "conventional" way of doing RAID10.
Yes, I understand the principle.
>
> You can read the man-page of mdadm, where the options for "layout" of 
> RAID10 are discussed. Pay particular attention to the end of the 
> "--layout" option explanation.

What I do NOT know is the following:
A) Which is more RELIABLE: R1 with 3 disks or R10 with 3 disks.
B) HOW to create either the 3 disk R1 or R10, assuming an existing 2 
disk R1.



-- 
Cheers,
Maurice Hilarius
eMail: /mhilarius@gmail.com/
