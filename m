From: Alvaro Figueroa <fede2@fuerzag.ulatina.ac.cr>
Subject: raidreconf on linux sparc64
Date: Thu, 27 May 2004 10:35:57 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40B618ED.4020005@fuerzag.ulatina.ac.cr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

(Please keep me on the CC, as I'm not subscribed to this mailing list)

As I was testing software raids on linux sparc64 with 2.6 kernels[1] for 
the Splack distribution[2] I noticed that raidreconf won't work. I did 
try to look at the problem, but I'm afraid my skills won't go there.

My old raidtab[3], is a raid0 with only two drives, and I'm trying to 
get it to that the new raidtab[4] has, wich is the same raid0 but I 
added four more drives. When I run "raidreconf  -o oldraidtab -n 
newraidtab -m /dev/md0", I get "Your on-disk array MUST be clean first". 
I googled, but it had only happen to one guy, and it had been adviced to 
stop the raid (mine is stopped).

Any clues? Is it a sparc64 thing?

Ohh, I did tried with a 2.4.26 kernel as well, with the same result.

[1] The hardware is an Enterprise 250 with one processor, 256M or ram, 6 
scsi drives splitted among two controllers running a kernel kernel 2.6.6 
compiled with gcc 3.3.3 (from gentoo).
[2] Slackware for sparc port.
[3]
raiddev /dev/md0
           raid-level      0
           nr-raid-disks   2
           nr-spare-disks  0
           persistent-superblock 1
           chunk-size      32
device /dev/sdc1
raid-disk       0
device /dev/sdd1
raid-disk       1
[4]
raiddev /dev/md0
           raid-level      0
           nr-raid-disks   6
           nr-spare-disks  0
           persistent-superblock 1
           chunk-size      32
device /dev/sdc1
raid-disk       0
device /dev/sdd1
raid-disk       1
device /dev/sde1
raid-disk       2
device /dev/sdf1
raid-disk       3
device /dev/sdg1
raid-disk       4
device /dev/sdh1
raid-disk       5

-- 
Alvaro Figueroa
