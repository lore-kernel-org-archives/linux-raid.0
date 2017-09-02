From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: Re: Superblock Missing
Date: Sat, 2 Sep 2017 03:43:33 +0200
Message-ID: <20170902014333.GA26507@metamorpher.de>
References: <CAANkkp+3WwZvKu60LkU_0VpxZvZuNrrE=qDt=4DPc80AO+sgEg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAANkkp+3WwZvKu60LkU_0VpxZvZuNrrE=qDt=4DPc80AO+sgEg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Mitchell <mr.david.mitchell@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Sep 01, 2017 at 08:52:23PM -0400, David Mitchell wrote:
> # mdadm --examine /dev/md0
> mdadm: No md superblock detected on /dev/md0.

Everyone will assume user error at this point.
/dev/md0 is not supposed to have a mdadm superblock to examine.
It has a filesystem or LUKS or LVM header or whatever it is you do.

For --examine you have to provide one or more member devices.

You can do mdadm --detail /dev/md* or mdadm --examine /dev/sd*.

> Requested from "When Things Go Wrong"
> 
> -------------------------------------
> # mdadm --examine /dev/sd[cde]1
> /dev/sdc1:
>           Magic : a92b4efc
>         Version : 1.2

Oh look. There it is. Your superblock...

Other than that I see no problems. Your Load Cycle Counts are high 
and for WD there are tools to finetune that behaviour but it's 
unclear whether that's actually a real problem.

> SMART Extended Self-test Log Version: 1 (1 sectors)
> Num  Test_Description    Status                  Remaining
> LifeTime(hours)  LBA_of_first_error
> # 1  Short offline       Completed without error       00%         0         -

Consider running smart tests more regularly.

Regards
Andreas Klauer
