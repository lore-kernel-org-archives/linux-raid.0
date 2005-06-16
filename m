From: raz ben jehuda <razb@bitband.com>
Subject: Re: sata_nv and RAID1
Date: Thu, 16 Jun 2005 09:43:00 +0300
Message-ID: <1118904180.3079.5.camel@raz-laptop>
References: <200506111613.42962.dvadell@lantech.com.ar>
	 <200506131841.32850.dvadell@lantech.com.ar>
	 <1118818568.3089.5.camel@raz-laptop>
	 <200506151427.09114.dvadell@lantech.com.ar>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200506151427.09114.dvadell@lantech.com.ar>
Sender: linux-raid-owner@vger.kernel.org
To: "Diego M. Vadell" <dvadell@lantech.com.ar>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

"didn't fail" means that the raid entered into degraded mode. in
/proc/mdstats you would notice that the disk is faulty.
I have a root file system over raid1 and I could not allow myself 
letting the operating system hang, so i added it. 
This is not the best solution and the maintainers of the code would
disapprove it since it is not complete.But for myself it is suffice.   

On Wed, 2005-06-15 at 17:27, Diego M. Vadell wrote:
> Hi Raz,
>    My english is not good enough. When you say "And the raid1 didn't fail", 
> did you mean it worked as expected, entering degraded mode, or that it failed 
> to enter in degraded mode?
>    Also, is there any reason why you didnt send this also to the mailling 
> list? Maybe it's useful to somebody else.
> 
>   Thank you very much for your mail. I dont know if I will be able to test it, 
> as the server is in it's way to production , but if I can, I will give it a 
> try.
> 
>  -- Diego.
> 
> On Wednesday 15 June 2005 06:56, you wrote:
> > I had the same problem.I added at the end ata_scsi_error the following
> > command:
> > ata_port_disable(ap);
> > And the raid1 didn't fail. I didn't get the hotswap so rebooting is
> > necessary and then you raidhotadd the new disk.
> > Also, before hotadd type :
> > echo 1000 > /proc/sys/dev/raid1/speed_limit_max
> > so your system won't be too busy with ios.
> >
> > On Tue, 2005-06-14 at 00:41, Diego M. Vadell wrote:
> > > On Monday 13 June 2005 18:20, you wrote:
> > > > You need to go into the SCSI layer and figure out how to do it.
> > > >
> > > > Calling scsi_remove_device() in the appropriate place is a good start.
> > > > Add a debounce timer.  Make sure all commands are completed with an
> > > > error (avoids memory leaks and lock-ups).  Other details.
> > > >
> > > > Hot unplug is not just a simple function call...
> > > >
> > > >  Jeff
> > >
> > > thank you Jeff! I dont think I will be able to do it, though. Thank you
> > > for the fast answers.
> > >
> > >  -- Diego.
> > > -
> > > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Raz
Long Live The Penguin

