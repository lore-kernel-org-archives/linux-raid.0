From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: ANNOUNCE: mdadm 1.6.0 - A tool for managing Soft RAID under      Linux
Date: Sat, 5 Jun 2004 16:08:44 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16577.25452.82324.146669@cse.unsw.edu.au>
References: <200406041421.i54EL7319045@watkins-home.com>
	<006301c44aab$c02cc8c0$6705a8c0@a30>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from me@heyjay.com on Friday June 4
To: me@heyjay.com
Cc: Guy <bugzilla@watkins-home.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday June 4, me@heyjay.com wrote:
> I did finish, but the example seemed to show that the --auto would build the
> partitions.  I know at the end of the message Neil said then you use cfdisk
> but it seemed unnecessary at that point

Hmmm.... 
I said:

: If you do this, it will create device files:
:  
:     /dev/md/XX   the whole array
:     /dev/md/XX1  the first partition
:     /dev/md/XX2  the second partition
:     /dev/md/XX3  the third partition
:     /dev/md/XX4  the fourth partition

Meaning that it will create "device files" for the partitions, which
is what I said.
However I then said:

: More (or less) partitions can be created using e.g. --auto=partition8
: to create 8 partition device files.

Which first says that "partitions" can be created, and then that
"partition device files" will be created.  

So I clearly wasn't being precise as would be good, though I was
trying :-)

mdadm created device files (just like mknod does).  It does not create
partitions - that is a job for *fdisk.

NeilBrown


