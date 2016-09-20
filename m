From: Ramon Hofer <ramonhofer@bluewin.ch>
Subject: Re: Enlarging device of linear array again (Thank you Stan!)
Date: Wed, 21 Sep 2016 01:06:26 +0200
Message-ID: <20160921010626.31ced172@hoferr-X240.hofer.rummelring>
References: <20160920213442.1559310f@hoferr-X240.hofer.rummelring>
        <57E1AF80.8000406@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <57E1AF80.8000406@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thank you very much for your answer, Wol!


On Tue, 20 Sep 2016 22:52:00 +0100
Wols Lists <antlists@youngman.org.uk> wrote:

> On 20/09/16 20:34, Ramon Hofer wrote:
> > I am using 4 TB WD red to replace the 1.5 TB disks.
> > 
> > Do you think this could work?
> > Are there any pitfalls?
> > Should I unmount the array to perform all these steps? It might be
> > safer since there is no redundancy during the replacement?
> > 
> > I just wanted to check first before making any mistakes. Instead of
> > maybe afterwards asking for help recovering my data :-P  
> 
> I don't quite understand what you are doing, but ...

Sorry I forgot to mention some things.

I have a linear md0 containing four raid5 (md[1234]) to which XFS is
stripe aligned due to the performance. [1], [2]

The case for my home media server is a Norco [3] with 20 slots. Four are
dedicated to MythTV.
4 x 4 are in md0.

I want to replace the four 1.5 TB disks with 4 TB to have more
space.

On the four 4 TB disks I create two partitions (1.5 TB and 2.5 TB).
Each old 1.5 TB disk gets replaced with the partition on the 4 TB
disks. From the 2.5 TB of each of the four 4TB disks I create a new
RAID5 (md5) and add this to the linear md0. At the end I expand the
file system. 


> The other way to do it is just shut the machine down, remove all
> drives except one and put a new big drive in. Boot from a rescue CD,
> partition the new drive and dd the old partitions to the new drive.
> Again rinse and repeat for all four drives, and then put all four new
> drives in the system and reboot. At which point you can expand all the
> filesystems/raids to use all the space available. This *shouldn't* be
> a risky operation. Indeed, if you're going to shut the array down,
> this is probably the simplest and safest option.

So you suggest to dd the 1.5 TB disks to the 1.5 TB
partition on the 4 TB disks instead of just let mdadm rebuild the
array?
I was thinking about this as well because the dd process might be
faster because the CPU load would be significantly less than the RAID5
rebuild process. And only one disk is read during the copy process -
instead of all the other three for each of the four rebuilds.

Can I just do:

sudo dd if=/dev/sde of=/dev/sdf1

Assuming sde is the old 1.5 TB disk and sdf1 is the 1.5 TB partition on
the new 4 TB disk.
Can I be sure that mdadm recognizes the partitions correctly as the
replacement for the old disks?


Best regards,
Ramon


[1] http://marc.info/?l=linux-raid&m=137077874619605&w=2
[2] http://marc.info/?l=linux-raid&m=134031891621599&w=2
[3] http://www.norcotek.com/?s=RPC-4020
