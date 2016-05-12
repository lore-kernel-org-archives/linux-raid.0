From: Claudiu Rad <jazzman@misalpina.net>
Subject: recovering failed and unrecognizable RAID5 during mdadm --grow
 without backup
Date: Thu, 12 May 2016 09:22:17 +0300
Message-ID: <1b26650f-0b2c-2485-f781-e3fd26340741@misalpina.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

hello all,

i am a desperate guy that 'successfully' made a chain of mistakes 
leading to a real personal disaster. i need to try recover this as much 
as i can as total data loss is really not acceptable.
the short story is that having a weak performance 4x4TB RAID5 (full 
drives allocated to RAID5 besides the small RAID1 partitions for boot) + 
LVM, after reading a few articles on the internet, i figured out i 
should try some chunk size 'optimizations' and read that this can be 
done with my version of mdadm and my kernel (machine running debian 7.9).
the mistakes:

 1. no backup of 10TB of data. i am talking about a remote rented
    server, and didn't had any easy way to do backups
 2. i did run mdadm --grow -c 128 /dev/md2, it complained about
    --backup-file. run the command again with the file placed in
    /root/...txt, this being a partition inside the vg0 filling
    /dev/md2, thus defeating the purpose. the chunk size was
    automatically set to 512K before, i was trying to reduce it
 3. the command returned almost immediately, didn't have any idea that
    this would trigger a background process, although it is now obvious.
    i then tried to see what it has done but after a ls, a second ls in
    root partition was hanging. my web server panel (webmin) hanged in
    'waiting for...'; tried connecting to a new shell, after providing
    credentials, hanging, no cursor. i thought that my ever running
    monitoring system and some other constant I/O processes running with
    higher priority were clogging the system that now had lower
    throughput due to parameter change and entire I/O was filled because
    of this and maybe my experiments with the scheduler. actually nginx
    webserver seemed to be working properly and this had nice -10
    attached, which led me to this conclusion. another mistake
 4. after a few minutes of unresponsive machine, decided to send a soft
    CTRL+ALT+DELETE restart signal from datacenter control panel but it
    wouldn't work apparently, thus, decided there is no way to exit this
    situation unless using a hard restart (system reset), and this was
    my final and big mistake not knowing that the array was reshaping.
    the system won't boot and datacenter's rescue (network boot) system
    can't see/assemble the /dev/md2 array

i assume i really did the best to destroy a working array (well, besides 
not being satisfied with performance and apparent degradation during 
time). into the rescue system, this is what i see so far:


root@rescue ~ # mdadm --detail --scan
ARRAY /dev/md/0 metadata=1.2 name=rescue:0 
UUID=63b58acc:19623c52:c1134929:5d592d29
ARRAY /dev/md/1 metadata=1.2 name=rescue:1 
UUID=94713b26:3eca44bc:dee330c8:23443240

root@rescue ~ # mdadm --examine --scan
ARRAY /dev/md/0  metadata=1.2 UUID=63b58acc:19623c52:c1134929:5d592d29 
name=rescue:0
ARRAY /dev/md/1  metadata=1.2 UUID=94713b26:3eca44bc:dee330c8:23443240 
name=rescue:1
ARRAY /dev/md/2  metadata=1.2 UUID=a935894f:be435fc0:589c1c7f:d5454b43 
name=rescue:2
(so here the array appears)

root@rescue ~ # cat /proc/mdstat
Personalities : [raid1]
md1 : active raid1 sda2[0] sdd2[3] sdc2[2] sdb2[1]
       523968 blocks super 1.2 [4/4] [UUUU]
md0 : active raid1 sda1[0] sdd1[3] sdc1[2] sdb1[1]
       16768896 blocks super 1.2 [4/4] [UUUU]

root@rescue ~ # mdadm --assemble --scan
mdadm: /dev/md/0 has been started with 4 drives.
mdadm: /dev/md/1 has been started with 4 drives.
mdadm: Failed to restore critical section for reshape, sorry.
        Possibly you needed to specify the --backup-file
Segmentation fault
(this segmentation fault is weird)

root@rescue ~ # mdadm --assemble --scan --invalid-backup
mdadm: /dev/md/2: Need a backup file to complete reshape of this array.
mdadm: Please provided one with "--backup-file=..."

root@rescue ~ # mdadm -V
mdadm - v3.3.2 - 21st August 2014


now.. what can i best do to try as much as i can to recover my array? 
the backup is actually trapped inside the / partition in the vg0 in the 
array. after starting the --grow, i estimate it has been running for 
about 10minutes when i did a force reboot. how can this be reconstructed 
properly? i have broken it enough, i don't want to make any other move 
without asking experts.

please, help. this is my greatest nightmare :(

-- 
Claudiu

