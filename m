From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Upgrading Raid1 array to have 2. disks.
Date: Wed, 7 May 2003 10:00:49 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16056.19633.400369.451156@notabene.cse.unsw.edu.au>
References: <3EB8441F.8070606@fugmann.dhs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Anders Fugmann on Wednesday May 7
To: Anders Fugmann <afu@fugmann.dhs.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday May 7, afu@fugmann.dhs.org wrote:
> Hi,
> 
> Sorry if this is the wrong list to post this on.
> 
> I have made an error when creating a new raid1 array as I specified that
> the raid should consist of only one disk. Now, I would like to add 
> another disk, but mdadm insists on adding it as a spare disk, offering 
> no data redundancy.
> 
> Before:
> md0 : active raid1 ide/host0/bus0/target0/lun0/part1[0]
>        1048704 blocks [1/1] [U]
> 
> After running
> # mdadm -add /dev/md/0
>      /dev/ide/host0/bus0/target0/lun0/part1[0]
> 
> md0 : active raid1 ide/host0/bus1/target0/lun0/part1[1] 
> ide/host0/bus0/target0/lun0/part1[0]
>        1048704 blocks [1/1] [U]
> 
> 
> I have read the manpages, and tried googling without success.
> I do not wish to destroy the data on the discs, and recreate the array 
> but It might be a last resort. Can anyone help me convince mdadm to add 
> the 2. partition as an active disk.

You cannot add a new data drive to a raid1 array.
If you shut down the array and re-create it you should not loose data.
The correct command to use would be something like:
  mdadm --create /dev/md0 --level=1 -n 2 /dev/ide/host0/bus0/target0/lun0/part1 missing

Note the word "missing" at the end.  This tells mdadm to create a
2-drive array with one missing drive (and so only one active drive).
This will have the same data as the old md0.
Now "mdadm --add" should do what you want.

NeilBrown


> 
> Regards
> Anders Fugmann
> 
> P.s.
> Please CC me, as I'm not subscribed to the list.
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
