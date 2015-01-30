From: Xiao Ni <xni@redhat.com>
Subject: Re: RAID1 removing failed disk returns EBUSY
Date: Thu, 29 Jan 2015 23:27:28 -0500 (EST)
Message-ID: <465271024.2463445.1422592048355.JavaMail.zimbra@redhat.com>
References: <20141027162748.593451be@jlaw-desktop.mno.stratus.com> <2054919975.10444188.1421385612513.JavaMail.zimbra@redhat.com> <20150116101031.30c04df3@jlaw-desktop.mno.stratus.com> <1924199853.11308787.1421634830810.JavaMail.zimbra@redhat.com> <20150119125650.22a75dd3@jlaw-desktop.mno.stratus.com> <1063248306.12205209.1421738206544.JavaMail.zimbra@redhat.com> <20150123101129.5c56dd6e@jlaw-desktop.mno.stratus.com> <1282724195.2440807.1422584341926.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1282724195.2440807.1422584341926.JavaMail.zimbra@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Joe Lawrence <joe.lawrence@stratus.com>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org, Bill Kuzeja <william.kuzeja@stratus.com>
List-Id: linux-raid.ids



----- Original Message -----
> From: "Xiao Ni" <xni@redhat.com>
> To: "Joe Lawrence" <joe.lawrence@stratus.com>
> Cc: "NeilBrown" <neilb@suse.de>, linux-raid@vger.kernel.org, "Bill Kuzeja" <william.kuzeja@stratus.com>
> Sent: Friday, January 30, 2015 10:19:01 AM
> Subject: Re: RAID1 removing failed disk returns EBUSY
> 
> 
> 
> ----- Original Message -----
> > From: "Joe Lawrence" <joe.lawrence@stratus.com>
> > To: "Xiao Ni" <xni@redhat.com>
> > Cc: "NeilBrown" <neilb@suse.de>, linux-raid@vger.kernel.org, "Bill Kuzeja"
> > <william.kuzeja@stratus.com>
> > Sent: Friday, January 23, 2015 11:11:29 PM
> > Subject: Re: RAID1 removing failed disk returns EBUSY
> > 
> > On Tue, 20 Jan 2015 02:16:46 -0500
> > Xiao Ni <xni@redhat.com> wrote:
> > > Joe
> > > 
> > >    Thanks for the explanation. So echo "idle" to sync_action is a
> > >    workaround
> > > without the patch.
> > >  
> > >    It looks like the patch is not enough to fix the problem.
> > > Do you have a try with the new patch? Is the problem still exist in
> > > your environment?
> > > 
> > >    If your environment have no problem, can you give me the version
> > >    number?
> > >    I'll
> > > have a try with the same version too.
> > 
> > Hi Xiao,
> > 
> > Bill and I did some more testing yesterday and I think we've figured
> > out the confusion.  Running a 3.18+ kernel and an upstream mdadm, it
> > was the udev invocation of "mdadm -If <dev>" that was automatically
> > removing the device for us.
> > 
> > If we ran with an older mdadm and got the MD wedged in the faulty
> > condition, then nothing we echoed into the sysfs state file ('idle'
> > 'fail' or 'remove')  would change anything.  I think this agrees with
> > your testing report.
> > 
> > So two things:
> > 
> > 1 - Did you make / make install the latest mdadm and see it try to run
> > mdadm -If on the removed disk?  (You could also try manually running
> > it.)
> 
>   I make sure I have install the latest mdadm
>   [root@dhcp-12-133 ~]# mdadm --version
>   mdadm - v3.3.2-18-g93d3bd3 - 18th December 2014
> 
>   It can prove this, right?
> 
>   It's strange when I ran mdadm -If
> 
> [root@dhcp-12-133 ~]# mdadm -If sdc
> mdadm: sdc does not appear to be a component of any array
> [root@dhcp-12-133 ~]# cat /proc/mdstat
> Personalities : [raid1]
> md0 : active (auto-read-only) raid1 sdd1[1] sdc1[0](F)
>       5238784 blocks super 1.2 [2/1] [_U]
>       
> unused devices: <none>
> 
>   I unplug the device manually from the machine. The machine is on my desk.

Hi Joe

   Sorry for this. I input the command wrongly.

[root@dhcp-12-133 ~]# mdadm -If sdc1
mdadm: set sdc1 faulty in md0
mdadm: hot remove failed for sdc1: Device or resource busy

> 
> 
> > 
> > 2 - I think the sysfs interface to the removed disks is still broken in
> > cases where (1) doesn't occur.
> > 
> > Thanks,
> > 
> > -- Joe
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
