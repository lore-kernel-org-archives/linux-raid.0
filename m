From: Bryce as root <root@www.linux.org.uk>
Subject: 2.6.1-rc1 - RAID5 -> oops -> other mischief
Date: Thu, 1 Jan 2004 22:43:31 +0000 (GMT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E1AcBXP-0003yy-KK@www.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Umm
Ok,.. basically scenario is as follows,...
4 300Gb drives
after getting it all up and running we disconnect hdb from the ide chain
curtosey of a hot swap drive bay. The expectation is that the spare disk
will get configured and pulled in (hdd1 in this case)
In fact this is indeed what happens
It's what happens afterwards thats goes horribly wrong. (see appended info)

Advice? (other than "don't do that then")
Is this a kernel bug or an artifact of the unexpected pull of the drive
even though the system wasn't using it at the time.

rebooting the box after the crash seems to show no real ill effects
apart form the expected rebuild on the spare drive

[root@ZenIV root]# cat /proc/mdstat 
Personalities : [raid5] 
md0 : active raid5 hdd1[3] hdc1[2] hda1[0]
      585938432 blocks level 5, 128k chunk, algorithm 2 [3/2] [U_U]
      [>....................]  recovery =  0.7% (2333696/292969216) finish=254.7min speed=19011K/sec
unused devices: <none>

and just for the hell of it,.. lets shutdown and reinsert hdb before
the resync is done and see what happens...

[root@ZenIV root]# cat /proc/mdstat 
Personalities : [raid5] 
md0 : active raid5 hdc1[2] hdd1[1] hda1[0]
      585938432 blocks level 5, 128k chunk, algorithm 2 [3/3] [UUU]

ok its ignored the existance of hdb altogether now although this seems
to indicate that hdb is now reallocated as the spare-disk

***BUT***
why is it not finishing off the rsync?
it was stopped at 1.1%  so why isn't it continuing where it left off?
even if it didn't save a checkpoint it would still need to rebuild from 0.0%

ummmmmmmmmmmm
I don't think thats quite right

Phil
=--=


[root@ZenIV root]# uname -a                                                     
Linux ZenIV.linux.org.uk 2.6.1-rc1 #5 SMP Thu Jan 1 20:24:48 GMT 2004 i686 i686$
                                                                                
                                                                                
[root@ZenIV root]# cat /etc/raidtab                                             
# raid-5 configuration                                                          
                                                                                
raiddev                 /dev/md0                                                
                                                                                
raid-level              5    # it's not obvious but this *must* be              
                             # right after raiddev                              
                                                                                
persistent-superblock   1    # set this to 1 if you want autostart,             
                             # BUT SETTING TO 1 WILL DESTROY PREVIOUS           
                             # CONTENTS if this is a RAID0 array created        
                             # by older raidtools (0.40-0.51) or mdtools!       
                                                                                
chunk-size              128                                                     
parity-algorithm        left-symmetric                                          
                                                                                
nr-raid-disks           3                                                       
nr-spare-disks          1                                                       
                                                                                
device                  /dev/hda1                                               
raid-disk               0                                                       
                                                                                
device                  /dev/hdb1                                               
raid-disk               1                                                       
                                                                                
device                  /dev/hdc1                                               
raid-disk               2                                                       
                                                                                
device                  /dev/hdd1                                               
spare-disk              0                                                       
                                                                                
                                                                                
                                                                                
From the kernel log                                                             
===================                                                             
                                                                                
md: autorun ...                                                                 
md: considering hdd1 ...                                                        
md:  adding hdd1 ...                                                            
md:  adding hdc1 ...                                                            
md:  adding hdb1 ...                                                            
md:  adding hda1 ...                                                            
md: created md0                                                                 
md: bind<hda1>                                                                  
md: bind<hdb1>                                                                  
md: bind<hdc1>                                                                  
md: bind<hdd1>                                                                  
md: running: <hdd1><hdc1><hdb1><hda1>                                           
raid5: measuring checksumming speed                                             
   8regs     :  3524.000 MB/sec                                                 
   8regs_prefetch:  3152.000 MB/sec                                             
   32regs    :  2292.000 MB/sec                                                 
   32regs_prefetch:  2112.000 MB/sec                                            
   pIII_sse  :  3948.000 MB/sec                                                 
   pII_mmx   :  4924.000 MB/sec                                                 
   p5_mmx    :  4868.000 MB/sec                                                 
raid5: using function: pIII_sse (3948.000 MB/sec)                               
md: raid5 personality registered as nr 4                                        
raid5: device hdc1 operational as raid disk 2                                   
raid5: device hdb1 operational as raid disk 1                                   
raid5: device hda1 operational as raid disk 0                                   
raid5: allocated 3147kB for md0                                                 
raid5: raid level 5 set md0 active with 3 out of 3 devices, algorithm 2         
RAID5 conf printout:                                                            
 --- rd:3 wd:3 fd:0                                                             
 disk 0, o:1, dev:hda1                                                         
 disk 1, o:1, dev:hdb1                                                          
 disk 2, o:1, dev:hdc1                                                          
md: ... autorun DONE.                                                           
hdb: status error: status=0x7f { DriveReady DeviceFault SeekComplete DataRequest
 CorrectedError Index Error }                                                   
hdb: status error: error=0x7f { DriveStatusError UncorrectableError SectorIdNotF
ound TrackZeroNotFound AddrMarkNotFound }, LBAsect=1647111536511, high=98175, lo
w=8355711, sector=2127                                                          
hda: DMA disabled                                                               
hdb: DMA disabled                                                               
hdb: drive not ready for command                                                
ide0: reset: master: passed; slave: failed                                      
hdb: status error: status=0x7f { DriveReady DeviceFault SeekComplete DataRequest
 CorrectedError Index Error }                                                   
hdb: status error: error=0x7f { DriveStatusError UncorrectableError SectorIdNotF
ound TrackZeroNotFound AddrMarkNotFound }, LBAsect=1647111536511, high=98175, lo
w=8355711, sector=2127                                                          
hdb: drive not ready for command                                                
ide0: reset: master: passed; slave: failed                                      
end_request: I/O error, dev hdb, sector 2127                                    
raid5: Disk failure on hdb1, disabling device. Operation continuing on 2 devices
RAID5 conf printout:                                                            
 --- rd:3 wd:2 fd:1                                                             
 disk 0, o:1, dev:hda1                                                          
 disk 1, o:0, dev:hdb1                                                          
 disk 2, o:1, dev:hdc1                                                          
RAID5 conf printout:                                                            
 --- rd:3 wd:2 fd:1                                                             
 disk 0, o:1, dev:hda1                                                          
 disk 2, o:1, dev:hdc1                                                          
RAID5 conf printout:                                                            
 --- rd:3 wd:2 fd:1                                                             
 disk 0, o:1, dev:hda1                                                          
 disk 1, o:1, dev:hdd1                                                          
 disk 2, o:1, dev:hdc1                                                          
md: syncing RAID array md0                                                      
md: minimum _guaranteed_ reconstruction speed: 1000 KB/sec/disc.                
md: using maximum available idle IO bandwith (but not more than 200000 KB/sec) f
or reconstruction.                                                              
md: using 128k window, over a total of 292969216 blocks.                        
------------[ cut here ]------------                                            
kernel BUG at drivers/md/raid5.c:1202!                                          
invalid operand: 0000 [#1]                                                      
CPU:    1                                                                       
EIP:    0060:[<f89add68>]    Not tainted                                        
EFLAGS: 00010297                                                                
EIP is at handle_stripe+0x9a3/0xcf1 [raid5]                                     
eax: 00000001   ebx: 00000000   ecx: 00000003   edx: f624e084                   
esi: 00000001   edi: f624e0ac   ebp: ffffffff   esp: e70b3e44                   
ds: 007b   es: 007b   ss: 0068                                                  
Process md0_resync (pid: 1372, threadinfo=e70b2000 task=e0a64080)               
Stack: f6204c90 00000008 5a5a5a5a 5a5a5a5a 5a5a5a5a f89ac2b4 f73fe104 00000008  
       00000002 5a5a5a5a 5a5a5a5a 5a5a5a5a 00000001 00000001 00000000 00000000  
       00000001 00000000 00000000 00000002 00000000 00000001 00000000 00000003  
Call Trace:                                                                     
 [<f89ac2b4>] get_active_stripe+0x31/0x2a5 [raid5]                              
 [<f89ae3ad>] sync_request+0xc3/0xd5 [raid5]                                    
 [<f88ff00f>] md_do_sync+0x1c9/0x618 [md]                                       
 [<c0121da1>] __wake_up_common+0x38/0x57                                        
 [<f88fe06d>] md_thread+0xb5/0x16e [md]                                         
 [<c0121d57>] default_wake_function+0x0/0x12                                    
 [<f88fdfb8>] md_thread+0x0/0x16e [md]                                          
 [<c0109269>] kernel_thread_helper+0x5/0xb                                      
                                                                                
Code: 0f 0b b2 04 71 ed 9a f8 6b 44 24 34 5c 03 44 24 78 f0 0f ba               
 <6>kjournald starting.  Commit interval 5 seconds                              
EXT3 FS on md0, internal journal                                                
EXT3-fs: mounted filesystem with ordered data mode.                             

