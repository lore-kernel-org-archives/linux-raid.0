From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Raid Array with 3.5Tb
Date: Fri, 16 Jan 2004 22:18:15 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16391.51319.698137.120756@notabene.cse.unsw.edu.au>
References: <1074196167.1382.8.camel@e-linux>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Evan Felix on Thursday January 15
To: Evan Felix <evan.felix@pnl.gov>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thursday January 15, evan.felix@pnl.gov wrote:
> I've been attempting to create a large raid 5 device using the linux
> 2.6.1 kernel, with the Large Block Device configured on.  I have in the
> system 16 250G disks.  I built an array with mdadm -C -n 15 -x 1
> /dev/md2 /dev/sd[a-p]
> 
> The resync/recovery seemed to be going fine, but at some point i started
> seeing:
> 
> kernel: compute_blocknr: map not correct
> kernel: compute_blocknr: map not correct
...
> 
> Has anyone else made an array this large? and does anybody have any
> pointers on where i can start looking at code to fix this?

I would look in  drivers/md/raid5.c and compute_blocknr() in that file.

I would change "chunk_number" to a sector_t and change:
	chunk_number = stripe * data_disks + i;
to read
	chunk_number = (sector_t)stripe * data_disks + i;

Possibly "stripe" and "chunk_number" should both be "sector_t", but
I'm not at all sure.

Please let me know if it helps.

NeilBrown

