From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: ANNOUNCE: mdadm 1.6.0 - A tool for managing Soft RAID under
     Linux
Date: Fri, 4 Jun 2004 22:13:41 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16576.26485.323313.378671@cse.unsw.edu.au>
References: <16576.5818.189830.563396@cse.unsw.edu.au>
	<40287.194.60.85.4.1086343951.squirrel@194.60.85.4>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Robin Bowes on Friday June 4
To: Robin Bowes <robin@robinbowes.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday June 4, robin@robinbowes.com wrote:
> On Fri, June 4, 2004 7:29, Neil Brown said:
> >   - Further support for partitionable arrays included "--auto=" option
> >     and "auto=" config file entry which instructs mdadm to create the necessary
> >     device files after allocating an unused array number.
> 
> Neil,
> 
> I am interpreting this to mean that I can create, for example, a large (e.g. 1TB) RAID5
> array and create smaller partitions (/home, /usr, etc) on top of the RAID5 array? Is
> this correct?

Yes, this is correct.

> 
> Where can I read more about this?

Uhm.... Good question.  The are brief hints in
   man mdadm
and
   man mdadm.conf
but I guess I should put something in:
   man 4 md

In recent 2.6 kernels you can create partitionable md arrays.
The is no fixed major number.  The major number can be found by
looking for "mdp" in /proc/devices.
There are 64 minor numbers for each array, allowing up to 63
partitions. 

The simplest way to access this functionality is with

    mdadm --create /dev/md/XX --auto=partition --level= ....

to create, or
 
    mdadm --assemble /dev/md/XX --auto=partition .....

to assemble.  Alternately "auto=partition" can be put in mdadm.conf.

If you do this, it will create device files:
 
    /dev/md/XX   the whole array
    /dev/md/XX1  the first partition
    /dev/md/XX2  the second partition
    /dev/md/XX3  the third partition
    /dev/md/XX4  the fourth partition

More (or less) partitions can be created using e.g. --auto=partition8
to create 8 partition device files.

The arrays will appear in /proc/mdstat as

    md_dN

where N is the number that was chosen.

Then
   cfdisk /dev/md/XX

will allow you to partition the array.

I hope this helps.

NeilBrown



> 
> Thanks,
> 
> R.
> -- 
> http://robinbowes.com
