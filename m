From: "Thomas Hicks" <thicks@speedfreak.org>
Subject: RE: Mdadm issue
Date: Fri, 5 Jul 2002 09:14:34 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <000e01c2243f$0db6d260$2500010a@speedway.com>
References: <15651.41348.927793.745450@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <15651.41348.927793.745450@notabene.cse.unsw.edu.au>
To: 'Neil Brown' <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks so much. That fixed it. It is now up and running. 

Tom
:o)


> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of Neil Brown
> Sent: Wednesday, July 03, 2002 6:15 PM
> To: Thomas Hicks
> Cc: linux-raid@vger.kernel.org
> Subject: Re: Mdadm issue
> 
> On Monday July 1, thicks@speedfreak.org wrote:
> > This is the first time I am setting up raid using the mdadm tool.
This
> > is what I am trying to do.
> >
> > The sever is as follows: 2 drives at 10gig
> >                          2 drives at 80gig
> > hda2 is /
> > hdd1 is my /home
> >
> > I have the other drives in ad ready and would like to set up the 2
10
> > gig's as a mirror and the 2 80 gig as raid0
> >
> > At the shell I run this command
> >
> > mdadm --create /dev/md0  --level=1 --raid-disks=2 /dev/hda2
/dev/hdb1
> > and get the following output:
> >
> > mdadm: /dev/hda2 appears to contain an ext2fs file system
> >     size=7269412K  mtime=Mon Jul  1 11:56:16 2002
> > mdadm: /dev/hdb1 appears to contain an ext2fs file system
> >     size=7333640K  mtime=Mon Jul  1 11:56:29 2002
> > Continue creating array? y
> > mdadm: SET_ARRAY_INFO failed for /dev/md0: File exists
> >
> > Could someone please help me with this problem. I am having a really
> > hard time finding any info on the web about this.
> 
> hda2 is mounted as / and you are trying to make a raid1 array
> containing it.  This cannot work.
> What you want to do is:
> 
>    mdadm --create /dev/md0 --level=1 --raid-disks=2 missing /dev/hdb1
> 
> to create a degraded array containing just hdb1.
> Then:
>     mkfs /dev/md0
>     mount /dev/md0 /mnt
>     cp -ax / /mnt
> 
> to copy your root filesystem onto /dev/md0.
> Then tell lilo:
>    append= "root=/dev/md0 md=0,/dev/hdb1"
> and tell fstab that root in on /md0, and reboot.
> 
> Then you should be be running with root on /dev/md0 which consists of
> /dev/hdb1, and /dev/hda2 will be unused.
> Then
>    mdadm --add /dev/md0 /dev/hda2
> to add hda2 to the mirror.  Wait for resync.
> Change lilo.conf to say the right thinggs, run lilo and reboot.
> 
> Note:  it appears that hdb1 is bigger than hda2.  If this is so you
> will need to give a --size= to mdadm when created md0 so that it is
> small enough to be able to use hda2.
> Subtract 128 K from the size of hda2, so
>   mdadm --create /dev/md0 --size=7269280 ......
> 
> NeilBrown
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid"
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

