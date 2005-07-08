From: Tyler <pml@dtbb.net>
Subject: Re: RAID1 assembly requires manual "mdadm --run"
Date: Fri, 08 Jul 2005 16:12:09 -0700
Message-ID: <42CF0849.1000103@dtbb.net>
References: <200506261621.01799.mlaks@verizon.net>	 <62b0912f05070623185b90e732@mail.gmail.com>	 <17102.26306.174427.502866@cse.unsw.edu.au> <62b0912f05070811386bf7c72d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <62b0912f05070811386bf7c72d@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Molle Bestefich <molle.bestefich@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Molle Bestefich wrote:

>On 7/8/05, Neil Brown <neilb@cse.unsw.edu.au> wrote:
>  
>
>>On Thursday July 7, molle.bestefich@gmail.com wrote:
>>    
>>
>>>Mitchell Laks wrote:
>>>      
>>>
>>>>However I think that raids should boot as long as they are intact, as a matter
>>>>of policy. Otherwise we lose our  ability to rely upon them for remote
>>>>servers...
>>>>        
>>>>
>>>It does seem wrong that a RAID 5 starts OK with a disk missing, but a
>>>RAID 1 fails.
>>>
>>>Perhaps MD is unable to tell which disk in the RAID 1 is the freshest
>>>and therefore refuses to assemble any RAID 1's with disks missing?
>>>      
>>>
>>This doesn't sound right at all.
>>
>>"--run" is required to start a degraded array as a way of confirming
>>to mdadm that you really have listed all the drives available.
>>The normal way of starting an array at boot time is by describing the
>>array (usually by UUID) in mdadm.conf and letting mdadm find the
>>component devices with "mdadm --assemble --scan".
>>
>>This usage does not require --run.
>>
>>The only time there is a real reluctance to start a degraded array is
>>when it is raid5/6 and it suffered an unclean shutdown.
>>A dirty, degraded raid5/6 can have undetectably data corruption, and I
>>really want you to be aware of that and not just assume that "because
>>it started, the data must be OK".
>>    
>>
>
>Sounds very sane.
>
>So a clean RAID1 with a disk missing should start without --run, just
>like a clean RAID5 with a disk missing?
>
>Nevermind, I'll try to reproduce it instead of asking too many questions.
>And I suck a bit at testing MD with loop devices, so if someone could
>pitch in and tell me what I'm doing wrong here, I'd appreciate it very
>much (-:
>
># mknod /dev/md0 b 9 0
># dd if=/dev/zero of=test1 bs=1M count=100
># dd if=/dev/zero of=test2 bs=1M count=100
># dd if=/dev/zero of=test3 bs=1M count=100
># losetup /dev/loop1 test1
># losetup /dev/loop2 test2
># losetup /dev/loop3 test3
># mdadm --create /dev/md0 -l 1 -n 3 /dev/loop1 /dev/loop2 /dev/loop3
>mdadm: array /dev/md0 started.
>
># mdadm --detail --scan > /etc/mdadm.conf
># cat /etc/mdadm.conf
>ARRAY /dev/md0 level=raid1 num-devices=3
>   UUID=1dcc972f:0b856580:05c66483:e14940d8
>   devices=/dev/loop/1,/dev/loop/2,/dev/loop/3
>  
>
Why does this show /dev/loop/1 instead of /dev/loop1 ?

># mdadm --stop /dev/md0
># mdadm --assemble --scan
>mdadm: no devices found for /dev/md0
>
>// ^^^^^^^^^^^^^^^^^^^^^^^^  ??? Why?
>
># mdadm --assemble /dev/md0 /dev/loop1 /dev/loop2 /dev/loop3
>mdadm: /dev/md0 has been started with 3 drives.
>
>// So far so good..
>
># mdadm --stop /dev/md0
># losetup -d /dev/loop3
># mdadm --assemble /dev/md0 /dev/loop1 /dev/loop2 /dev/loop3
>mdadm: no RAID superblock on /dev/loop7
>mdadm: /dev/loop7 has no superblock - assembly aborted
>  
>
Where's loop7 coming from all of a sudden? I thought you were using 
loop1, loop2, loop3

>// ^^^^^^^^^^^^^^^^^^^^^^^^  ??? It aborts :-(...
>// Doesn't an inactive loop device seem the same as a missing disk to MD?
>
># rm -f /dev/loop3
># mdadm --assemble /dev/md0 /dev/loop1 /dev/loop2 /dev/loop3
>mdadm: cannot open device /dev/loop7: No such file or directory
>mdadm: /dev/loop7 has no superblock - assembly aborted
>  
>
Once again, where is loop7 coming from?

>// ^^^^^^^^^^^^^^^^^^^^^^^^  ??? It aborts, just as above...
>
>Hm!
>-
>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>  
>
