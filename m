From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Linux Software RAID 5 + XFS Multi-Benchmarks / 10 Raptors
 Again
Date: Fri, 18 Jan 2008 10:58:40 -0500 (EST)
Message-ID: <alpine.DEB.0.999999.0801181057260.23565@p34.internal.lan>
References: <alpine.DEB.0.999999.0801161105510.16168@p34.internal.lan>  <29a863790801180735n379a27f1t4987686b2ec1aa50@mail.gmail.com>  <alpine.DEB.0.999999.0801181036260.23565@p34.internal.lan> <29a863790801180743y2e90e37aj70c556dc9192a15d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <29a863790801180743y2e90e37aj70c556dc9192a15d@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Greg Cormier <gcormier@gmail.com>
Cc: linux-raid@vger.kernel.org, xfs@oss.sgi.com, Alan Piszcz <ap@solarrain.com>
List-Id: linux-raid.ids



On Fri, 18 Jan 2008, Greg Cormier wrote:

>> Also, don't use ext*, XFS can be up to 2-3x faster (in many of the
>> benchmarks).
>
> I'm going to swap file systems and give it a shot right now! :)
>
> How is stability of XFS? I heard recovery is easier with ext2/3 due to
> more people using it, more tools available, etc?
>
> Greg
>

Recovery is actually easier with XFS because the repair filesystem code is 
built-into the kernel (you dont need a utility to fix it)-- however, there 
is xfs_repair (if) the in-kernel-tree part could not fix it.

I have been using it for > 4-5 years? now.

Also, with CoRaids (ATA over Ethernet) many of them are above 8TB and ext3 
only works up to 8TB, so its not even an option any longer.

Justin.
