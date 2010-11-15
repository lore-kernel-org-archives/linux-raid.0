From: Aussie <aussie_1968@yahoo.com>
Subject: raid5 to raid6 reshape - power loss - does not assemble any more
Date: Mon, 15 Nov 2010 04:06:15 -0800 (PST)
Message-ID: <654169.58144.qm@web114706.mail.gq1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

hi,

i have tried everything discussed in "reboot before reshape from raid 5 to raid 
6 ( was in state resync=DELAYED). Doesn't assemble anymore"
but i am not getting anywhere.

i have changed from a raid5 with 4 drives to a raid6 with 5 drives.
at about 75%, the power to our house was cut and the server shut off.

when rebooting, the raid does not get assembled any more and mdadm dies when 
using "--backup-file" with assemble

here is my setup and what i have done.
clean install of fedora 13 64bit on i7-950 with 12GB ram
system is on /dev/sdf
5x 1.5TB SATA drives connected to motherboard (/dev/sda1-sde1 = Linux raid 
autodetect)
raid 5 was running fine on the 4 drives.

# mdadm /dev/md0 --add /dev/sde1
# mdadm --grow /dev/md0 --bitmap  none
#  mdadm --grow /dev/md0 --level=6 --raid-devices=5  
--backup-file=/root/raid-backup
then it was reshaping for about 5 days

today we lost our power and when booting up, the raid is no longer in operation.

#uname -a
#Linux localhost.localdomain 2.6.34.7-61.fc13.x86_64 #1 SMP Tue Oct 19 04:06:30 
UTC 2010 x86_64 x86_64 x86_64 GNU/Linux
#
#mdadm -V
#mdadm - v3.1.2 - 10th March 2010
#
#cat /etc/mdadm.conf
#ARRAY /dev/md0 metadata=0.90 UUID=2b0bc473:1b35585a:1458de10:75ddf3b2
#
#cat /proc/mdstat 
#Personalities : [raid6] [raid5] [raid4] 
#md0 : inactive sdd1[3] sdb1[1] sde1[4] sda1[0] sdc1[2]
#      7325679680 blocks super 0.91
#       
#unused devices: <none>
#
#dmesg (extract)
#md: bind<sdc1>
#md: bind<sda1>
#md: bind<sde1>
#md: bind<sdb1>
#md: bind<sdd1>
#raid6: int64x1   2929 MB/s
#raid6: int64x2   3109 MB/s
#raid6: int64x4   2503 MB/s
#raid6: int64x8   1976 MB/s
#raid6: sse2x1    7535 MB/s
#raid6: sse2x2    8910 MB/s
#raid6: sse2x4   10316 MB/s
#raid6: using algorithm sse2x4 (10316 MB/s)
#md: raid6 personality registered for level 6
#md: raid5 personality registered for level 5
#md: raid4 personality registered for level 4
#raid5: in-place reshape must be started in read-only mode - aborting
#md: pers->run() failed ...

reshape must be started.... does not seem to bad, but can not get it to start 
again.
are there commands to start it again ?

then i tried commands from NeilBrown from the above mentioned thread.

#mdadm -S /dev/md0
#mdadm: stopped /dev/md0
#
#mdadm -Avv --backup-file=/root/raid-backup /dev/md0
#mdadm: looking for devices for /dev/md0
#mdadm: cannot open device /dev/sdf3: Device or resource busy
#mdadm: /dev/sdf3 has wrong uuid.
#mdadm: cannot open device /dev/sdf2: Device or resource busy
#mdadm: /dev/sdf2 has wrong uuid.
#mdadm: cannot open device /dev/sdf1: Device or resource busy
#mdadm: /dev/sdf1 has wrong uuid.
#mdadm: cannot open device /dev/sdf: Device or resource busy
#mdadm: /dev/sdf has wrong uuid.
#mdadm: no RAID superblock on /dev/sde
#mdadm: /dev/sde has wrong uuid.
#mdadm: no RAID superblock on /dev/sdd
#mdadm: /dev/sdd has wrong uuid.
#mdadm: no RAID superblock on /dev/sdc
#mdadm: /dev/sdc has wrong uuid.
#mdadm: no RAID superblock on /dev/sdb
#mdadm: /dev/sdb has wrong uuid.
#mdadm: no RAID superblock on /dev/sda
#mdadm: /dev/sda has wrong uuid.
#mdadm: /dev/sde1 is identified as a member of /dev/md0, slot 4.
#mdadm: /dev/sdd1 is identified as a member of /dev/md0, slot 3.
#mdadm: /dev/sdc1 is identified as a member of /dev/md0, slot 2.
#mdadm: /dev/sdb1 is identified as a member of /dev/md0, slot 1.
#mdadm: /dev/sda1 is identified as a member of /dev/md0, slot 0.
#mdadm:/dev/md0 has an active reshape - checking if critical section needs to be 
restored
#*** buffer overflow detected ***: mdadm terminated
#======= Backtrace: =========
#/lib64/libc.so.6(__fortify_fail+0x37)[0x30228fb287]
#/lib64/libc.so.6[0x30228f9180]
#/lib64/libc.so.6(__read_chk+0x22)[0x30228f9652]
#mdadm[0x416aa6]
#mdadm[0x410ca7]
#mdadm[0x40552a]
#/lib64/libc.so.6(__libc_start_main+0xfd)[0x302281ec5d]
#mdadm[0x402a59]
#======= Memory map: ========
#00400000-0044f000 r-xp 00000000 08:51 1802315                            
/sbin/mdadm
#0064e000-00655000 rw-p 0004e000 08:51 1802315                            
/sbin/mdadm
#00655000-00669000 rw-p 00000000 00:00 0 
#00854000-00856000 rw-p 00054000 08:51 1802315                            
/sbin/mdadm
#009e9000-00a24000 rw-p 00000000 00:00 0                                  [heap]
#3022400000-302241e000 r-xp 00000000 08:51 2179368                        
/lib64/ld-2.12.1.so
#302261d000-302261e000 r--p 0001d000 08:51 2179368                        
/lib64/ld-2.12.1.so
#302261e000-302261f000 rw-p 0001e000 08:51 2179368                        
/lib64/ld-2.12.1.so
#302261f000-3022620000 rw-p 00000000 00:00 0 
#3022800000-3022975000 r-xp 00000000 08:51 2179373                        
/lib64/libc-2.12.1.so
#3022975000-3022b75000 ---p 00175000 08:51 2179373                        
/lib64/libc-2.12.1.so
#3022b75000-3022b79000 r--p 00175000 08:51 2179373                        
/lib64/libc-2.12.1.so
#3022b79000-3022b7a000 rw-p 00179000 08:51 2179373                        
/lib64/libc-2.12.1.so
#3022b7a000-3022b7f000 rw-p 00000000 00:00 0 
#302cc00000-302cc16000 r-xp 00000000 08:51 2179584                        
/lib64/libgcc_s-4.4.4-20100630.so.1
#3302cc16000-302ce15000 ---p 00016000 08:51 2179584                        
/lib64/libgcc_s-4.4.4-20100630.so.1
#302ce15000-302ce16000 rw-p 00015000 08:51 2179584                        
/lib64/libgcc_s-4.4.4-20100630.so.1
#7ff7377d9000-7ff7377dc000 rw-p 00000000 00:00 0 
#7ff7377f5000-7ff7377f6000 rw-p 00000000 00:00 0 
#7fffb1eef000-7fffb1f10000 rw-p 00000000 00:00 0                          
[stack]
#7fffb1fff000-7fffb2000000 r-xp 00000000 00:00 0                          [vdso]
#ffffffffff600000-ffffffffff601000 r-xp 00000000 00:00 0                  
[vsyscall]
#Aborted (core dumped)

unfortunately that is where it spits the dummy.
the raid-backup file is about 500MB in size.

i have not been game enough to execute radical commands, as it looks like there 
is only something minor wrong.
would be great if someone could help.

thanks
Martin


