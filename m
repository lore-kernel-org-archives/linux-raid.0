From: comsatcat <comsatcat@earthlink.net>
Subject: RE: Busted disks caused healthy ones to fail
Date: Tue, 14 Dec 2004 01:28:57 -0700
Message-ID: <1103012937.8162.23.camel@solaris.skunkware.org>
References: <200412140655.iBE6tv908270@www.watkins-home.com>
Reply-To: comsatcat@earthlink.net
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200412140655.iBE6tv908270@www.watkins-home.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guy <bugzilla@watkins-home.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The two disks that were actually dead were both on a different bus.  The
OS disk that died was on scsi0.

Is there a way around this behavior (ie: kernel params that can be
adjusted such as timeout values and queuing)?  It never really recovered
correctly after the disks died, a manual reboot as required.
Applications which were using the failed devices would hang forever (I'm
assuming they were waiting for queued commands to complete).

IDE: not in use
Power: 14 internal drives, no external
Temp: fust fine
Kids: Upstairs taking tech calls.


Thanks,
Ben


On Tue, 2004-12-14 at 01:55 -0500, Guy wrote:
> Did the disks that failed have anything in common?
> 
> SCSI:
> If you have disks on 1 SCSI bus, a single failed disk can affect other
> disks.  By removing the bad disk you correct the problems with the others.
> 
> IDE:  (or what ever they call it today)
> 2 disks on 1 bus, 1 drive failure will cause the other to fail most of the
> time.
> 
> Power supply:
> If you have external disks, they will have another power supply.  If you
> have problems with this power supply, they all could be affected.  Even a
> common power cable can cause multi drive failures.
> 
> Temperature:
> Disks getting too hot can cause failures.
> 
> Kids:
> Someone turned the disk cabinet off?
> 
> I am sure this list is not complete.  But it may help.
> 
> Guy
> 
> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org
> [mailto:linux-raid-owner@vger.kernel.org] On Behalf Of comsatcat
> Sent: Tuesday, December 14, 2004 1:42 AM
> To: linux-raid@vger.kernel.org
> Subject: Busted disks caused healthy ones to fail
> 
> An odd thing happened this weekend.  We were doing some heavy I/O when
> one of our servers had two drives in two seperate raid1 mirrors pop.
> This was not odd as these drives are old and the batch they are from
> have been failing on other boxen as well.  What is odd is that our brand
> new disks which the OS resides on (2 drives in raid 1) half busted.
> 
> There are 4 md devices
> 
> md/0  
> md/1
> md/2
> md/3
> 
> md3, md2, and md1 all lost the 2nd drive in the array (sdh3, sdh6, and
> sdh5).  md0 however was fine with sdh1 being fine.  Why would losing
> disks cause a seemingly healthy disk to go astray?
> 
> P.S. I have pull out tons of syslogs showing the two bad disks failing
> if that would help.
> 
> 
> Thanks,
> Ben
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

