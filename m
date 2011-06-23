From: Iordan Iordanov <iordan@cdf.toronto.edu>
Subject: Re: Looking for the best way to do this
Date: Thu, 23 Jun 2011 15:23:06 -0400
Message-ID: <4E03929A.8000503@cdf.toronto.edu>
References: <4E00DF31.2020406@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E00DF31.2020406@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: maurice <mhilarius@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Maurice,

On 06/21/11 14:13, maurice wrote:
> Add 3rd disk to make a 3 disk RAID1
> Make a RAID10, missing one disk.

Perhaps I misunderstand your supposition, and if I do, please correct 
me. RAID10 with mdadm does not require a minimum of 4 disks. For 
example, mdadm can do RAID10 with 2 copies on 3 disks or RAID10 with 3 
copies on 3 disks, yielding the equivalent of RAID1 in terms of data 
security. It is not confined to mirroring two pairs of disks and then 
striping across them as is the "conventional" way of doing RAID10.

You can read the man-page of mdadm, where the options for "layout" of 
RAID10 are discussed. Pay particular attention to the end of the 
"--layout" option explanation.

Cheers!
Iordan
