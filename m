From: Dave Fisher <davef@davefisher.co.uk>
Subject: Re: RAID 10 array won't assemble ... spare ... metadata - Disappointing Report Back
Date: Sat, 18 Apr 2009 21:13:28 +0100
Message-ID: <20090418201328.GC18440@davefisher.co.uk>
References: <20090417141402.GB27042@davefisher.co.uk> <18921.1283.548260.293728@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <18921.1283.548260.293728@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Apr 18, 2009 at 08:38:59AM +1000, Neil Brown wrote:
> So:
> 
>   mdadm -S /dev/md1
>   mdadm -A /dev/md1 -fv /dev/sd[abcde]4
> 
> and report the result.

Output transcribed by hand:

    mdadm: looking for devices for /dev/md1
    mdadm: /dev/sda4 is identified as a member of /dev/md1 slot 0
    mdadm: /dev/sdb4 is identified as a member of /dev/md1 slot 1
    mdadm: /dev/sdc4 is identified as a member of /dev/md1 slot 2
    mdadm: /dev/sdd4 is identified as a member of /dev/md1 slot 3
    mdadm: /dev/sde4 is identified as a member of /dev/md1 slot 4
    mdadm: forcing event count in /dev/sdb4(1) from 219 upto 221

But when I ran mdadm -E on each of the partitions the counts were
competely unchanged, i.e. sd[bcde]4 were still all at 219.

sda4 was still at 221

Everything else looked exactly the same, including the summary tables at
the end.

Any thoughts?

Do I need to start/run the array to affect the changes?

Dave
