From: Yi Zhang <yizhan@redhat.com>
Subject: RAID4/5/6 reshape grow stuck
Date: Mon, 7 Sep 2015 08:19:53 -0400 (EDT)
Message-ID: <1025553941.22272591.1441628393915.JavaMail.zimbra@redhat.com>
References: <1007334923.22262755.1441626807144.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1007334923.22262755.1441626807144.JavaMail.zimbra@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil

When testing 07revert-grow, found the RAID4/5/6 grow stuck issue, pls check below info:

Steps:
mdadm --quiet -CR --assume-clean /dev/md0 -l6 -n4 -x1 /dev/loop0 /dev/loop1 /dev/loop2 /dev/loop3 /dev/loop4
sleep 3
mdadm --wait /dev/md0
mdadm -G /dev/md0 -n 5

[root@dhcp-12-171 bug]# cat /proc/mdstat 
Personalities : [raid6] [raid5] [raid4] 
md0 : active raid6 loop4[4] loop3[3] loop2[2] loop1[1] loop0[0]
      38912 blocks super 1.2 level 6, 512k chunk, algorithm 2 [5/5] [UUUUU]
      [>....................]  reshape =  0.0% (0/19456) finish=3344.0min speed=0K/sec
      
unused devices: <none>
kernel: 4.2.0
dmesg:
[  563.248753] md: bind<loop0>
[  563.248825] md: bind<loop1>
[  563.248892] md: bind<loop2>
[  563.248954] md: bind<loop3>
[  563.251515] md: bind<loop4>
[  563.257778] md/raid:md0: device loop3 operational as raid disk 3
[  563.257784] md/raid:md0: device loop2 operational as raid disk 2
[  563.257787] md/raid:md0: device loop1 operational as raid disk 1
[  563.257789] md/raid:md0: device loop0 operational as raid disk 0
[  563.258543] md/raid:md0: allocated 4366kB
[  563.258613] md/raid:md0: raid level 6 active with 4 out of 4 devices, algorithm 2
[  563.258617] RAID conf printout:
[  563.258621]  --- level:6 rd:4 wd:4
[  563.258624]  disk 0, o:1, dev:loop0
[  563.258628]  disk 1, o:1, dev:loop1
[  563.258632]  disk 2, o:1, dev:loop2
[  563.258634]  disk 3, o:1, dev:loop3
[  563.258651] md/raid456: discard support disabled due to uncertainty.
[  563.258653] Set raid456.devices_handle_discard_safely=Y to override.
[  563.258694] md0: detected capacity change from 0 to 39845888
[  563.258814] RAID conf printout:
[  563.258821]  --- level:6 rd:4 wd:4
[  563.258825]  disk 0, o:1, dev:loop0
[  563.258829]  disk 1, o:1, dev:loop1
[  563.258833]  disk 2, o:1, dev:loop2
[  563.258838]  disk 3, o:1, dev:loop3
[  566.566752] RAID conf printout:
[  566.566758]  --- level:6 rd:5 wd:5
[  566.566762]  disk 0, o:1, dev:loop0
[  566.566765]  disk 1, o:1, dev:loop1
[  566.566767]  disk 2, o:1, dev:loop2
[  566.566770]  disk 3, o:1, dev:loop3
[  566.566772]  disk 4, o:1, dev:loop4
[  566.567770] md: reshape of RAID array md0
[  566.567776] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[  566.567779] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for reshape.
[  566.567785] md: using 128k window, over a total of 19456k


Best Regards,
  Yi Zhang


