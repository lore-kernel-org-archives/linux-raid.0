From: Neil Brown <neilb@suse.de>
Subject: Re: RAID1 extreme low performance
Date: Tue, 16 Dec 2008 13:35:23 +1100
Message-ID: <18759.5099.172915.369111@notabene.brown>
References: <26c008d70812120447kb91f8a1x6747bf5d4c7cfc0c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Federico on Friday December 12
Sender: linux-raid-owner@vger.kernel.org
To: Federico <undicizeri@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday December 12, undicizeri@gmail.com wrote:
> I all,
> a couple of weeks ago I've updated the kernel (now I'm using .27-7)
> and mdadm to version 2.6.7 and now I have terrible RAID1 performance:
> during I/O operation I have 100% cpu utilization and all the system
> freeze until the operation ends. Seeking and reading from the RAID is
> extremely slow (sometime 4 or 5 seconds just to show an "ls -l"
> output) and writing is even worst.
> I've tested the same hard disk without RAID and It seem working well.

What filesystem are you using on the RAID?
If you disable barriers (maybe -o barriers=0 or -o nobarriers) does
that change the performance?

NeilBrown
