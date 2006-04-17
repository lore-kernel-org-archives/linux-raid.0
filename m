From: Neil Brown <neilb@suse.de>
Subject: Re: help wanted - 6-disk raid5 borked: _ _ U U U U
Date: Mon, 17 Apr 2006 10:51:09 +1000
Message-ID: <17474.59005.812914.343869@cse.unsw.edu.au>
References: <62b0912f0604161419udee8ff2tf0861bc2f6e8e304@mail.gmail.com>
	<17474.51121.178492.61143@cse.unsw.edu.au>
	<62b0912f0604161721xc30e6abn27c55dcd9caefd2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Molle Bestefich on Monday April 17
Sender: linux-raid-owner@vger.kernel.org
To: Molle Bestefich <molle.bestefich@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday April 17, molle.bestefich@gmail.com wrote:
> Neil Brown wrote:
> > use --assemble --force
> 
> # mdadm --assemble --force /dev/md1
> mdadm: forcing event count in /dev/sda1(0) from 163362 upto 163368
> mdadm: /dev/md1 has been started with 5 drives (out of 6).
> 
> Oops, only 5 drives, but I know data is OK on all 6 drives.
> 
> I also know that there are bad blocks on more than 1 drive.  So I want
> MD to recover from the other drives in those cases, which I won't be
> able to with only 5 drives.
> 
> In other words, checking/repairing with only 5 drives will lead to
> data corruption.
> 
> I'll stop and try again, listing all 6 drives by hand:
> 
> # mdadm --stop /dev/md1
> # mdadm --assemble /dev/md1 --force  /dev/sda1 /dev/sdb1 /dev/sdc1
> /dev/sdd1 /dev/sde1 /dev/sdf1
> mdadm: /dev/md1 has been started with 5 drives (out of 6).
> 
> Ugh.  Didn't work.  Bug?
> 
> How do I force MD to raise the event counter on sdb1 and accept it
> into the array as-is, so I can avoid bad-block induced data
> corruption?

For that, you have to recreate the array.  Make sure you get the
chunksize,  parity algorithm, and order correct, but something like

  mdadm -C /dev/md1 --assume-clean /dev/sda1 /dev/sdb1 /dev/sdc1 \
      /dev/sdd1 /dev/sde1 /dev/sdf1

and then 
  echo check > /sys/block/md1/md/sync_action

and see what 
   cat /sys/block/md1/md/mismatch_count
reports at the end.
Then maybe 'echo repair > ....'

NeilBrown
