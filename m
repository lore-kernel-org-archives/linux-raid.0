From: raz ben yehuda <raziebe@gmail.com>
Subject: Subject: Raid0 Reshape . Preface
Date: Wed, 17 Jun 2009 00:51:12 +0300
Message-ID: <1245189072.3478.92.camel@raz>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux raid <linux-raid@vger.kernel.org>, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

Neil Hello
This email is followed by a set of the raid0 reshape patches for your inspection.
hopefully i haven't mess anything in this set.

#1 Tests.
Most tests were conducted on 2.6.30-rc4 (i ported to 2.6.30-rc7
				 and made some sanity checks).

. Multiple zoned raid0 to a new multipled zoned raid0 
		(triggered by adding a disk).
. Online reshape
  . I copied while reshaping and performed a cksum over all files while reshaping.
  . Once a reshape is complete; Reboot and assemble the raid and re-check the files.

. Resume reshape
	.Stop reshape gracefully reboot and continue from same position.
	.Stop reshape gracefully , stop raid, re-assemble . reshape resumes automatically.
 	.Power off machine abruptly by unplugging the power cable.
			check resume and checksum of content known to be ok. (on ext3 though).
	. Graceful stop. assemble and resume, unplug cable, boot and re-assemble. checksum files.

. backward compatibility.
	. Once a reshape is complete, boot to kernel 2.6.18-8.el5 ,mount , and checksum files.
. Big volume reshape. 1/2TB reshape ( 10 hours reshape ).
. Big chunks .200M
. Non power 2 chunks 1K,101K,7001K.
. power 2 chunks. 64K and 1024K.
. USB disks.
. SATA disks.
. Meta data. 0.9,1,1.0,1.1,1.2
. add disk , reshape, add new disk, reshape again without booting.
. two raid0 reshaped. ( reshape is queued ).
. checked with lockdep.

#2 patch set description
	I apply these patches on top of 2.6.30-rc7 :
	
	. for md.c
	
	commit fd894e80a4e368e49c393463986a5d9f5ab16bd9
	Author: NeilBrown <neilb@suse.de>
	Date:   Thu Jun 4 15:23:11 2009 +1000

	. for raid0.c

	commit c9aaceea6015213e571761c0f0899614863c4868
	Author: NeilBrown <neilb@suse.de>
	Date:   Thu Jun 4 15:11:14 2009 +1000
	
	. for raid0.h

	commit c3b56cacfab1ababe07e401ac7b515463a7d2ae6
	Author: NeilBrown <neilb@suse.de>
	Date:   Thu Jun 4 13:49:55 2009 +1000
		

	patch 1: md assumes all personalities members are of the same size.
		fix this just for raid0.

	patch 2: have find_zone return NULL instead of reporting a bug.
		 It is us up to the use decide what to do. reshape uses 
		 find_zone to check end of reshape.	
	
	patch 3: raid0_size to support reshape.
	
	patch 4: replace dump_zones name to print_conf , accept device name
		 as a parameter, reshape prints the new configuration before
		 starting.

	patch 5: beautify create_strip and split raid0_run. have this procedures accept
		 conf and not mddev and a list of device members.
	
	patch 6: remove redudnant argument from is_in_chunk_boundary

	patch 7: have map_sector get raid0_conf struct  instead of mddev
	
	patch 8: split raid0_make_request to a make_request core and raid0_make_request wrapper. 
			reshape used the core make_request.

	patch 9: add hot_add_disk and hot_remove_disk.

	patch 10: reshape core code.

	patch 11: reshape structures. header file.
	
	patch 12: wrap reshape code ifdefs

	patch 13: add kconfig button :experimental: adding drives for raid0 
	
	patch 1: mdadm to support add and reshape for raid0.

#3 Errata:
	1. raid0d remains after a reshape is done. 
		raid0d exists only to stop/start raid0_sync.
	2. md is still aware to level 0.
	3. when a reshape starts, md tries to remove the new busy disk. currently I refuse
		to do it.
	4. I cannot add raid5 as a member to a raid0 ( or raid5 to a raid5 ).
		mdadm reports device is busy. hamm...though common to all other personalities,
		it is quite a problem. 
		
#4 My Todo List
	. Fix addition of raid5 as member of raid0.
	. Replace the reverse mapping with an algorithm.
	. Support reshape driven from a change in its members size, 
		and not just because of a new member. This is most important
		for raid50.
	. Support asymmetric chunk sizes. ( each component has a different chunk size ).
		if I assume raid5 may grow by adding a disk, I will have two different 
		chunks sizes.
	. Parallel reshape, have two reshapes over two raids or more run concurrently.
 
#5  Management
	. Other than me, who else is going to test this code ?



