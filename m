From: carlos@fisica.ufpr.br (Carlos Carvalho)
Subject: Re: Automatic drive partitioning
Date: Sat, 8 Oct 2005 17:32:31 -0300
Message-ID: <17224.11487.659497.812038@fisica.ufpr.br>
References: <200510081910.15934.thomas.jarosch@intra2net.com>
	<Pine.LNX.4.44.0510081503490.28615-100000@coffee.psychology.mcmaster.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0510081503490.28615-100000@coffee.psychology.mcmaster.ca>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mark Hahn (hahn@physics.mcmaster.ca) wrote on 8 October 2005 15:09:
 >> I tried copying the partition table using sfdisk and it complained
 >> about "partition does not start at a cylinder boundary". After re-running
 >> with the --force flag (like a dd copy would do) and formatting the partition,
 >> the system went nuts.
 >
 >hmm, well, I guess you are coming from an older/non-LBA disk.  I suppose 
 >I should have mentioned that little caveat: don't try the dd trick
 >going from CHS to LBA.  LBA->LBA should be OK

Agreed. I've been using sfdisk without problems with various drives. I even
usually start the first partition on sector 1... When I want to copy
the partition table of one disk to the other I do
sfdisk -d partitioned-disk | sfdisk --force new-disk.

It works for drives of different sizes as well. Yesterday I tried
this pipe with logical partitions and even with force it refused,
complaining that an extended partition didn't start at a cylinder
boundary. That's non-sense so I just did a

# for i in each-of-the-disks; do
sfdisk -uS /dev/sd$i << EOF
partition info
EOF
done

and all was well.

The concept of cylinder et. al is history now. Only the manufacturer
knows how the info is organized on the disk surface.
