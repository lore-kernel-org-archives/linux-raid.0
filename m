From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Is it possible to create a raid from/over other raids?
Date: Thu, 19 Dec 2013 03:17:51 -0600
Message-ID: <52B2B9BF.6030707@hardwarefreak.com>
References: <BLU0-SMTP2702D8075688EF7D229D66498DA0@phx.gbl>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BLU0-SMTP2702D8075688EF7D229D66498DA0@phx.gbl>
Sender: linux-raid-owner@vger.kernel.org
To: Wilson Jonathan <piercing_male@hotmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 12/18/2013 3:12 PM, Wilson Jonathan wrote:
> I realise if it is possible its not going to be the best solution, but a
> temp stop gap... 
> 
> What I am thinking of doing is while I save up to by my 4'th new disk
> for a new raid 6 setup (4 drive raid 6, currently has 3 disks 1 missing)
> is it possible to use 3 existing smaller disks, create a raid0 across
> them and then add the resulting /dev/dmX as "a disk" where the currently
> missing disk is marked as missing.

The primary purpose of RAID is to protect your filesystem and files
against failure of a disk in an array.  The purpose of RAID6 is to
protect against a second disk failure or read error while you're
rebuilding the first failed drive in an array.  By creating a RAID6 with
one missing, you've essentially created a RAID5 array, as you can only
lose one drive.

Why didn't you simply create a RAID5, then reshape it to RAID6 when you
acquire your "4th" disk?  If you'd done that you wouldn't be worrying
about "plugging this hole".

> EG. /dev/md7  ... /dev/sdb1 /dev/sdc1 /dev/sdd1 missing
> 
> mdadm create /dev/md8 raid0 /dev/sde1 /dev/sdf1 /dev/sdg1
> 
> mdadm --add /dev/md7 /dev/md8
> 
> If it is possible do I need to make sure the order in the conf file
> first lists the /md8 then the /md7 or will mdadm see that a raid
> contains a raid as a disk and then waits for it before assembling.

It is possible, and yes the order matters.  md8 needs to be assembled
before md7 assembles.  But I don't think you really gain much by doing
this, especially when you're building the RAID6 constituent RAID0 member
out of old drives.

The tone of your request suggests the time frame to add the 4th drive is
now indeterminate, and you have a realization that it may possibly never
happen.  This being the case, I'd suggest you backup all your files,
blow away the 'kissing' RAID6, and make a fresh RAID5 of your 3 drives.
 Or a RAID10.  Then format and restore.  Your performance will increase,
and you won't have to worry about this missing drive in your crippled
RAID6 array.

-- 
Stan
