From: Asdo <asdo@shiftmail.org>
Subject: Re: xfs > md 50% write performance drop on .30+ kernel?
Date: Tue, 13 Oct 2009 12:21:20 +0200
Message-ID: <4AD454A0.3050704@shiftmail.org>
References: <66781b10910120958k4afb637ejba79e4c23900c4da@mail.gmail.com>
 <4AD3F64F.6070908@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <4AD3F64F.6070908@sauce.co.nz>
Sender: linux-raid-owner@vger.kernel.org
To: Richard Scobie <richard@sauce.co.nz>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Richard Scobie wrote:
> mark delfman wrote:
>> Hi... in recent tests we are seeing a 50% drop in performance from
>> XFS>MD on a 2.6.30 kernel (compared to a 2.6.28 kernel)
>
>
> Richard Scobie wrote:
> > Started testing a similar machine yesterday - 12GB RAM LSI SAS
> > controller and 16 x WD RE3 1TB SATA md RAID6.
> >
> > With stripe cache set to 16384, I see dd writes of around 290MB/s and
> > when bumped up to 32768 (the maximum), it increases to 407MB.
>
> An omission to the above - the machine is running 
> kernel-2.6.30.8-64.fc11.x86_64.

That performance is amazing for me. With 2.6.31 kernel and 
stripe_cache_size 32768 I got around 185MB/sec dd writes (bs=1M) though 
xfs (or 400MB/sec dd to the device directly). My machine was a dual xeon 
5430 and about 13 SATA Hitachi 7200 rpm disks, MD raid-5, chunk size 
1MB, anticipatory scheduler, no LVM. The controller was a 3ware 9650-16ML .
Do you think it was controller's overhead? I have heard mixed opinions 
about 3wares. What are the fastest controllers around for MD-raid use?

Thank you
