From: Vince <stuff@hagenhuegel.de>
Subject: Re: Raid5 drive fail during grow and no backup
Date: Mon, 3 Nov 2014 14:45:20 +0000 (UTC)
Message-ID: <loom.20141103T151703-83@post.gmane.org>
References: <loom.20141031T141939-473@post.gmane.org> <5455A35C.2060000@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Phil Turmel <philip <at> turmel.org> writes:

> 
> On 10/31/2014 09:34 AM, Vince wrote:
> > Hi,
> >
> > got a drive failure (bad block) during Raid5 grow (4x3TB -> 5x3TB).
> > Well... i don't have a backup file :/
> > Mdadm shows 1 drive as removed.
> >
> > All 4 'good' drives are in the same reshape pos'n.
> >
> > Any idea how to finish the reshape process? Or get the array back?
> 
> mdadm --stop /dev/md0
> mdadm --assemble --force --verbose /dev/md0 /dev/sd[bcdf]
> 
> If that doesn't work, please show us the output.
> 
> You haven't (yet) lost your array.  It's just degraded.  You should 
> investigate why the one drive was kicked out of the array instead of 
> being rewritten properly (green drives?).  In the meantime, assembly 
> with --force should give you access to the data to grab anything 
> critically important.
> 
> If you share the output of "smartctl -x /dev/sdX" for at least the 
> kicked drive, we can offer further advice.
> 
> Regards,
> 
> Phil
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo <at> vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

Hi Phil,

thx for your reply.
Already have the raid clean and up.

My drive was kicked due to read errors (bad sectors).
I fixed the bad sectors with hdparm --write-sector $bad_sector /dev/sdx

After some tries 
mdadm --assemble --force --verbose /dev/md0 /dev/sd[bcdf] 
works so far.
I was able to encrypt the drive and all logical volumes had beed detected
correct.
But i was unable to mount any lv (i guess due to an filesystem problem, but
i won't run es2fscheck during broken reshape)

So i did a backup and removed the superblock on the broken disk and added it
as spare to /dev/md0  (mdadm --add)

Now i had 4 Disk in sync, 1 removed and 1 spare

To restart the reshape i did mdadm --mdadm --readwrite /dev/md0
Well.. i had a backup of my most important files and in that situation i was
like... ok if all is lost now... i'll change a lot in future :)

Reshape restarted at ~80% (cat /proc/mdstat) but the funny thing was, that
all 4 drives only did write actions. No reading on the drives... I don't
know what happens there, but i let it go

After reshape was done, mdadm grabs the spare drive and started resync.

After resync was done, i did e2fsck -f on logical volumes
Finally i was able to mount all lv's without any data lost.











