From: Jon Robison <narfman0@gmail.com>
Subject: mdadm raid5 single drive fail, single drive out of sync terror
Date: Wed, 26 Nov 2014 10:08:12 -0500
Message-ID: <5475ECDC.6070309@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all!

I upgraded to mdadm-3.3-7.fc20.x86_64, and my raid5 array would no 
longer recognize /dev/sdb1 in my raid 5 array (which is normally 
/dev/sd[b-f]1). I `mdadm --detail --scan`,  which resulted in a degraded 
array, then added /dev/sdb1, and it started rebuilding happily until 25% 
or so, when another failure seemed to occur.

I am convinced the data is fine on /dev/sd[c-f]1, and that somehow I 
just need to inform mdadm about that, but they got out of sync and 
/dev/sde1 thinks the array is AAAAA while the others think its AAA.. . 
The drives also seem to think e is bad because f said e was bad or some 
weird stuff, and sde1 is behind by ~50 events or so. That error hasn't 
shown itself recently. I fear sdb is bad and sde is going to go soon.

Results of `mdadm --examine /dev/sd[b-f]1` are here 
http://dpaste.com/2Z7CPVY

I'm scared and alone. Everything is off and sitting as above, though e 
50 events behind and out of synch. New drives coming Friday and backup 
is of course a bit old. I'm petrified to execute `mdadm --create 
--assume-clean --level=5 --raid-devices=5 /dev/md0 /dev/sdf1 /dev/sdd1 
/dev/sdc1 /dev/sde1 missing`, but that seems my next option unless ya'll 
know better. I tried `mdadm --assemble -f /dev/md0 /dev/sdf1 /dev/sdd1 
/dev/sdc1 /dev/sde1` and it said something like can't start with only 3 
devices (which I wouldn't expect because examine still shows 4, just 
that they are out of sync and I thought that was -f's express purpose in 
assemble mode). Anyone have any suggestions? Thanks!
