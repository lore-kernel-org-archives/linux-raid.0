From: NeilBrown <neilb@suse.de>
Subject: Re: Cancel reshape?
Date: Wed, 12 Jan 2011 15:49:05 +1100
Message-ID: <20110112154905.66f5f37f@notabene.brown>
References: <4D2D2BD2.7000601@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D2D2BD2.7000601@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, 12 Jan 2011 04:19:30 +0000 John Robinson
<john.robinson@anonymous.org.uk> wrote:

> I've just started reshaping a RAID-5 to a RAID-6. I had meant to 
> increase the number of drives too, so avoiding using the backup file all 
> the way through. Unfortunately I forgot to specify that, so it's going 
> rather slowly. I said:
> 
> mdadm /dev/md1 --grow --level=6 --backup-file=/some/where/else
> 
> where md1 had 3 active and 2 spare devices. It's now reshaping itself to 
> RAID-6 with 4 active and 1 spare.
> 
> What I meant was
> 
> mdadm /dev/md1 --grow --level=6 --raid-disks=5 --backup-file=...
> 
> Can I cancel reshape that's currently running, and using the backup file 
> that's actually on another (RAID-1) array on three of the same drives, 
> and running at ~7MB/s, and try again?
> 
Sorry, but no.  This isn't supported yet.
It would require modification to the kernel to be able to run a reshape in
reverse.

NeilBrown

