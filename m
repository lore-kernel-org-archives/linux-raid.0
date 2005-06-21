From: Martin Kluge <martin@elxsi.de>
Subject: Linux RAID6 problem
Date: Tue, 21 Jun 2005 15:29:56 +0200
Message-ID: <20050621132956.GA68873@elxsi.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,                                                                             
                                                                                
sorry if this is the wrong place to post this. I got some problems with         
AoE and RAID6 running on Linux (2.6.11.11, i386). I have 3 computers with       
2 harddrives each and I construct a RAID 6 array over the 6 disks. The problem  
is that I cannot get the RAID to sync, because after some time the first        
disk fails. Some minutes later the next disk fails:                             
                                                                                
    Update Time : Tue Jun 14 20:24:05 2005
          State : clean, degraded                                               
 Active Devices : 4                                                             
Working Devices : 4                                                             
 Failed Devices : 2                                                             
  Spare Devices : 0                                                             
                                                                                
     Chunk Size : 64K                                                           
                                                                                
           UUID : 8c6a47a0:e01d18b8:63d3257f:ab1d67a5                           
         Events : 0.36906547                                                    
                                                                                
    Number   Major   Minor   RaidDevice State                                   
       0     152        0        0      active sync   /dev/etherd/e0.0          
       1     152       16        1      active sync   /dev/etherd/e0.1          
       3     152      160        3      active sync   /dev/etherd/e1.0
       4       0        0        -      removed                                 
       5     152      192        5      active sync   /dev/etherd/e1.2          
                                                                                
       6     152      176        -      faulty   /dev/etherd/e1.1               
       7     152       32        -      faulty   /dev/etherd/e0.2               
                                                                                
I have no error logs in syslog nor in any other file. I replaced all           
disks several times, used other hardware, but the problem still occurs. I       
also tried different kernel versions without any luck.                          

The disks fail more or less randomly, sometimes both in the same computer,
sometimes two disks in the other ones.

Do you have any ideas how to fix this? I don't know if this is a AoE problem
or a problem with the RAID subsystem. I tried everything with RAID5 and RAID10  
and no errors occur, everything seems to work fine, so I think this *could*     
be a problem with the RAID6 system.
                                                                                
Here are some more information:
                                                                                
b1:~# uname -a                                                                  
Linux b1 2.6.11.11 #5 Wed Jun 1 12:21:55 CEST 2005 i686 GNU/Linux               
                                                                                
b1:~# mdadm --version                                                           
mdadm - v1.9.0 - 04 February 2005
                                                                                
b1:~# mdadm -D /dev/md0                                                         
/dev/md0:                                                                       
        Version : 00.90.01                                                      
  Creation Time : Tue Jun 14 17:26:05 2005                                      
     Raid Level : raid6                                                         
     Array Size : 421512960 (401.99 GiB 431.63 GB)                              
    Device Size : 105378240 (100.50 GiB 107.91 GB)                              
   Raid Devices : 6                                                             
  Total Devices : 6                                                             
Preferred Minor : 0                                                             
    Persistence : Superblock is persistent                                      
                                                                                
    Update Time : Tue Jun 14 20:24:05 2005                                      
          State : clean, degraded
 Active Devices : 4                                                             
Working Devices : 4                                                             
 Failed Devices : 2                                                             
  Spare Devices : 0                                                             
                                                                                
     Chunk Size : 64K                                                           
                                                                                
           UUID : 8c6a47a0:e01d18b8:63d3257f:ab1d67a5                           
         Events : 0.36906547                                                    
                                                                                
    Number   Major   Minor   RaidDevice State                                   
       0     152        0        0      active sync   /dev/etherd/e0.0          
       1     152       16        1      active sync   /dev/etherd/e0.1          
       2       0        0        -      removed                                 
       3     152      160        3      active sync   /dev/etherd/e1.0
       4       0        0        -      removed                                 
       5     152      192        5      active sync   /dev/etherd/e1.2          
                                                                                
       6     152      176        -      faulty   /dev/etherd/e1.1               
       7     152       32        -      faulty   /dev/etherd/e0.2               
                                                                                
                                                                                
Please reply of list if possible.
                                                                                
Thank your for your help,                                                       
Martin Kluge
-- 
Name	   : Martin Kluge
email	   : martin@elxsi.info
Phone	   : +49 160 1515182
Projects   : http://www.aa-security.de
GPG Key	   : http://www.elxsi.de/key.pub

