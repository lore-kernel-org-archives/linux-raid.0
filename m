From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: modifying a running array
Date: Tue, 16 Nov 2004 08:55:35 +1100
Message-ID: <16793.9687.599335.482097@cse.unsw.edu.au>
References: <1100522100.31575.12.camel@xstar>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Lieven Van Acker on Monday November 15
Sender: linux-raid-owner@vger.kernel.org
To: Lieven Van Acker <lieven.vanacker@ugent.be>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday November 15, lieven.vanacker@ugent.be wrote:
> Hey folks,
> 
> I didn't find any direct pointers on this issue, so maybe you experts
> can advice me...
> 
> I was setting up a system, had only one disk at setup time but wanted to
> configure raid 1 in advance...
> 
> so I used 
> 
> mdadm --create /dev/md0 --force --run --level=1 --raid-devices=1
> /dev/sda1
> 
> to create my array.
> 
> Now as I have the second disk available, after duplicating the partition
> table I wanted to add add /dev/sdb1 to the array. 
> 
> But 
> 
> mdadm /dev/md0 -a /dev/sdb1 
> 
> adds this device as a spare one, so the number of active devices stays
> 1. I could use the build command to reinitialise the array, but I wonder
> if there's a way to extend the raiddevice while it's running?


If you are running a recent 2.6 kernel and have a recent mdadm, then

  mdadm --grow /dev/md0 --raid-devices 2

will convert /dev/md0 to a 2 device raid1 array, and the spare will
start being reconstructed.

NeilBrown
