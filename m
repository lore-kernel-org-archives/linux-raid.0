From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Mdadm issue
Date: Thu, 4 Jul 2002 11:14:44 +1000 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15651.41348.927793.745450@notabene.cse.unsw.edu.au>
References: <006801c22142$d28ed790$2500010a@speedway.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Thomas Hicks on Monday July 1
To: Thomas Hicks <thicks@speedfreak.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday July 1, thicks@speedfreak.org wrote:
> This is the first time I am setting up raid using the mdadm tool. This
> is what I am trying to do. 
> 
> The sever is as follows: 2 drives at 10gig
>                          2 drives at 80gig
> hda2 is /
> hdd1 is my /home
> 
> I have the other drives in ad ready and would like to set up the 2 10
> gig's as a mirror and the 2 80 gig as raid0
> 
> At the shell I run this command 
> 
> mdadm --create /dev/md0  --level=1 --raid-disks=2 /dev/hda2 /dev/hdb1
> and get the following output:
> 
> mdadm: /dev/hda2 appears to contain an ext2fs file system
>     size=7269412K  mtime=Mon Jul  1 11:56:16 2002
> mdadm: /dev/hdb1 appears to contain an ext2fs file system
>     size=7333640K  mtime=Mon Jul  1 11:56:29 2002
> Continue creating array? y
> mdadm: SET_ARRAY_INFO failed for /dev/md0: File exists
> 
> Could someone please help me with this problem. I am having a really
> hard time finding any info on the web about this. 

hda2 is mounted as / and you are trying to make a raid1 array
containing it.  This cannot work.  
What you want to do is:

   mdadm --create /dev/md0 --level=1 --raid-disks=2 missing /dev/hdb1

to create a degraded array containing just hdb1.
Then:
    mkfs /dev/md0
    mount /dev/md0 /mnt
    cp -ax / /mnt

to copy your root filesystem onto /dev/md0.
Then tell lilo:
   append= "root=/dev/md0 md=0,/dev/hdb1"
and tell fstab that root in on /md0, and reboot.

Then you should be be running with root on /dev/md0 which consists of
/dev/hdb1, and /dev/hda2 will be unused.
Then
   mdadm --add /dev/md0 /dev/hda2
to add hda2 to the mirror.  Wait for resync.
Change lilo.conf to say the right thinggs, run lilo and reboot.

Note:  it appears that hdb1 is bigger than hda2.  If this is so you
will need to give a --size= to mdadm when created md0 so that it is
small enough to be able to use hda2.
Subtract 128 K from the size of hda2, so
  mdadm --create /dev/md0 --size=7269280 ......

NeilBrown

