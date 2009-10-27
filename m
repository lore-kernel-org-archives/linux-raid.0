From: adfas asd <chimera_god@yahoo.com>
Subject: Re: Is My Data DESTROYED?!
Date: Tue, 27 Oct 2009 13:53:32 -0700 (PDT)
Message-ID: <577070.18599.qm@web38807.mail.mud.yahoo.com>
References: <4AE75BDB.1020908@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AE75BDB.1020908@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

You're not understanding.

I plan for the **storage server** to mount the RAID0 volume on the HTPC (shared), so the **storage server** can do all backup and checking operations.  This should be a job for the storage server, not the HTPC.  The HTPC should/will perform all video duties.

And NFS/Samba are out.  O-U-T, OUT.  Old-and-busted.  Useful like a washboard.  Many years ago I vowed that I would never learn two things:  automatic transmissions, and NFS.  I did learn and use Samba for some years, but now it is old-and-busted.  sshfs has served me well over the past year and a half, under rigorous conditions.  It is limited though by CPU consumption for encryption.  This is why I will investigate clustering filesystems and FUSE options.


--- On Tue, 10/27/09, Bill Davidsen <davidsen@tmr.com> wrote:
> One more time, if you mount the backup copy on the main
> server it will then be subject to the same failure issues as
> a mirror. You want to use something like rsync to backup
> over network, and the function of the backup server isn't
> going to be to serve other than in case of emergency. You
> don't want to serve, to mount, to do anything which will let
> filesystem, OS, or user errors propagate to the backup
> copy.
> 
> Other than the reliability issue if you mount, there's no
> reason to avoid things like NFS, they are well tested but
> not stagnant, getting significant upgrades a few years ago
> and regular minor glitch fixes for corner cases. In general
> cutting edge and reliable is not the most probable
> combination. While NFS is widely used and maintained,
> protocols like AFS, iSCSI and sshfs are used by fewer sites,
> and perhaps more experienced administrators, so perhaps they
> are less tested, particularly in the area of less than
> optimal setup.
> 
> Boring and uneventful is what you want in a backup system.
> 
> -- Bill Davidsen <davidsen@tmr.com>
>  Unintended results are the well-earned reward for
> incompetence.
> 
> 


      
