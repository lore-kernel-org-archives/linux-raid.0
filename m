From: David Greaves <david@dgreaves.com>
Subject: Re: disaster. raid1 drive failure rsync=DELAYED why?? please help
Date: Sun, 13 Mar 2005 15:49:02 +0000
Message-ID: <423460EE.9070602@dgreaves.com>
References: <200503122351.23430.mlaks@verizon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <200503122351.23430.mlaks@verizon.net>
Sender: linux-raid-owner@vger.kernel.org
To: Mitchell Laks <mlaks@verizon.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mitchell Laks wrote:

>Hi,
>I have a remote system with a raid1 of a data disk. I got a call from  the 
>person using the system that the application that writes to the data disk was 
>not working.
>
>system drive is /dev/hda with separte partitions / , /var, /home, /tmp.
>data drive is linux software raid1 /dev/md0 with /dev/hdc1,  /dev/hde1. 
>
>I logged in remotely and discovered that the /var partition was full because 
>many write errors from /dev/hde1 in /var/log/syslog.
>
>When I looked into cat /proc/mdstat i discovered that /dev/md0 was degraded  
>because /dev/hdc1 had failed (there was an f there) and /dev/hde1 was 
>carrying the load.
>
>I shut down the applications in background. I emptied out /var/log/syslog. I 
>then removed /dev/hdc1 from the array /dev/md0. 
>
>I had another pair of drives on the system that was part of another mirrored 
>array /dev/md1 with no useful information stored on them. 
>
>/dev/md1  /dev/hdf1 /dev/hdh1 
>
>I thought ok, let me detach /dev/hdf1 from the  other array /dev/md1  and try 
>attach it to /dev/md0 and rebuild the array /dev/md0. That way i would rescue 
>the data on the threatening drive /dev/hde1 which is spewing out error 
>messages to my /var/log/syslog and threatening to die! 
>
>So stupidly (probably), I did
>
>mdadm /dev/md1  --fail /dev/hdf1 --remove /dev/hdf1
>  
>
OK
what does mdadm --detail /dev/md1 show?

>then i did 
>mdadm /dev/md0 --add /dev/hdf1
>  
>
hmm - I don't know. I would have zeroed it :)

>Now when i did 
>cat /proc/mdstat I see:
>
>md0 : active raid1 hdf1[2] hde1[0]
>      244195904 blocks [2/1] [U_]
>        resync=DELAYED
>
>I don't see any rebuilding action going on.
>  
>
I see the full /proc/mdstat appears later...

 From the source (md.c)
    /* we overload curr_resync somewhat here.
     * 0 == not engaged in resync at all
     * 2 == checking that there is no conflict with another sync
     * 1 == like 2, but have yielded to allow conflicting resync to
     *        commense
     * other == active in resync - this many blocks
     *
     * Before starting a resync we must have set curr_resync to
     * 2, and then checked that every "conflicting" array has curr_resync
     * less than ours.  When we find one that is the same or higher
     * we wait on resync_wait.  To avoid deadlock, we reduce curr_resync
     * to 1 if we choose to yield (based arbitrarily on address of mddev 
structure).
     * This will mean we have to start checking from the beginning again.

you are in state 1 or 2.
hmmm


next email:

Mitchell Laks wrote:

>1) I tried to add the new spare device to /dev/md0 on friday afternoon.  It
>still has not rebuilt.
>
problem 1.

> I am also unable to do "ls" of the directory of the 
>drive.
>
problem 2 - this shouldn't be happening

>2) I had another idea. Why not umount the drive and then run fsck.ext3 on the 
>drive. Maybe it needs fsck? When I tried that I got the message:
>  
>
nope - rebuilding happens deep underneath the filesystem.

>A1:~# umount /home/big0
>umount: /home/big0: device is busy
>umount: /home/big0: device is busy
>
>(/dev/md0 is mounted on /home/big0).
>  
>
This just means that some process has a filehandle open on /home/big0
lsof + grep can help to find candidate processes

>A1:~# cat /proc/mdstat
>Personalities : [raid1]
>md0 : active raid1 hdi1[2] hdg1[0]
>      244195904 blocks [2/1] [U_]
>        resync=DELAYED
>md1 : active raid1 hdc1[1]
>      244195904 blocks [2/1] [_U]
>
>md2 : active raid1 hde1[1]
>      244195904 blocks [2/1] [_U]
>
>unused devices: 
>-
>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>  
>

next email:

>I had some more bright ideas and here is what happened:
>
>I am unable to even do ls on the directory mounted on this raid device.
>
>So, I said, maybe the problem is that I need to run fsck.ext3 on the drive 
>first. So I tried to umount it and i got the error message:
>
>A1:~# umount /home/big0
>umount: /home/big0: device is busy
>umount: /home/big0: device is busy
>
>So I said maybe the problem is the rsyncing. So maybe an idea is to fail the 
>new added device /dev/hdi1  and then remove /dev/hdi1, move back to degraded 
>mode. Do an umount of the drive, then do an fsck.ext3 on the drive and then I 
>can do a reboot and then add the drive back in.
>
>Hey why not?
>  
>
'cos I can't figure out what's going on!

>Ok. So I tried: Here is the transcipt of the session:
>
>A1:~# cat /proc/mdstat
>Personalities : [raid1]
>md0 : active raid1 hdi1[2] hdg1[0]
>      244195904 blocks [2/1] [U_]
>        resync=DELAYED
>md1 : active raid1 hdc1[1]
>      244195904 blocks [2/1] [_U]
>
>md2 : active raid1 hde1[1]
>      244195904 blocks [2/1] [_U]
>
>unused devices: <none>
>A1:~# umount /home/big0
>umount: /home/big0: device is busy
>umount: /home/big0: device is busy
>A1:~# whoami
>root
>A1:~# mdadm /dev/md0 -fail /dev/hdi1 --remove /dev/hdi1
>mdadm: hot add failed for /dev/hdi1: Invalid argument
>
>A1:~# cat /proc/mdstat
>Personalities : [raid1]
>md0 : active raid1 hdi1[2] hdg1[0]
>      244195904 blocks [2/1] [U_]
>        resync=DELAYED
>md1 : active raid1 hdc1[1]
>      244195904 blocks [2/1] [_U]
>
>md2 : active raid1 hde1[1]
>      244195904 blocks [2/1] [_U]
>
>unused devices: <none>
>A1:~# mdadm --manage --set-faulty /dev/md0  /dev/hdi1
>mdadm: set /dev/hdi1 faulty in /dev/md0
>A1:~# mdadm --detail /dev/md0
>/dev/md0:
>        Version : 00.90.01
>  Creation Time : Wed Jan 12 14:19:21 2005
>     Raid Level : raid1
>     Array Size : 244195904 (232.88 GiB 250.06 GB)
>    Device Size : 244195904 (232.88 GiB 250.06 GB)
>   Raid Devices : 2
>  Total Devices : 2
>Preferred Minor : 0
>    Persistence : Superblock is persistent
>
>    Update Time : Sun Mar 13 01:28:06 2005
>          State : clean, degraded
> Active Devices : 1
>Working Devices : 1
> Failed Devices : 1
>  Spare Devices : 0
>
>           UUID : 6b8b4567:327b23c6:643c9869:66334873
>         Events : 0.343413
>
>    Number   Major   Minor   RaidDevice State
>       0      34        1        0      active sync   /dev/hdg1
>       1       0        0        -      removed
>
>       2      56        1        1      faulty   /dev/hdi1
>A1:~# mdadm /dev/md0 -r /dev/hdi1
>mdadm: hot remove failed for /dev/hdi1: Device or resource busy
>  
>
could this be mdadm 1.8.1 issue?? it seemed like the right thing to do.

>A1:~# cat /proc/mdstat
>Personalities : [raid1]
>md0 : active raid1 hdi1[2](F) hdg1[0]
>      244195904 blocks [2/1] [U_]
>        resync=DELAYED
>md1 : active raid1 hdc1[1]
>      244195904 blocks [2/1] [_U]
>
>md2 : active raid1 hde1[1]
>      244195904 blocks [2/1] [_U]
>
>unused devices: <none>
>A1:~# mdadm /dev/md0 -r /dev/hdi1
>mdadm: hot remove failed for /dev/hdi1: Device or resource busy
>A1:~#                                                                 
>
>Any ideas on what I can do now?
>  
>
upgrade mdadm and try the remove again.

next email:

>One more bit of information:
>
>this was a bit of info from 
>
>tail /var/log/kern.log
>
>Mar 11 04:42:11 A1 kernel:
>Mar 11 04:42:11 A1 kernel: hdg: drive not ready for command
>Mar 11 04:42:11 A1 kernel: raid1: hdg1: rescheduling sector 215908496
>Mar 11 04:42:11 A1 kernel: raid1: hdg1: redirecting sector 215908496 to 
>anotherr
>Mar 11 04:42:11 A1 kernel: hdg: status error: status=0x58 { DriveReady 
>SeekComp}
>Mar 11 04:42:11 A1 kernel:
>Mar 11 04:42:11 A1 kernel: hdg: drive not ready for command
>Mar 11 04:42:11 A1 kernel: raid1: hdg1: rescheduling sector 215908496
>Mar 11 04:42:11 A1 kernel: raid1: hdg1: redirecting sector 215908496 to 
>
>but that all was from Mar11 and today is Mar13....
>  
>
well, it may explain why things went bad.


I think you need to:
* upgrade mdadm.
* Then cat /proc/mdstat
* then mdadm --detail on all md devices

Then note what md devices are 'important'

Also:
what does mount say?
is the filessytem on /dev/md0 useable (it should be fine)

Is the box safe to reboot?

when you reply to my inline questions, remove all the context to trim 
the mail right down :)

David
