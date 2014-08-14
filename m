From: Ethan Wilson <ethan.wilson@shiftmail.org>
Subject: Re: How to use --freeze-reshape  and is it safe?
Date: Thu, 14 Aug 2014 15:51:58 +0200
Message-ID: <53ECBEFE.2090109@shiftmail.org>
References: <53EC4B63.90703@gmail.com> <20140814155633.567baece@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140814155633.567baece@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 14/08/2014 07:56, NeilBrown wrote:
> ....
>
> As --freeze-reshape is only meaningful in combination with --assemble,
> this question doesn't really make sense.
>
> If you are using a sufficiently new kernel and mdadm so that "data_offset" is
> adjusted during reshapes so that no 'backup' is needed, then you can
> suspend a reshape for a period of time by:
>
>    echo frozen > /sys/block/mdXXX/md/sync_action
>
> This is perfectly safe.  When you want to unfreeze, write 'idle'
> to 'sync_action'.  md will notice that a reshape is pending and will restart
> where it was up to.
>
> .....
>
> Is it really that esoteric?
> If you want to reshape an array, you run "mdadm --grow" and list all the
> changes you want to make.  Set a new level, a new number of devices, a new
> layout, a new chunk size, whatever.  mdadm will do it if it can and give an
> error if it cannot.
> If you want to test it out first then that is extremely sensible.  Make some
> loop devices and experiment.

I also was interested in the functioning of reshape, and it never was 
completely clear to me.

Do you confirm that the manpage for --freeze-reshape is correct?

        --freeze-reshape
               Option  is  intended  to  be  used  in  start-up scripts 
during initrd boot phase.  When array under reshape is assembled during 
initrd phase, this option stops reshape after
               reshape critical section is being restored. This happens 
before file system pivot operation and avoids loss of file system 
context.  Losing file system  context  would  cause
               reshape to be broken.

"would cause reshape to be broken" means complete data loss?

So, to be safe in case of power loss during reshape, we have to make 
absolutely sure that our Linux distribution implements the 
--freeze-reshape before pivot_root ?

I think Ubuntu doesn't do that. Debian probably also doesn't.

Is the reshape operation supposed to be safe with regard to power loss 
(supposing the distro implements --freeze-reshape) ?

Is the --freeze-reshape needed only when there is a backup file, or even 
with newer kernels (>= 3.5) and mdadm (>= 3.3) and no backup file ?

If mdadm lets me initiate a reshape without specifying a backup file, 
does it mean that it has checked that in my case it is safe?

Thank you
EW
