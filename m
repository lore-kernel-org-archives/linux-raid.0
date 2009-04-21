From: Neil Brown <neilb@suse.de>
Subject: Re: [Patch] mdadm ignoring homehost?
Date: Tue, 21 Apr 2009 16:54:01 +1000
Message-ID: <18925.28041.731116.459343@notabene.brown>
References: <cccedfc60903240957j9314cb2k41d86cb78ec10b86@mail.gmail.com>
	<cccedfc60904010815h4056f55doebff4827705d231b@mail.gmail.com>
	<18899.61151.445765.360191@notabene.brown>
	<51C39605-BBE7-48E8-AB35-D55D0B36B3A6@redhat.com>
	<18919.64597.426128.498393@notabene.brown>
	<D6CEC060-43DC-40A5-A7EE-F2653DBA9C4C@redhat.com>
	<18924.8917.420265.477921@notabene.brown>
	<DA9036B3-2702-4783-92A5-3C46698F1CB3@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Doug Ledford on Monday April 20
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Jon Nelson <jnelson-linux-raid@jamponi.net>, LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Monday April 20, dledford@redhat.com wrote:
> On Apr 20, 2009, at 3:23 AM, Neil Brown wrote:
> > The kernel supports this.  We just need to make sure it works with
> > udev and get mdadm to use it.
> >
> > echo md_foo > /sys/modules/md_mod/parameters/new_array
> > ls -l /dev/md_foo
> >
> > no numbers at all.
> 
> Even in the output of /proc/mdstat?
> 

Yep.

# ls -l /dev/md_foo
brw-rw---- 1 root disk 9, 513 2009-04-21 16:50 /dev/md_foo
# cat /proc/mdstat 
Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4] [multipath] [faulty] 
md_foo : active raid1 sdf[0]
      156249920 blocks [1/1] [U]
# ls -ld /sys/block/md*
drwxr-xr-x 6 root root 0 2009-04-21 16:49 /sys/block/md127
drwxr-xr-x 6 root root 0 2009-04-21 16:50 /sys/block/md_foo
      
NeilBrown
