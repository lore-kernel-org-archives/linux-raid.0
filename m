From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: slow mdadm reshape, normal?
Date: Thu, 11 Jun 2009 00:04:38 +0100
Message-ID: <4A303C06.9080409@anonymous.org.uk>
References: <20090610224055.GW30825@rlogin.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090610224055.GW30825@rlogin.dk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/06/2009 23:40, Michael Ole Olsen wrote:
> is it normal that a raid5 reshape happens at only 7000kB/s on
> newer disks? i created the array at 60MB/s stable over the whole array
> (accordin to /proc/mdstat), sometimes up to 90MB/s
> 
> chunk size is 64kB, disks are 9xst1500 (1.5tb seagate with upgraded 
> firmware CC1H /SD1A)
> 
> the hardware is a pci 32bit 4port sata and onboard sata2 (6 port sata - non
> ide host board) if that explains it?
> 
> modules are sata_nv and sata_sil
> 
> I have lvm2 and xfs+2TB data on top of md before the growing of two new 
> disks from 7 to 9.

I wonder if this is the same issue as in another thread this evening[1]: 
too many drives competing for the very limited bandwidth available on 
the PCI bus? Your extra discs, are they attached to the PCI SATA card? 
How many drives are there on there?

Cheers,

John.


[1] http://marc.info/?l=linux-raid&m=124466834109307&w=2
