From: seth vidal <skvidal@phy.duke.edu>
Subject: Re: shuffled disks by mistake
Date: Thu, 10 Mar 2005 09:40:20 -0500
Message-ID: <1110465620.9276.15.camel@cutter>
References: <423056F1.2020403@fastmail.co.uk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
In-Reply-To: <423056F1.2020403@fastmail.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: mwaterman@jingmei.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 2005-03-10 at 22:17 +0800, Max Waterman wrote:
> Hi,
> 
> I have 6 WD800Jb disk drives. I used 4 of them in a RAID5 (using the 
> whole disk - no partitions) array.
> 
> I have mixed them all up, and now want to get some data off the array.
> 
> How best to find out which drives were in the array?
> 
> Here are the partition tables (obtained using fdisk on OS X):

put the drives in a linux machine and run:

mdadm -E /dev/drive#

it should tell you if there is an md superblock on that system.

-sv


