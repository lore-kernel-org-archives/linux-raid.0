From: Paul Clements <paul.clements@steeleye.com>
Subject: Re: Shrinking a RAID1 device mounted as root?
Date: Wed, 14 Jul 2004 12:42:21 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40F5626D.9000406@steeleye.com>
References: <66EEBBD3485BB84C90CFA900A0A96E55013BEC82@sumail03.studentuniverse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <66EEBBD3485BB84C90CFA900A0A96E55013BEC82@sumail03.studentuniverse.com>
To: "Marlier, Ian" <marlieri@studentuniverse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Marlier, Ian wrote:

> Because /dev/hd[ab]1 is larger than /dev/md0, and the starting block of
> the partitions is the same, the filesystem should remain intact.

So you are saying that the filesystem was less than 16GB in size to 
start with?

> However, upon rebooting, I ran into a problem.  /dev/md0 cannot be
> mounted because of a problem with the superblocks.

Right, the superblocks would have been between 64KB and 128KB from the 
end of the original md device, which presumably was ~33GB in size. Now 
that the partitions are smaller, the superblocks are no longer located 
inside of the partitions, so the new partitions effectively have no 
superblocks.

> I figure that something needs to be done with mdadm to get it to
> recognize the "new" /dev/hda1 and /dev/hdb1 as /dev/md0 -- but I don't
> want to do a mdadm --create because that will overwrite the filesystem
> already on the disks (I think?). 

Create will write new superblocks to /dev/hda1 and /dev/hdb1. Without 
these, the array cannot be started. The superblocks are what tell the md 
driver that /dev/md0 is composed of /dev/hda1 and /dev/hdb1.

If the filesystem is at least 128KB smaller than the partitions, then 
you'll have room for the superblocks at the end. Otherwise, go back with 
fdisk and make the partitions just a little bit larger and then do your 
mdadm --create.


> Is this something that mdadm --assemble can do?  If so, what switches
> need to be fed to the command?

Assemble requires that the superblocks already be present, so until they 
are re-created, you cannot assemble the array.

--
Paul
