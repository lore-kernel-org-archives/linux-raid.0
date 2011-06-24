From: NeilBrown <neilb@suse.de>
Subject: Re: raid upgrade form 1.5T to 3T drives with 0.90 superblock
Date: Sat, 25 Jun 2011 08:00:34 +1000
Message-ID: <20110625080034.5feb32bb@notabene.brown>
References: <1308854595.23175.65.camel@oxygen.netxsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1308854595.23175.65.camel@oxygen.netxsys.com>
Sender: linux-raid-owner@vger.kernel.org
To: Krzysztof Adamski <k@adamski.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 23 Jun 2011 14:43:15 -0400 Krzysztof Adamski <k@adamski.org> wrote:

> Hi All,
> 
> I have a raid6 array made out of 8 1.5T drives and I wanted to change to
> use 3T drives. The array is 0.90. After reading the wiki I see that 0.90
> superblock will not work with any device larger then 2T.
> 
> What are my options for a live upgrade (backup/restore is not possible)?
> 

I really am going to have  to add --update=metadata to mdadm one day...

Simply stop the array and create it again with --metadata=1.0.
For safety specify all the details : chunk size, layout, raid-disks, as the
defaults might have changed.
Create the array 'assume-clean' to it doesn't try to resync.  Then check
(read-only) that your data is good.
e.g.


 mdadm -S /dev/md0
 mdadm -C /dev/md0 -l6 -n8 -c64 --layout=la --assume-clean   \
     /dev/sda1 /dev/sdb1 /dev/sdc1 ....

You should specify --size as well ... otherwise mdadm might leave too much
space for a bitmap - I don't remember exactly.


Make sure you put the device names in the correct order.  You can find this
order from "mdadm -D".

If you like you could post the output of mdadm -D and the commands you
propose to run so I/others can verify it for you.

1.0 metadata puts the metadata at the end just like 0.90, and the metadata is
smaller so the data will remain untouched.
Just this create command by itself cannot destroy you data so if you then
look at the array read-only  it will still not change anything.  Once you are
sure everything is OK you can start writing.

Oh, and of course do all this with the 1.5 drives.  Don't try adding the 3T
drives until verything is stable.


Good luck,
NeilBrown
