From: "Yildiz, Murat" <murat.yildiz@atosorigin.com>
Subject: cannot boot from 2nd disk
Date: Thu, 18 Jul 2002 12:54:09 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <09DC92F4BACCD31198FC009027D3A0C00299F2B6@exchange-s>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-raid-owner@vger.kernel.org>
To: "'linux-raid@vger.kernel.org'" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids




Hi again,
the final situation is as below and I physically dismounted the sdb disk and
booted with sda and no problem with raid..but if I dismount the first disk
the machine cannot find a boot sector to boot, I mean no system found
message...Should I mark the first partitions of both disks "bootable" ???
thanx for your help,

Murat

Filesystem            Size  Used Avail Use% Mounted on
/dev/md0              3.9G  1.2G  2.6G  30% /         
/dev/md1              1.5G  873M  561M  61% /usr      
/dev/md2              4.8G   33M  4.5G   1% /edi      
/dev/md3              5.7G   33M  5.3G   1% /data     
shmfs                 377M     0  376M   0% /dev/shm  

lilo.conf
inst03:/etc # more lilo.conf      
disk    = /dev/sda                
  bios  = 0x80                    
disk    = /dev/sdb                
  bios  = 0x81                    
boot    = /dev/md0                
vga     = 791                     
read-only                         
menu-scheme = Wg:kw:Wg:Wg         
lba32                             
prompt                            
timeout = 80                      
message = /boot/message           
                                  
  image  = /boot/vmlinuz          
  label  = linux                  
  root   = /dev/md0               
  initrd = /boot/initrd           
  append = "enableapic vga=0x0317"
                                  
  image  = /boot/vmlinuz.suse     
  label  = failsafe               
  root   = /dev/md0               
initrd = /boot/initrd.suse              
append = "disableapic ide=nodma apm=off"
optional                                
                                        
image  = /boot/memtest.bin              
label  = memtest86      

inst03:/etc # swapon -s                                                 
Filename                        Type            Size    Used    Priority
/dev/sda2                       partition       787176  0       42      
/dev/sdb2                       partition       787176  0       42      

sfdisk -d /dev/sda
/dev/sda1 : start=       63, size= 8401932, Id=fd
/dev/sda2 : start=  8401995, size= 1574370, Id=82
/dev/sda3 : start=  9976365, size= 3148740, Id=fd
/dev/sda4 : start= 13125105, size=22410675, Id= 5
/dev/sda5 : start= 13125168, size=10249407, Id=fd
/dev/sda6 : start= 23374638, size=12161142, Id=fd
sfdisk -d /dev/sdb
/dev/sdb1 : start=       63, size= 8401932, Id=fd
/dev/sdb2 : start=  8401995, size= 1574370, Id=82
/dev/sdb3 : start=  9976365, size= 3148740, Id=fd
/dev/sdb4 : start= 13125105, size=22410675, Id= 5
/dev/sdb5 : start= 13125168, size=10249407, Id=fd
/dev/sdb6 : start= 23374638, size=12161142, Id=fd

