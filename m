From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: RAID5 Not coming back up after crash
Date: Tue, 30 Nov 2004 16:45:24 +1100
Message-ID: <16812.2292.774718.891472@cse.unsw.edu.au>
References: <200411292229.iATMTpN06996@www.watkins-home.com>
	<41AC0740.9060508@wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from B. J. Zolp on Monday November 29
Sender: linux-raid-owner@vger.kernel.org
To: "B. J. Zolp" <bjzolp@wisc.edu>
Cc: Guy <bugzilla@watkins-home.com>, 'BERNARD JOHN ZOLP' <bjzolp@students.wisc.edu>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday November 29, bjzolp@wisc.edu wrote:
> I found a spare new drive that I copied hdj1 onto and put the new drive 
> on the proper IDE cable for hdj.  Then tried running the mdadm -A 
> /dev/md0 --force /dev/hda1 /dev/hdc1 /dev/hdd1 /dev/hdi1 /dev/hdj1
> But it seg faults.  Should I try the  mkraid --force 
> --dangerous-no-resync /dev/md0   ???
> 

which version of mdadm segfaults? 
If you aren't using 1.8.0, use that.

NeilBrown
