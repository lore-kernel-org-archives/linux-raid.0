From: "Yildiz, Murat" <murat.yildiz@atosorigin.com>
Subject: root raid
Date: Tue, 16 Jul 2002 17:16:01 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <09DC92F4BACCD31198FC009027D3A0C00299F2AB@exchange-s>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-raid-owner@vger.kernel.org>
To: "'linux-raid@vger.kernel.org'" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,
I have been trying to set up a raid 1 with bootable root.
Suse 7.3 (2.4.10)
df -k
/dev/sda1              3099160    331516   2641700  12% /    
/dev/md1                101005      7869     88964   9% /boot
/dev/md2               1548096    861136    624048  58% /usr 
/dev/md4               6538436   6161484    111244  99% /data
/dev/md3               5162728   3120440   1832484  64% /edi 

fstab :
/dev/sda1       /       ext3    defaults 1 1                       
/dev/md1        /boot   ext3    defaults 1 2                       
/dev/md2        /usr    ext3    defaults 1 2                       
/dev/cdrom      /media/cdrom    auto    ro,noauto,user,exec 0 0    
/dev/md4        /data   ext3    defaults 1 2                       
devpts  /dev/pts        devpts  defaults 0 0                       
/dev/md3        /edi    ext3    defaults 1 2                       
/dev/fd0        /media/floppy   auto    noauto,user,sync 0 0       
proc    /proc   proc    defaults 0 0                               
usbdevfs        /proc/bus/usb   usbdevfs        defaults,noauto 0 0
/dev/sda3       swap    swap    pri=42 0 0                         
#/dev/md0       /mnt    ext3    defaults 1 2                       

raidtab
# Sample raid-1 configuration    
raiddev                 /dev/md0 
raid-level              1        
nr-raid-disks           2        
nr-spare-disks          0        
chunk-size              4        
persistent-superblock   1        
device                  /dev/sda1
raid-disk               0        
device                  /dev/sdb1
raid-disk               1        

raiddev                 /dev/md1 
raid-level              1        
nr-raid-disks           2        
nr-spare-disks          0        
chunk-size              4        
persistent-superblock   1        
device                  /dev/sda2
raid-disk               0        
device                  /dev/sdb2
raid-disk               1        
                                 
raiddev                 /dev/md2 
raid-level              1        
nr-raid-disks           2        
nr-spare-disks          0        
chunk-size              4        
persistent-superblock   1        
device                  /dev/sda5
raid-disk               0        
device                  /dev/sdb5
raid-disk               1        

raiddev                 /dev/md3 
raid-level              1        
nr-raid-disks           2        
nr-spare-disks          0        
chunk-size              4        
persistent-superblock   1        
device                  /dev/sda6
raid-disk               0        
device                  /dev/sdb6
raid-disk               1        
                                 
raiddev                 /dev/md4 
raid-level              1        
nr-raid-disks           2        
nr-spare-disks          0        
chunk-size              4        
persistent-superblock   1        
device                  /dev/sda7
raid-disk               0        
device                  /dev/sdb7
raid-disk               1  

/etc/lilo.conf


disk    = /dev/sda                
  bios  = 0x80                    
disk    = /dev/sdb                
  bios  = 0x81                    
boot    = /dev/sda                
vga     = 791                     
read-only                         
menu-scheme = Wg:kw:Wg:Wg         
lba32                             
prompt                            
timeout = 80                      
message = /boot/message           
                                  
  image  = /boot/vmlinuz          
  label  = linux                  
  root   = /dev/sda1              
  initrd = /boot/initrd           
  append = "enableapic vga=0x0317"
                                  
  image  = /boot/vmlinuz.suse     
  label  = failsafe               
  root   = /dev/sda1              
  initrd = /boot/initrd.suse      
append = "disableapic ide=nodma apm=off"
optional                                
                                        
image  = /boot/memtest.bin              
label  = memtest86      


partition info :

/dev/sda1 : start=       63, size= 6297417, Id=fd           
/dev/sda2 : start=  6297480, size=  208845, Id=fd, bootable 
/dev/sda3 : start=  6506325, size= 2104515, Id=82           
/dev/sda4 : start=  8610840, size=26924940, Id= f           
/dev/sda5 : start=  8610903, size= 3148677, Id=fd           
/dev/sda6 : start= 11759643, size=10490382, Id=fd           
/dev/sda7 : start= 22250088, size=13285692, Id=fd           

/dev/sdb1 : start=       63, size= 6297417, Id=fd          
/dev/sdb2 : start=  6297480, size=  208845, Id=fd, bootable
/dev/sdb3 : start=  6506325, size= 2104515, Id=82          
/dev/sdb4 : start=  8610840, size=26924940, Id= f          
/dev/sdb5 : start=  8610903, size= 3148677, Id=fd          
/dev/sdb6 : start= 11759643, size=10490382, Id=fd          
/dev/sdb7 : start= 22250088, size=13285692, Id=fd      

cat /etc/mdstat

Personalities : [raid1]           
read_ahead 1024 sectors           
md4 : active raid1 sdb7[1] sda7[0]
      6642752 blocks [2/2] [UU]   
                                  
md3 : active raid1 sdb6[1] sda6[0]
      5245120 blocks [2/2] [UU]   
                                  
md2 : active raid1 sdb5[1] sda5[0]
      1574272 blocks [2/2] [UU]   
                                  
md1 : active raid1 sdb2[1] sda2[0]
      104320 blocks [2/2] [UU]    
                                  
unused devices: <none>            


When I change root=/dev/md0 , I get a Kernel panic , cannot mount root
filesystem
Any help would be appreciated...thx

Murat

