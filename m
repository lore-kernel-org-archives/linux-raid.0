From: Neil Brown <neilb@suse.de>
Subject: Re: Correct way to create multiple RAID volumes with hot-spare?
Date: Thu, 24 Aug 2006 08:42:23 +1000
Message-ID: <17644.55759.763091.379642@cse.unsw.edu.au>
References: <44EB5579.4020200@maine.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Steve Cousins on Tuesday August 22
Sender: linux-raid-owner@vger.kernel.org
To: Steve Cousins <steve.cousins@maine.edu>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tuesday August 22, steve.cousins@maine.edu wrote:
> Hi,
> 
> I have a set of 11 500 GB drives. Currently each has two 250 GB 
> partitions (/dev/sd?1 and /dev/sd?2).  I have two RAID6 arrays set up, 
> each with 10 drives and then I wanted the 11th drive to be a hot-spare. 
>   When I originally created the array I used mdadm and only specified 
> the use of 10 drives since the 11th one wasn't even a thought at the 
> time (I didn't think I could get an 11th drive in the case).  Now I can 
> manually add in the 11th drive partitions into each of the arrays and 
> they show up as a spares but on reboot they aren't part of the set 
> anymore.  I have added them into /etc/mdadm.conf and the partition type 
> is set to be  Software RAID (fd).

Can you show us exactly what /etc/mdadm.conf contains?
And what kernel messages do you get when it assembled the array but
leaves off the spare?

> 
> Maybe I shouldn't be splitting the drives up into partitions.  I did 
> this due to issues with volumes greater than 2TB.  Maybe this isn't an 
> issue anymore and I should just rebuild the array from scratch with 
> single partitions.  Or should there even be partitions? Should I just 
> use /dev/sd[abcdefghijk] ?
> 

I tend to just use whole drives, but your set up should work fine.
md/raid isn't limited to 2TB, but some filesystems might have size
issues (though i think even ext2 gots to at least 8 TB these days).

> On a side note, maybe for another thread, the arrays work great until a 
> reboot (using 'shutdown' or 'reboot' and they seem to be shutting down 
> the md system correctly).  Sometimes one or even two (yikes!) partitions 
> in each array go offline and I have to mdadm /dev/md0 -a /dev/sdx1 it 
> back in.  Do others experience this regularly with RAID6?  Is RAID6 not 
> ready for prime time?

This doesn't sound like a raid issues.  Do you have kernel logs of
what happens when the array is reassembled and some drive(s) are
missing?

NeilBrown
