From: comsatcat <comsatcat@earthlink.net>
Subject: Re: Busted disks caused healthy ones to fail
Date: Tue, 14 Dec 2004 15:34:12 -0700
Message-ID: <1103063653.8740.0.camel@solaris.skunkware.org>
References: <200412140655.iBE6tv908270@www.watkins-home.com>
	 <1103012937.8162.23.camel@solaris.skunkware.org>
	 <41BEF49F.5010907@pobox.com>
Reply-To: comsatcat@earthlink.net
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <41BEF49F.5010907@pobox.com>
Sender: linux-raid-owner@vger.kernel.org
To: mjstumpf@pobox.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Not 1, 3 power supplys.

On Tue, 2004-12-14 at 08:11 -0600, Michael Stumpf wrote:
> 14 Internal drives on a single power supply plus the mb/cpu/etc?  Oy; 
> I've got 15 + a p2-400 spinning between 2 550w power supplies, and I'm 
> worried it is getting overloaded.  I might be paranoid, but I had some 
> flakiness that was pretty much impossible to debug, so I took broad 
> steps and overestimated.  Figured that maybe a heavily loaded supply 
> could hiccup under an unusual condition if too many were attached to 
> one..  and, while anecdotal, my once-a-month drive hiccup (require 
> re-add to array, nothing else) problem did go away when I added a power 
> supply.
> 
> comsatcat wrote:
> 
> >The two disks that were actually dead were both on a different bus.  The
> >OS disk that died was on scsi0.
> >
> >Is there a way around this behavior (ie: kernel params that can be
> >adjusted such as timeout values and queuing)?  It never really recovered
> >correctly after the disks died, a manual reboot as required.
> >Applications which were using the failed devices would hang forever (I'm
> >assuming they were waiting for queued commands to complete).
> >
> >IDE: not in use
> >Power: 14 internal drives, no external
> >Temp: fust fine
> >Kids: Upstairs taking tech calls.
> >
> >
> >Thanks,
> >Ben
> >
> >
> >On Tue, 2004-12-14 at 01:55 -0500, Guy wrote:
> >  
> >
> >>Did the disks that failed have anything in common?
> >>
> >>SCSI:
> >>If you have disks on 1 SCSI bus, a single failed disk can affect other
> >>disks.  By removing the bad disk you correct the problems with the others.
> >>
> >>IDE:  (or what ever they call it today)
> >>2 disks on 1 bus, 1 drive failure will cause the other to fail most of the
> >>time.
> >>
> >>Power supply:
> >>If you have external disks, they will have another power supply.  If you
> >>have problems with this power supply, they all could be affected.  Even a
> >>common power cable can cause multi drive failures.
> >>
> >>Temperature:
> >>Disks getting too hot can cause failures.
> >>
> >>Kids:
> >>Someone turned the disk cabinet off?
> >>
> >>I am sure this list is not complete.  But it may help.
> >>
> >>Guy
> >>
> >>-----Original Message-----
> >>From: linux-raid-owner@vger.kernel.org
> >>[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of comsatcat
> >>Sent: Tuesday, December 14, 2004 1:42 AM
> >>To: linux-raid@vger.kernel.org
> >>Subject: Busted disks caused healthy ones to fail
> >>
> >>An odd thing happened this weekend.  We were doing some heavy I/O when
> >>one of our servers had two drives in two seperate raid1 mirrors pop.
> >>This was not odd as these drives are old and the batch they are from
> >>have been failing on other boxen as well.  What is odd is that our brand
> >>new disks which the OS resides on (2 drives in raid 1) half busted.
> >>
> >>There are 4 md devices
> >>
> >>md/0  
> >>md/1
> >>md/2
> >>md/3
> >>
> >>md3, md2, and md1 all lost the 2nd drive in the array (sdh3, sdh6, and
> >>sdh5).  md0 however was fine with sdh1 being fine.  Why would losing
> >>disks cause a seemingly healthy disk to go astray?
> >>
> >>P.S. I have pull out tons of syslogs showing the two bad disks failing
> >>if that would help.
> >>
> >>
> >>Thanks,
> >>Ben
> >>
> >>-
> >>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> >>the body of a message to majordomo@vger.kernel.org
> >>More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>
> >>-
> >>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> >>the body of a message to majordomo@vger.kernel.org
> >>More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>    
> >>
> >
> >-
> >To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> >the body of a message to majordomo@vger.kernel.org
> >More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> >
> >  
> >
> 
> 
> --------------------------------------------
> My mailbox is spam-free with ChoiceMail, the leader in personal and corporate anti-spam solutions. Download your free copy of ChoiceMail from www.choicemailfree.com
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

