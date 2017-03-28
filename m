From: pdi <pdi@otenet.gr>
Subject: Re: constant array_state active after specific jobs
Date: Tue, 28 Mar 2017 16:44:40 +0300
Message-ID: <20170328164440.4d57afa9@hal9.pdi.lan>
References: <20170323104643.6cca7986@hal9.pdi.lan>
        <8737e39rg0.fsf@notabene.neil.brown.name>
        <20170324090442.3d01347b@hal9.pdi.lan>
        <87lgrr8xt6.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87lgrr8xt6.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org, Shaohua Li <shli@kernel.org>
List-Id: linux-raid.ids

On Mon, 27 Mar 2017 09:42:29 +1100
NeilBrown <neilb@suse.com> wrote:

> On Fri, Mar 24 2017, pdi wrote:
> 
> > On Fri, 24 Mar 2017 16:25:35 +1100
> > NeilBrown <neilb@suse.com> wrote:
> >  
> >> On Thu, Mar 23 2017, pdi wrote:
> >>   
> >> > Greetings all,
> >> >
> >> > The problem in a nutshell is that an array is clean after boot,
> >> > until some specific jobs switch it to active where it remains
> >> > until reboot.
> >> >
> >> > A similar problem was discussed, and solved, in 
> >> > https://www.spinics.net/lists/raid/msg46450.html. However,
> >> > AFAICT, it is not the same issue.
> >> >
> >> > I would be grateful for any insights as to why this happens
> >> > and/or how to prevent it.
> >> >
> >> > The relevant info follows, please let me know if anything further
> >> > might help.
> >> >
> >> > Many thanks in advance.
> >> >
> >> > - uname -a
> >> >   Linux hostname 4.4.38 #1 SMP Sun Dec 11 16:03:41 CST 2016
> >> > x86_64 Intel(R) Core(TM)2 Duo CPU E8400 @ 3.00GHz GenuineIntel
> >> > GNU/Linux
> >> > - mdadm -V
> >> >   mdadm - v3.3.4 - 3rd August 2015
> >> > - Desktop drives without sct/erc,
> >> >   with timeout mismatch correction as per
> >> >   https://raid.wiki.kernel.org/index.php/Timeout_Mismatch
> >> > - /dev/md9 is a raid10 array, 4 devices, far=2,
> >> >   with various dirs used as samba and nfs shares
> >> > - The array is in *constant* array_state active
> >> > - mdadm -D /dev/md9 | grep 'State :'
> >> >   State : active
> >> > - cat /sys/block/md9/md/array_state
> >> >   active
> >> > - watch -d 'grep md9 /proc/diskstats'
> >> >   remain unchanged
> >> > - uptime
> >> >   load average: 0.00, 0.00, 0.00
> >> > - cat /sys/block/md9/md/safe_mode_delay
> >> >   0.201
> >> > - echo 0.1 > /sys/block/md9/md/safe_mode_delay
> >> >   array_state remains active
> >> > - echo clean > /sys/block/md9/md/array_state
> >> >   echo: write error: Device or resource busy
> >> > - reboot (with or without prior check)
> >> >   array_state clean
> >> > - After reboot, array remains clean until some specific
> >> >   jobs put it in constant active state. Such jobs so far
> >> >   identified:
> >> >   - echo check > /sys/block/md9/md/sync_action
> >> >   - run an rsnapshot job
> >> >   - start a qemu/kvm vm
> >> > - Other jobs, like text/doc editing, multimedia playback,
> >> >   etc retain array_state clean    
> >> 
> >> This bug was introduced by
> >> Commit: 20d0189b1012 ("block: Introduce new bio_split()")
> >> in 3.14, and fixed by
> >> Commit: 9b622e2bbcf0 ("raid10: increment write counter after bio is
> >> split") in 4.8.
> >> 
> >> Maybe the latter patch should be sent to -stable ??
> >> 
> >> NeilBrown  
> >
> > NeilBrown, thank you for your swift and concise answer.
> >
> > I gather you are referring to kernel version numbers. The described
> > behaviour was first noticed many months ago with kernel 2.6.37.6,
> > and persisted after a system upgrade and kernel 4.4.38. However,
> > after the upgrade two things were corrected, the timeout mismatch,
> > and a Current_Pending_Sector in one of the drives; which may, or
> > may not, explain the occurrence with the older kernel.
> >
> > Is this constant active state in the data array something to worry
> > about and try kernel >= 4.8, or shall I let be?  
> 
> The only important consequence of the constant active state is that if
> your machine crashes at a moment when the array would otherwise have
> been idle, then a resync will be needed after reboot.  Without the
> constant active state, that resync would not have been needed.
> 
> If you have a write-intent bitmap, this is not particularly relevant.
> 
> I cannot say how important it is to you to avoid a resync after a
> crash, so I don't know if you should just let it be or not.
> 
> NeilBrown

NeilBrown,

Thank you for your clear explanation.

Best regards,
pdi


