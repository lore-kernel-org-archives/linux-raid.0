From: Janek Kozicki <janek_listy@wp.pl>
Subject: Re: Using 2.6.31 liveCD to grow (reshape) raid5 into raid6, then
 bacck to old kernel?
Date: Fri, 13 Nov 2009 10:08:38 +0100
Message-ID: <20091113100838.5ee6fc1d@atak.bl.pg.gda.pl>
References: <20091112220351.22a2ad1b@atak.bl.pg.gda.pl>
	<19196.57969.529323.360914@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <19196.57969.529323.360914@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown said:     (by the date of Fri, 13 Nov 2009 15:37:05 +1100)

> > And so my plan is to get some liveCD with 2.6.31 (or maybe 2.6.32 ?).
> > Connect the sixth drive, boot liveCD, perform the migration:
> > 
> > mdadm --add /dev/md2 /dev/sdd3
> > mdadm --grow /dev/md2 --level=raid6 --raid-disks=6
> > 
> > Then reboot back into linux 2.6.24.
> > 
> > Will this work?
> 
> In principle, yes.
> However:
>   1/ you need linux 2.6.32 (not yet released).  Don't try with 2.6.31
>   2/ you need mdadm 3.1.1 (not yet released).  Don't try with 3.1,
>      which has been withdrawn.
>   3/ You need a "--backup-file=/some/file" argument.  The /some/file
>      must be on a different device.
>   
> > 
> > Will 2.6.24 understand such raid6 ?
> 
> Yes.
>   mdadm will first convert the RAID5 to a RAID6 in which the Q blocks
>   are all on the last disk.  This is done instantly.
>   Then mdadm will start and manage a process of re-laying out each
>   stripe to have the Q blocks rotated around the various devices.
>   This will take a while, approximately 1 day.  Once this is complete,
>   you can then access the array from 2.6.24.
> 
> NeilBrown


Great, thanks a lot! I'm not in such a hurry - I will wait until they
are released.


-- 
Janek Kozicki                                                         |
