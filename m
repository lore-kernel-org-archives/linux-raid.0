From: "Michael" <michael@insulin-pumpers.org>
Subject: Re: Booting from a raid1 device ?
Date: Tue, 28 Oct 2003 08:23:21 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200310281623.h9SGNG229162@bzs.org>
References: <200310272311.19232.dusty@strike.wu-wien.ac.at>
Reply-To: michael@insulin-pumpers.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <20031028105644.GF30725@marowsky-bree.de>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> On 2003-10-27T23:11:19,
>    Hermann Himmelbauer <dusty@strike.wu-wien.ac.at> said:
> 
> > BTW, assuming I have md.o not as module but statically in the kernel, which 
> > bootloader would support RAID1? I heard LlLO does this job but does also grub 
> > - which I prefer - support Linux SW-RAID1?
> 
> grub doesn't yet afaik.
> 
> > What about RAID5? Is there any bootloader that supports it?
> 
> No.
> 

The appropriate solution is to put an 8-16 meg partition as the first 
partition on the first two drives (all the drives) in the system. Set 
those up as raid one and mount them on /boot. Use these as the boot 
boot partitions in a mostly raid 5 system. Likewise, segment swap 
partitions into pairs on the raid5 disk set and create raid 1 arrays 
for swap

Michael
