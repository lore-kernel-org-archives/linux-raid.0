From: Asdo <asdo@shiftmail.org>
Subject: Re: raid5: cannot start dirty degraded array
Date: Wed, 23 Dec 2009 22:10:12 +0100
Message-ID: <4B328734.2030201@shiftmail.org>
References: <579884013.20091223125023@kaneda.iguw.tuwien.ac.at>
 <52151829.20091223135001@kaneda.iguw.tuwien.ac.at>
 <70ed7c3e0912230525h25566bd8jae95ffab149caf65@mail.gmail.com>
 <953553783.20091223144402@kaneda.iguw.tuwien.ac.at>
 <70ed7c3e0912230548v1abacfcciadaab2888018b202@mail.gmail.com>
 <927342042.20091223150200@kaneda.iguw.tuwien.ac.at>
 <70ed7c3e0912230604m55eb6225sf68a819c6025e7b@mail.gmail.com>
 <1913939922.20091223153028@kaneda.iguw.tuwien.ac.at>
 <4B322DE7.5010403@shiftmail.org>
 <1339530534.20091223201649@kaneda.iguw.tuwien.ac.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <1339530534.20091223201649@kaneda.iguw.tuwien.ac.at>
Sender: linux-raid-owner@vger.kernel.org
To: Rainer Fuegenstein <rfu@kaneda.iguw.tuwien.ac.at>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Rainer Fuegenstein wrote:
> hi,
>
> A> The --assemble --force needs correct order of drives to be specified!?!?
> A> I think it autodetects that
> A> (would be EXTREMELY RISKY otherwise...)
>
> oops, I didn't care about the order when --assembling :-(
>   
And it didn't blow up, so I was right :-D

> A> Rainer, just after starting the array you can:
> A>   mdadm --readonly /dev/md0
> A> so to be sure that no writes ever happen and a resync does not happen.
> A> I suggest to take data out before doing any modifications (such as a
> A> resync), if you can.
>
> tnx for the hint! have it mounted r/w right now, still copying the
> most important data to other media (for the next 24hours or so). do
> you think that I may run into any troubles if I unmount, reboot,
> re-assemble and mount r/o ?
>   
Probably you can put it readonly right now, with xfs already mounted. Or 
better you can put readonly the filesystem first, then the array: this 
is probably safer. (mount -o remount,ro ... then mdadm --readonly 
/dev/md0).

Hmm on second thought the raid device might refuse to go readonly if the 
filesystem is mounted.... but you can try and see, it shouldn't be risky.

Also do not reboot, and do not stop the array (it works so don't fix it 
:-D ). In the worst case you will have to unmount the filesystem, put 
the array readonly, then remount the filesystem with -o 
ro,nobarrier,norecovery .

> A> As MB suggests, it's better to keep the the most recently failed drive
> A> out of the array if possible, in order to have more coherent data. Also  
> A> true when you are going to add the first spare (that will cause a resync 
> A> and regeneration of one disk).
>
> since the bad sda is included at the moment - is it safe to remove it
> with mdadm /dev/md0 -r /dev/sda1 ?
>   
I'm not sure... your mdstat

  # cat /proc/mdstat
  Personalities : [raid6] [raid5] [raid4]
  md0 : active raid5 sdb1[0] sdc1[3] sdd1[1]
        4395407808 blocks level 5, 64k chunk, algorithm 2 [4/3] [UU_U]

shows sda1 is not included. (Probably resync started upon assemble and 
sda1 failed just immediately)
In addition the array is already degraded and it's a raid5 so you cannot 
remove another device: that would bring it down.

I'd try to put it readonly and then continue your backup.

Should you ever need to reassemble that array, I would specify the 
drives explicitly (as opposed to using --scan) and keep sda1 out of the 
list, as suggested by Majed B., like

  mdadm --assemble --force /dev/md0 /dev/sdb1 /dev/sdc1 /dev/sdd1

then put it readonly, remount, and continue your backup. After backup completed you can add sda1 but I would probably add it as a new spare, e.g. clearing the superblock first. (That drive / controller / cabling might be defective though... I'm not sure on how to interpret your dmesg.)


Merry Christmas everybody!

Asdo
