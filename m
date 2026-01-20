Received: from smtp161.vfemail.net (smtp161.vfemail.net [146.59.185.161])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B06B944B693
	for <linux-raid@vger.kernel.org>; Tue, 20 Jan 2026 18:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=146.59.185.161
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768932948; cv=none; b=uxKxEzQnp2olfWVUbdugmwaHKKpG+2rgJLSKlY7/WKcRBGebOMR2GkdWUm9mrlgRcUBS+qZnG7zIGt0SqCRzqEudWNnCkXsRDIE7C6lMzMxNVccdiU7Cf55TcQe7uFcQoVKclBLRMM+8VihiNkfHW1wYQcy9uaR6swJnBNc7IKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768932948; c=relaxed/simple;
	bh=Y04clGZu04wSv/Zi2YEKYx5jgZaltCiKu2rweWBbvVU=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type; b=bO8D9Z145dCLcs8unIrrHMcuqX3QmQv0BDJOTiS51mx0wJdWO3lyOdjOzQHXAejt2pJerfsSyzKVLHfOly8ki0ZC1u0wt4F1n56Gxpgx5nTYUQm6wPJqS7srFVCimmLnTWToSiaHlnXzXpZUmbvQ9xEB/2aPqKRW3Y/Iw95Txkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vfemail.net; spf=pass smtp.mailfrom=vfemail.net; dkim=pass (1024-bit key) header.d=vfemail.net header.i=@vfemail.net header.b=cdqPomVC; arc=none smtp.client-ip=146.59.185.161
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vfemail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vfemail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vfemail.net header.i=@vfemail.net header.b="cdqPomVC"
Received: (qmail 9872 invoked from network); 20 Jan 2026 18:09:02 +0000
Received: from localhost (HELO nl101-3.vfemail.net) ()
  by smtpout.vfemail.net with SMTP; 20 Jan 2026 18:09:02 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=simple; d=vfemail.net; h=date:from
	:to:subject:message-id:mime-version:content-type; s=2018; bh=Y04
	clGZu04wSv/Zi2YEKYx5jgZaltCiKu2rweWBbvVU=; b=cdqPomVCRHqnxFf0aYs
	426GHNkldn+ie7GtF8LLmshh97OkwchMDfOqg94MosxJ286VFxT9C0eIDWD49IHu
	JZsb9ybnjCozzBWKtUxQ9bE6zWVGpjjZn7dzTbhiK3Z5L9HwYrLrnhl1rFYM9OeY
	nPzqwiquprgD5S/D4N6UdFZ8=
Received: (qmail 99026 invoked from network); 20 Jan 2026 12:09:01 -0600
Received: by simscan 1.4.0 ppid: 98877, pid: 98956, t: 0.4027s
         scanners:none
Received: from unknown (HELO bmwxMDEudmZlbWFpbC5uZXQ=) (aGdudGt3aXNAdmZlbWFpbC5uZXQ=@MjE3LjE4Mi4yMDYuNjY=)
  by nl101.vfemail.net with ESMTPA; 20 Jan 2026 18:09:01 -0000
Date: Tue, 20 Jan 2026 13:08:58 -0500
From: David Niklas <simd@vfemail.net>
To: Linux RAID <linux-raid@vger.kernel.org>
Subject: Make test failed raid19check
Message-ID: <20260120130858.3eb31a90@Core-Ultra-2-x20>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.38; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/MCEjl7YKUse2D01F8ifV89u"

--MP_/MCEjl7YKUse2D01F8ifV89u
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello,
Recently, mdadm-4.5 was released. I upgraded my system to the latest
version, uninstalling the packaged mdadm for the new one.

I was particularly interested in using raid19check as you may recall, my
raid6 array developed some errors.

I ran the tests for raid6check and two of them failed.

I've attached the logs.

I'm running Devuan (Debian) Linux with a custom configured kernel.
Nothing special, I just needed the newer features for my GPU.

Here's the output of the "test" command.

# ./test
Warning! Tests are performed on system level mdadm!
If you want to test local build, you need to install it first!
test: skipping tests for multipath, which is removed in upstream 6.8+ kernels
Warning! Test suite will set up systemd environment!
Use "systemctl show-environment" to show systemd environment variables
/root/working/mdadm/tests/func.sh: line 228: systemctl: command not found
Added IMSM_DEVNAME_AS_SERIAL=1 to systemd environment, use "systemctl unset-environment IMSM_DEVNAME_AS_SERIAL=1" to remove it.
/root/working/mdadm/tests/func.sh: line 228: systemctl: command not found
Added IMSM_NO_PLATFORM=1 to systemd environment, use "systemctl unset-environment IMSM_NO_PLATFORM=1" to remove it.
setenforce: SELinux is disabled
Testing on linux-6.14.11-nopreempt-AMDGPU-dav15-noxz kernel
/root/working/mdadm/tests/19raid6auto-repair... Execution time (seconds): 8 FAILED - see /var/tmp/19raid6auto-repair.log and /var/tmp/fail19raid6auto-repair.log for details
  (KNOWN BROKEN TEST: always fails)
/root/working/mdadm/tests/19raid6check... Execution time (seconds): 340 succeeded
/root/working/mdadm/tests/19raid6repair... Execution time (seconds): 8 FAILED - see /var/tmp/19raid6repair.log and /var/tmp/fail19raid6repair.log for details
  (KNOWN BROKEN TEST: always fails)
/root/working/mdadm/tests/19repair-does-not-destroy... Execution time (seconds): 10 succeeded
setenforce: SELinux is disabled
/root/working/mdadm/tests/func.sh: line 237: systemctl: command not found
Removed IMSM_DEVNAME_AS_SERIAL=1 from systemd environment.
/root/working/mdadm/tests/func.sh: line 237: systemctl: command not found
Removed IMSM_NO_PLATFORM=1 from systemd environment.

I think I'll start running the other tests and see what happens with them.

Any ideas on what's going wrong?

Thanks,
David


--MP_/MCEjl7YKUse2D01F8ifV89u
Content-Type: text/x-log
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=fail19raid6repair.log

## Core-Ultra-2-x20: saving dmesg.
[4501074.465567] md/raid:md0: not clean -- starting background reconstruction
[4501074.465590] md/raid:md0: device loop4 operational as raid disk 3
[4501074.465592] md/raid:md0: device loop3 operational as raid disk 2
[4501074.465593] md/raid:md0: device loop2 operational as raid disk 1
[4501074.465594] md/raid:md0: device loop1 operational as raid disk 0
[4501074.465820] md/raid:md0: raid level 6 active with 4 out of 4 devices, algorithm 2
[4501074.465838] md0: detected capacity change from 0 to 71680
[4501074.466242] md: resync of RAID array md0
[4501075.294307] md: md0: resync done.
[4501081.959606] test (31434): drop_caches: 3
[4501082.158217] test (31434): drop_caches: 3
## Core-Ultra-2-x20: saving proc mdstat.
Personalities : [raid0] [linear] [raid1] [raid6] [raid5] [raid4] [raid10] 
md0 : active raid6 loop4[3] loop3[2] loop2[1] loop1[0]
      35840 blocks super 1.2 level 6, 512k chunk, algorithm 2 [4/4] [UUUU]
      
unused devices: <none>
## Core-Ultra-2-x20: mdadm -D /dev/md0
/dev/md0:
           Version : 1.2
     Creation Time : Tue Jan 20 12:51:04 2026
        Raid Level : raid6
        Array Size : 35840 (35.00 MiB 36.70 MB)
     Used Dev Size : 17920 (17.50 MiB 18.35 MB)
      Raid Devices : 4
     Total Devices : 4
       Persistence : Superblock is persistent

       Update Time : Tue Jan 20 12:51:05 2026
             State : clean 
    Active Devices : 4
   Working Devices : 4
    Failed Devices : 0
     Spare Devices : 0

            Layout : left-symmetric
        Chunk Size : 512K

Consistency Policy : resync

              Name : Core-Ultra-2-x20:0  (local to host Core-Ultra-2-x20)
              UUID : 472d803a:08838b9e:c943ddb8:9f55f6f0
            Events : 19

    Number   Major   Minor   RaidDevice State
       0       7        1        0      active sync   /dev/loop1
       1       7        2        1      active sync   /dev/loop2
       2       7        3        2      active sync   /dev/loop3
       3       7        4        3      active sync   /dev/loop4

--MP_/MCEjl7YKUse2D01F8ifV89u
Content-Type: text/x-log
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=19raid6repair.log

+ . /root/working/mdadm/tests/19raid6repair
++ number_of_disks=4
++ chunksize_in_kib=512
++ chunksize_in_b=524288
++ array_data_size_in_kib=4096
++ array_data_size_in_b=4194304
++ devs='/dev/loop1 /dev/loop2 /dev/loop3 /dev/loop4'
++ data_offset_in_kib=1024
++ layouts='ls rs la ra parity-first ddf-zero-restart ddf-N-restart ddf-N-continue 	left-asymmetric-6 right-asymmetric-6 left-symmetric-6 	right-symmetric-6 parity-first-6'
++ for layout in $layouts
++ for failure in "$dev3 3 3 2" "$dev3 3 2 3" "$dev3 3 2 1" "$dev3 3 2 0" "$dev4 3 3 0" "$dev4 3 3 1" "$dev4 3 3 2" "$dev1 3 0 1" "$dev1 3 0 2" "$dev1 3 0 3" "$dev2 3 1 0" "$dev2 3 1 2" "$dev2 3 1 3"
++ failure_split=($failure)
++ device_with_error=/dev/loop3
++ stripe_with_error=3
++ repair_params='3 3 2'
++ start_of_errors_in_kib=2560
++ dd if=/dev/urandom of=/tmp/RandFile bs=1024 count=4096
4096+0 records in
4096+0 records out
4194304 bytes (4.2 MB, 4.0 MiB) copied, 0.0142637 s, 294 MB/s
++ mdadm -CR /dev/md0 -l6 --layout=ls -n4 -c 512 /dev/loop1 /dev/loop2 /dev/loop3 /dev/loop4
++ rm -f /var/tmp/stderr
++ case $* in
++ case $* in
++ for args in $*
++ [[ -CR =~ /dev/ ]]
++ for args in $*
++ [[ /dev/md0 =~ /dev/ ]]
++ [[ /dev/md0 =~ md ]]
++ for args in $*
++ [[ -l6 =~ /dev/ ]]
++ for args in $*
++ [[ --layout=ls =~ /dev/ ]]
++ for args in $*
++ [[ -n4 =~ /dev/ ]]
++ for args in $*
++ [[ -c =~ /dev/ ]]
++ for args in $*
++ [[ 512 =~ /dev/ ]]
++ for args in $*
++ [[ /dev/loop1 =~ /dev/ ]]
++ [[ /dev/loop1 =~ md ]]
++ /sbin/mdadm --zero /dev/loop1
mdadm: Unrecognised md component device - /dev/loop1
++ for args in $*
++ [[ /dev/loop2 =~ /dev/ ]]
++ [[ /dev/loop2 =~ md ]]
++ /sbin/mdadm --zero /dev/loop2
mdadm: Unrecognised md component device - /dev/loop2
++ for args in $*
++ [[ /dev/loop3 =~ /dev/ ]]
++ [[ /dev/loop3 =~ md ]]
++ /sbin/mdadm --zero /dev/loop3
mdadm: Unrecognised md component device - /dev/loop3
++ for args in $*
++ [[ /dev/loop4 =~ /dev/ ]]
++ [[ /dev/loop4 =~ md ]]
++ /sbin/mdadm --zero /dev/loop4
mdadm: Unrecognised md component device - /dev/loop4
++ /sbin/mdadm -CR /dev/md0 -l6 --layout=ls -n4 -c 512 /dev/loop1 /dev/loop2 /dev/loop3 /dev/loop4
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md0 started.
++ rv=0
++ case $* in
++ cat /var/tmp/stderr
++ return 0
++ dd if=/tmp/RandFile of=/dev/md0 bs=1024 count=4096
4096+0 records in
4096+0 records out
4194304 bytes (4.2 MB, 4.0 MiB) copied, 0.0321578 s, 130 MB/s
++ blockdev --flushbufs /dev/md0
++ sync
++ check wait
++ case $1 in
+++ cat /proc/sys/dev/raid/speed_limit_min
++ min=100
+++ cat /proc/sys/dev/raid/speed_limit_max
++ max=500
++ echo 200000
++ sleep 0.1
++ iterations=0
++ '[' 0 -le 10 ']'
+++ grep -Ec '(resync|recovery|reshape|check|repair) *=' /proc/mdstat
++ sync_action=1
++ ((  1 == 0  ))
++ break
++ echo 'Reshape has not started after 10 seconds'
Reshape has not started after 10 seconds
++ echo 'Waiting for grow-continue to finish'
Waiting for grow-continue to finish
++ wait_for_reshape_end
++ true
+++ grep -Ec '(resync|recovery|reshape|check|repair) *=' /proc/mdstat
++ sync_action=1
++ ((  1 != 0  ))
++ sleep 2
++ continue
++ true
+++ grep -Ec '(resync|recovery|reshape|check|repair) *=' /proc/mdstat
++ sync_action=0
++ ((  0 != 0  ))
+++ pgrep -f 'mdadm --grow --continue'
++ [[ '' != '' ]]
++ break
++ sleep 5
++ wait_for_reshape_end
++ true
+++ grep -Ec '(resync|recovery|reshape|check|repair) *=' /proc/mdstat
++ sync_action=0
++ ((  0 != 0  ))
+++ pgrep -f 'mdadm --grow --continue'
++ [[ '' != '' ]]
++ break
++ echo 100
++ echo 500
++ blockdev --flushbufs /dev/loop1 /dev/loop2 /dev/loop3 /dev/loop4
++ sync
++ echo 3
++ cmp -s -n 4194304 /dev/md0 /tmp/RandFile
++ dd if=/dev/urandom of=/dev/loop3 bs=1024 count=512 seek=2560
512+0 records in
512+0 records out
524288 bytes (524 kB, 512 KiB) copied, 0.00223738 s, 234 MB/s
++ blockdev --flushbufs /dev/loop3
++ sync
++ echo 3
++ /raid6check /dev/md0 0 0
++ grep -qs Error
++ echo should detect errors
should detect errors
++ exit 2

--MP_/MCEjl7YKUse2D01F8ifV89u
Content-Type: text/x-log
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=fail19raid6auto-repair.log

## Core-Ultra-2-x20: saving dmesg.
[4500726.128927] md/raid:md0: not clean -- starting background reconstruction
[4500726.128949] md/raid:md0: device loop4 operational as raid disk 4
[4500726.128951] md/raid:md0: device loop3 operational as raid disk 3
[4500726.128952] md/raid:md0: device loop2 operational as raid disk 2
[4500726.128953] md/raid:md0: device loop1 operational as raid disk 1
[4500726.128954] md/raid:md0: device loop0 operational as raid disk 0
[4500726.129347] md/raid:md0: raid level 6 active with 5 out of 5 devices, algorithm 2
[4500726.129362] md0: detected capacity change from 0 to 107520
[4500726.129513] md: resync of RAID array md0
[4500726.903794] md: md0: resync done.
[4500733.827662] test (26245): drop_caches: 3
[4500734.121635] test (26245): drop_caches: 3
## Core-Ultra-2-x20: saving proc mdstat.
Personalities : [raid0] [linear] [raid1] [raid6] [raid5] [raid4] [raid10] 
md0 : active raid6 loop4[4] loop3[3] loop2[2] loop1[1] loop0[0]
      53760 blocks super 1.2 level 6, 512k chunk, algorithm 2 [5/5] [UUUUU]
      
unused devices: <none>
## Core-Ultra-2-x20: mdadm -D /dev/md0
/dev/md0:
           Version : 1.2
     Creation Time : Tue Jan 20 12:45:15 2026
        Raid Level : raid6
        Array Size : 53760 (52.50 MiB 55.05 MB)
     Used Dev Size : 17920 (17.50 MiB 18.35 MB)
      Raid Devices : 5
     Total Devices : 5
       Persistence : Superblock is persistent

       Update Time : Tue Jan 20 12:45:16 2026
             State : clean 
    Active Devices : 5
   Working Devices : 5
    Failed Devices : 0
     Spare Devices : 0

            Layout : left-symmetric
        Chunk Size : 512K

Consistency Policy : resync

              Name : Core-Ultra-2-x20:0  (local to host Core-Ultra-2-x20)
              UUID : 43e4b762:7978a8e7:59af7d77:2747b753
            Events : 19

    Number   Major   Minor   RaidDevice State
       0       7        0        0      active sync   /dev/loop0
       1       7        1        1      active sync   /dev/loop1
       2       7        2        2      active sync   /dev/loop2
       3       7        3        3      active sync   /dev/loop3
       4       7        4        4      active sync   /dev/loop4

--MP_/MCEjl7YKUse2D01F8ifV89u
Content-Type: text/x-log
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=19raid6auto-repair.log

+ . /root/working/mdadm/tests/19raid6auto-repair
++ number_of_disks=5
++ chunksize_in_kib=512
++ chunksize_in_b=524288
++ array_data_size_in_kib=7680
++ array_data_size_in_b=7864320
++ devs='/dev/loop0 /dev/loop1 /dev/loop2 /dev/loop3 /dev/loop4'
++ data_offset_in_kib=1024
++ dd if=/dev/urandom of=/tmp/RandFile bs=1024 count=7680
7680+0 records in
7680+0 records out
7864320 bytes (7.9 MB, 7.5 MiB) copied, 0.0342983 s, 229 MB/s
++ layouts='ls rs la ra parity-first ddf-zero-restart ddf-N-restart ddf-N-continue 	left-asymmetric-6 right-asymmetric-6 left-symmetric-6 	right-symmetric-6 parity-first-6'
++ for layout in $layouts
++ mdadm -CR /dev/md0 -l6 --layout=ls -n5 -c 512 /dev/loop0 /dev/loop1 /dev/loop2 /dev/loop3 /dev/loop4
++ rm -f /var/tmp/stderr
++ case $* in
++ case $* in
++ for args in $*
++ [[ -CR =~ /dev/ ]]
++ for args in $*
++ [[ /dev/md0 =~ /dev/ ]]
++ [[ /dev/md0 =~ md ]]
++ for args in $*
++ [[ -l6 =~ /dev/ ]]
++ for args in $*
++ [[ --layout=ls =~ /dev/ ]]
++ for args in $*
++ [[ -n5 =~ /dev/ ]]
++ for args in $*
++ [[ -c =~ /dev/ ]]
++ for args in $*
++ [[ 512 =~ /dev/ ]]
++ for args in $*
++ [[ /dev/loop0 =~ /dev/ ]]
++ [[ /dev/loop0 =~ md ]]
++ /sbin/mdadm --zero /dev/loop0
mdadm: Unrecognised md component device - /dev/loop0
++ for args in $*
++ [[ /dev/loop1 =~ /dev/ ]]
++ [[ /dev/loop1 =~ md ]]
++ /sbin/mdadm --zero /dev/loop1
mdadm: Unrecognised md component device - /dev/loop1
++ for args in $*
++ [[ /dev/loop2 =~ /dev/ ]]
++ [[ /dev/loop2 =~ md ]]
++ /sbin/mdadm --zero /dev/loop2
mdadm: Unrecognised md component device - /dev/loop2
++ for args in $*
++ [[ /dev/loop3 =~ /dev/ ]]
++ [[ /dev/loop3 =~ md ]]
++ /sbin/mdadm --zero /dev/loop3
mdadm: Unrecognised md component device - /dev/loop3
++ for args in $*
++ [[ /dev/loop4 =~ /dev/ ]]
++ [[ /dev/loop4 =~ md ]]
++ /sbin/mdadm --zero /dev/loop4
mdadm: Unrecognised md component device - /dev/loop4
++ /sbin/mdadm -CR /dev/md0 -l6 --layout=ls -n5 -c 512 /dev/loop0 /dev/loop1 /dev/loop2 /dev/loop3 /dev/loop4
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md0 started.
++ rv=0
++ case $* in
++ cat /var/tmp/stderr
++ return 0
++ dd if=/tmp/RandFile of=/dev/md0 bs=1024 count=7680
7680+0 records in
7680+0 records out
7864320 bytes (7.9 MB, 7.5 MiB) copied, 0.0407638 s, 193 MB/s
++ blockdev --flushbufs /dev/md0
++ sync
++ check wait
++ case $1 in
+++ cat /proc/sys/dev/raid/speed_limit_min
++ min=100
+++ cat /proc/sys/dev/raid/speed_limit_max
++ max=500
++ echo 200000
++ sleep 0.1
++ iterations=0
++ '[' 0 -le 10 ']'
+++ grep -Ec '(resync|recovery|reshape|check|repair) *=' /proc/mdstat
++ sync_action=1
++ ((  1 == 0  ))
++ break
++ echo 'Reshape has not started after 10 seconds'
Reshape has not started after 10 seconds
++ echo 'Waiting for grow-continue to finish'
Waiting for grow-continue to finish
++ wait_for_reshape_end
++ true
+++ grep -Ec '(resync|recovery|reshape|check|repair) *=' /proc/mdstat
++ sync_action=1
++ ((  1 != 0  ))
++ sleep 2
++ continue
++ true
+++ grep -Ec '(resync|recovery|reshape|check|repair) *=' /proc/mdstat
++ sync_action=0
++ ((  0 != 0  ))
+++ pgrep -f 'mdadm --grow --continue'
++ [[ '' != '' ]]
++ break
++ sleep 5
++ wait_for_reshape_end
++ true
+++ grep -Ec '(resync|recovery|reshape|check|repair) *=' /proc/mdstat
++ sync_action=0
++ ((  0 != 0  ))
+++ pgrep -f 'mdadm --grow --continue'
++ [[ '' != '' ]]
++ break
++ echo 100
++ echo 500
++ blockdev --flushbufs /dev/loop0 /dev/loop1 /dev/loop2 /dev/loop3 /dev/loop4
++ sync
++ echo 3
++ cmp -s -n 7864320 /dev/md0 /tmp/RandFile
++ dd if=/dev/urandom of=/dev/loop0 bs=1024 count=2560 seek=1024
2560+0 records in
2560+0 records out
2621440 bytes (2.6 MB, 2.5 MiB) copied, 0.0104878 s, 250 MB/s
++ dd if=/dev/urandom of=/dev/loop1 bs=1024 count=2560 seek=3584
2560+0 records in
2560+0 records out
2621440 bytes (2.6 MB, 2.5 MiB) copied, 0.00968777 s, 271 MB/s
++ dd if=/dev/urandom of=/dev/loop2 bs=1024 count=2560 seek=6144
2560+0 records in
2560+0 records out
2621440 bytes (2.6 MB, 2.5 MiB) copied, 0.0147139 s, 178 MB/s
++ dd if=/dev/urandom of=/dev/loop3 bs=1024 count=2560 seek=8704
2560+0 records in
2560+0 records out
2621440 bytes (2.6 MB, 2.5 MiB) copied, 0.0108583 s, 241 MB/s
++ dd if=/dev/urandom of=/dev/loop4 bs=1024 count=2560 seek=11264
2560+0 records in
2560+0 records out
2621440 bytes (2.6 MB, 2.5 MiB) copied, 0.0121655 s, 215 MB/s
++ blockdev --flushbufs /dev/loop0 /dev/loop1 /dev/loop2 /dev/loop3 /dev/loop4
++ sync
++ echo 3
++ /raid6check /dev/md0 0 0
++ grep -qs Error
++ echo should detect errors
should detect errors
++ exit 2

--MP_/MCEjl7YKUse2D01F8ifV89u--
