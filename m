From: NeilBrown <neilb@suse.de>
Subject: Re: iostat with raid device...
Date: Sat, 9 Apr 2011 09:46:29 +1000
Message-ID: <20110409094629.2eae2d5b@notabene.brown>
References: <BANLkTi=6uvCsQTpCi4xLUWzx5X7o99_=5g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTi=6uvCsQTpCi4xLUWzx5X7o99_=5g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux Raid Study <linuxraid.study@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 8 Apr 2011 12:55:39 -0700 Linux Raid Study
<linuxraid.study@gmail.com> wrote:

> Hello,
> 
> I have a raid device /dev/md0 based on 4 devices sd[abcd].

Would this be raid0? raid1? raid5? raid6? raid10?
It could make a difference.

> 
> When I write 4GB to /dev/md0, I see following output from iostat...

Are you writing directly to the /dev/md0, or to a filesystem mounted
from /dev/md0?  It might be easier to explain in the second case, but you
text suggests the first case.

> 
> Ques:
> Shouldn't I see write/sec to be same for all four drives? Why does
> /dev/sdd always have higher value for  BlksWrtn/sec?
> My strip size is 1MB.
> 
> thanks for any pointers...
> 
> avg-cpu:  %user   %nice %system %iowait  %steal   %idle
>            0.02    0.00    0.34    0.03    0.00   99.61
> 
> Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
> sda               1.08       247.77       338.73   37478883   51237136
> sda1              1.08       247.77       338.73   37478195   51237136
> sdb               1.08       247.73       338.78   37472990   51245712
> sdb1              1.08       247.73       338.78   37472302   51245712
> sdc               1.10       247.82       338.66   37486670   51226640
> sdc1              1.10       247.82       338.66   37485982   51226640
> sdd               1.09       118.46       467.97   17918510   70786576
> sdd1              1.09       118.45       467.97   17917822   70786576
> md0              65.60       443.79      1002.42   67129812  151629440

Doing the sums, for every 2 blocks written to md0 we see 3 blocks written to
some underlying device.  That doesn't make much sense for a 4 drive array.
If we assume that the extra writes to sdd were from some other source, then
It is closer to a 3:4 ratio which suggests raid5.
So I'm guessing that the array is newly created and is recovering the data on
sdd1 at the same time as you are doing the IO test.
This would agree with the observation that sd[abc] see a lot more reads than
sdd.

I'll let you figure out the tps number.... do the math to find out the
average blk/t number for each device.

NeilBrown


> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

