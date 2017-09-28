From: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Subject: What is the proper way to start an array with many failed (but good)
 disks
Date: Thu, 28 Sep 2017 17:48:50 +1000
Message-ID: <6dba3e31-5c37-5a53-09a5-df8c95991a7a@eyal.emu.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-AU
Sender: linux-raid-owner@vger.kernel.org
To: list linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I have a raid6 with 7 disks and the controller had a bad cable connection
so 4 disks failed concurrently. They were now marked (S) as expected.

I had to power the server down to adjust the cabling then all 7 disks
were seen and available, and naturally the array was not started.
	md: kicking non-fresh sde1 from array!
	md: kicking non-fresh sdf1 from array!
	md: kicking non-fresh sdc1 from array!
	md: kicking non-fresh sdd1 from array!
	md/raid:md127: device sdi1 operational as raid disk 6
	md/raid:md127: device sdg1 operational as raid disk 4
	md/raid:md127: device sdh1 operational as raid disk 5
	md/raid:md127: not enough operational devices (4/7 failed)
	md/raid:md127: failed to run raid set.

No array in /proc/mdstat.

--examin'ing the disks was as expected, sd[c-f]1 have 7139731 events and
sd[g-i] have 7140079. There was not much activity on this device then.

Q) What is the correct way to re-add all the disks?
When I have only one disk fail, I simply --fail/--remove then --re-add it.

I re-read the doco and it seems that there is an option for
	mdadm --re-add /dev/md127 missing

Q) Will this find all the failed members? Can it run on an array that does
not yet exist?

In this case I needed to somehow assemble the array. Should

I ended doing these two:
	# mdadm --assemble --force /dev/md127
This did not do what I expected, which was to assemble the array with 4
spare (or failed) members, ready to be revived.
It instead said that the event count was raised on the failed disks to
the level of the good ones but did not assemble the array.
I thought that changing the event count is bad since it forgets important
status information (unless the log has this info).

	# mdadm --assemble /dev/md127
This started the array. No recovery in /proc/mdstat:
	md127 : active raid6 sdc1[14] sdi1[8] sdh1[12] sdg1[13] sdf1[7] sde1[9] sdd1[10]
	      19534425600 blocks super 1.2 level 6, 512k chunk, algorithm 2 [7/7] [UUUUUUU]
	      bitmap: 0/30 pages [0KB], 65536KB chunk

The messages log had:
	md127: bitmap file is out of date (7139731 < 7140079) -- forcing full recovery
	md127: bitmap file is out of date, doing full recovery
	md127: detected capacity change from 0 to 20003251814400
and I do not know which of the two command provoked this, I assume the second one.

Q) What does "forcing/doing full recovery" mean?

My current controller is unstable so after I install a new controller
I will do an array 'check'.

TIA

-- 
Eyal Lebedinsky (eyal@eyal.emu.id.au)
