From: Paul Clements <paul.clements@steeleye.com>
Subject: Re: shuffled disks by mistake
Date: Thu, 10 Mar 2005 09:39:30 -0500
Message-ID: <42305C22.7070406@steeleye.com>
References: <423056F1.2020403@fastmail.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <423056F1.2020403@fastmail.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: mwaterman@jingmei.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Max Waterman wrote:

> I have 6 WD800Jb disk drives. I used 4 of them in a RAID5 (using the 
> whole disk - no partitions) array.

> I have mixed them all up, and now want to get some data off the array.

> How best to find out which drives were in the array?

put them in a linux box and run "mdadm -E <disk>" on each disk -- that 
will tell you which ones have superblocks and all the details of those 
superblocks

--
Paul
