From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: md: can not impport hdb1, has active inodes!
Date: Wed, 3 Mar 2004 12:04:25 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16453.12057.827300.308373@notabene.cse.unsw.edu.au>
References: <4045288B.27321.2DA4EF3@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Chris Evans on Wednesday March 3
To: Chris Evans <chris1@psyctc.org>
Cc: debian-user@lists.debian.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday March 3, chris1@psyctc.org wrote:
> On 3 Mar 2004 at 10:40, Neil Brown wrote:
> 
> > Wrong.
> >  mkfs -t ext3 /dev/md0
> > then mount /dev/md0. 
> > Once you have included /dev/hdc1 in an array, don't touch it again -
> > just access the array (/dev/md0).
> 
> Sorry, I was being hasty in writing the Email, that's what I did, 
> i.e. mkfs the /dev/md0 drive.  That's not the problem.
> 
> > You missed a step (step 9).  You have to reboot so that /dev/md0 is
> > your root device. Once you have done that and are happy with it, you
> > add in /dev/hdb1 and let it resync.
> Ditto: did that, no go.

Sorry, I missed where you said that you rebooted.

It sounds very odd.

What does "cat /proc/mounts" say?

Does your kernel use an initrd?

Exactly how did you tell lilo to use /dev/md0?
With
   root=/dev/md0
as an option in lilo.conf, or with
   append= "root=/dev/md0"

or both or something else?

NeilBrown
