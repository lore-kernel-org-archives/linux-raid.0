From: Lem <l3mming@iinet.net.au>
Subject: Re: Correct way to create multiple RAID volumes with hot-spare?
Date: Wed, 13 Sep 2006 16:56:55 +1000
Message-ID: <1158130615.4500.9.camel@localhost.localdomain>
References: <44EB5579.4020200@maine.edu>
	 <17644.55759.763091.379642@cse.unsw.edu.au>  <4507212E.3060703@maine.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4507212E.3060703@maine.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Steve Cousins <steve.cousins@maine.edu>
Cc: Neil Brown <neilb@suse.de>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, 2006-09-12 at 17:05 -0400, Steve Cousins wrote:

> The recent "Messed up creating new array..." thread has someone who 
> started by using the whole drives but she now wants to use partitions 
> because the array is not starting automatically on boot (I think that 
> was the symptom).  I'm guessing this is because there is no partigion ID 
> of "fd" since there isn't even a partition.

> I'm on the verge of re-doing this array with 11 full drives (/dev/sd? as 
> opposed to /dev/sd?1 and /dev/sd?2).  Will I have the same problems with 
> booting?  I like the idea of not having to partition the drives but not 
> if it is going to cause hassles.  I realize that there could be a 
> potential problem if I need to replace a drive with a slightly different 
> model that is slightly smaller.

From personal experience, partitions would be much easier. I've still
got an issue on my RAID5 where one of the hard disks has a bogus/fake
partition table on it (simply due to the data on the RAID appearing like
a partition table). It causes problems with lilo and other processes at
boot time (all non-fatal except for lilo). Perhaps with time I'll get
lucky and the data in that particular part of the drive will be changed
to something that looks nothing like a partition table :)


Lem.
