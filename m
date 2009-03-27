From: Neil Brown <neilb@suse.de>
Subject: Re: RAID1 write-behind not working?
Date: Fri, 27 Mar 2009 15:29:01 +1100
Message-ID: <18892.22029.923043.59931@notabene.brown>
References: <72dbd3150903251739q21de8a2ew835860f9e3b11d14@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from David Rees on Wednesday March 25
Sender: linux-raid-owner@vger.kernel.org
To: David Rees <drees76@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday March 25, drees76@gmail.com wrote:
> I picked up a SSD (30GB OCZ Vertex if you're curious) and am planning
> to set up a RAID1 with it and a SATA disk with the SATA disk in
> write-mostly mode along with write-behind enabled.
> 
> So I went to test it to make sure I had all the details correct on
> aligning the partition to a 128kB offset and the correct mdadm
> commands to create the array in write-mostly and write-behind, but I
> found that I couldn't get writes to "write-behind".  Essentially all
> writes would complete at the speed of the rotating disk.  Reads
> however worked great - they all appeared to be coming from the SSD.
> 
> I created the array with the following command:
> 
> mdadm --create /dev/md0 --raid-devices=2 --level=1 \
>   --bitmap=internal --write-behind /dev/sdb1 --write-mostly /dev/sda1

Hmmm... try with an external bitmap stored elsewhere on the SSD.
When you have bitmap=internal, bitmap updates are synchronous to all
devices.  Maybe that is causing the loss of speed that you see.

NeilBrown
