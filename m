From: Neil Brown <neilb@suse.de>
Subject: Re: to be or not to be...
Date: Mon, 24 Apr 2006 07:45:27 +1000
Message-ID: <17483.62839.125510.962278@cse.unsw.edu.au>
References: <20060423125836.GB6081@gelma.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from gelma on Sunday April 23
Sender: linux-raid-owner@vger.kernel.org
To: gelma <dislessico@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday April 23, dislessico@gmail.com wrote:
> Hi all,
> 	to make a long story very very shorty:
> 	a) I create /dev/md1, kernel latest rc-2-git4 and mdadm-2.4.1.tgz,
> 	   with this command:
> 	   /root/mdadm -Cv /dev/.static/dev/.static/dev/.static/dev/md1 \
>              --bitmap-chunk=1024 --chunk=256 --assume-clean --bitmap=internal \
                                               ^^^^^^^^^^^^^^
>              -l5 -n5 /dev/hda2 /dev/hdb2 /dev/hde2 /dev/hdf2 missing
> 	

 From the man page:
       --assume-clean
              Tell mdadm that the array pre-existed and is known to be  clean.
              It  can be useful when trying to recover from a major failure as
              you can be sure that no data will be affected unless  you  actu-
              ally  write  to  the array.  It can also be used when creating a
              RAID1 or RAID10 if you want to avoid the initial resync, however
              this  practice - while normally safe - is not recommended.   Use
                                                                           ^^^
              this ony if you really know what you are doing.
              ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

So presumably you know what you are doing, and I wonder why you bother
to ask us :-)
Ofcourse, if you don't know what you are doing, then I suggest
dropping the --assume-clean.  
In correct use of this flag can lead to data corruption.  This is
particularly true if your array goes degraded, but is also true while
your array isn't degraded.  In this case it is (I think) very unusual
and may not be the cause of your corruption, but you should avoid
using the flag anyway.


> 	b) dm-encrypt /dev/md1
> 	
> 	c) create fs with:
> 	   mkfs.ext3 -O dir_index -L 'tritone' -i 256000 /dev/mapper/raidone
> 	
> 	d) export it via nfs (mounting /dev/mapper/raidone as ext2)
                                                              ^^^^

Why not ext3?

> 
> 	e) start to cp-ing files
> 
> 	f) after 1 TB of written data, with no problem/warning, one of the
> 	not-in-raid-array HD freeze

This could signal a bad controller.  If it does, then you cannot trust
any drives.

NeilBrown
