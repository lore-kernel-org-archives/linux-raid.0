From: Laurent CARON <lcaron@unix-scripts.info>
Subject: Re: mdadm + raid1 of 2 disks and now need to add more
Date: Tue, 11 Apr 2006 19:25:58 +0200
Message-ID: <443BE6A6.5000202@unix-scripts.info>
References: <e3edb0fa0604110741h355f4eft3f3d42a825cb4233@mail.gmail.com> <20060411145142.GR29446@strugglers.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060411145142.GR29446@strugglers.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Andy Smith wrote:
> On Tue, Apr 11, 2006 at 04:41:30PM +0200, Shai wrote:
>> I have two SCSI disks on raid1.
>> Since I have lots of reads from that raid, I want to add two more
>> disks to this raid so that read will be faster.
>>
>> How should I add the new disks?
> 
> Is this possible with md currently:
> 
> Create a RAID-10 on the two new disks specifying one disk missing
> from each mirror.
> 
> Then copy data over and add the two existing disks letting it
> resync?

Why not growing the array with 2 more disks?
