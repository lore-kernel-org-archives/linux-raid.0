From: "Shaw, Marco" <Marco.Shaw@aliant.ca>
Subject: RE: Heavy paging, but no swap being used.--MORE INFO
Date: Thu, 29 May 2003 14:05:04 -0300
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <C65F89D1AC0BB54B865127151A24DA7810F74CAE@nbexchm2.aliant.icn>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
To: "'linux-raid@vger.kernel.org'" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I was asked what I meant by "heavy page in/page out", and I'll do my best...

We have a monitoring system that believes anything over 10 for pages/second could be a problem, and
20 is really bad.

I've gathered this from one of my systems, where:
Pgs_in=pages_in (average for day)
Pgs_in_max=pags_in_maximum (maximum value for day)
Pgs_out=pages_out (average for day)
Pgs_out_max=pags_out_maximum (maximum value for day)

Some output from one of our Linux systems:
sample_date	pgs_in  pgs_in_max	pgs_out pgs_out_max
5/16/2003	0.07	5.68	53.32	159.54
5/17/2003	0.04	3.27	49.89	167.2
5/18/2003	0.09	5.74	50.57	159.61
5/19/2003	0.02	0.04	51.55	160.07
5/20/2003	25.86	657.06	57.06	166.05
5/21/2003	56.21	970.79	66.15	156.4
5/22/2003	10.48	1371.75	58.27	168.07
5/23/2003	0.33	39.9	56.77	148.58
5/24/2003	0.03	0.26	56.2	162.94
5/25/2003	0.02	0.49	56.45	166.74
5/26/2003	0.05	1.13	65.62	173.82
5/27/2003	36.8	754.51	64	203.06

Hence that difficult question of what is the norm?  I'm trying to figure out if I have a problem
Or this is 'normal' for the system: a dual-CPU 1.4GHz PIII with 4GB of RAM.  The OS is on a local
Hardware RAID card, but other data/apps are on a SAN attached software RAID0 device.

Marco

> -----Original Message-----
> From: Shaw, Marco 
> Sent: Thursday, May 29, 2003 11:31 AM
> To: 'linux-raid@vger.kernel.org'
> Subject: Heavy paging, but no swap being used.
> 
> 
> RedHat 7.2 with 2.4.18-18.7.xbigmem using RedHat's software 
> RAID package.
> 
> I've been seeing quite a bit of page in/page out going on, 
> and have been looking around.
> 
> With the 2.4 kernel, when would one expect to see swap usage? 
>  I'm assuming the 2.4 memory works a bit like Solaris where 
> one should expect to see physical memory usage relatively 
> high, and that's a good/normal thing, but I don't see any 
> swap utilization at all, which concerns me.  I may have 
> misconfigured something...
> 
> How can I pin-point, if possible, whether the paging is 
> related to the use of software RAID?
> 
> Marco
> 
> # more raidtab
> raiddev /dev/md0
>         raid-level              0
>         nr-raid-disks           2
>         persistent-superblock   1
>         chunk-size              32
>         device                  /dev/sdc1
>         raid-disk               0
>         device                  /dev/sdd1
>         raid-disk               1
> 
> # free
>             total       used       free     shared    buffers 
>     cached
> Mem:       3874464    3843256      31208          0     
> 381844    3084184
> -/+ buffers/cache:     377228    3497236
> Swap:      2048248          0    2048248
> 
> # sar -r
> Linux 2.4.18-18.7.xbigmem 05/29/2003
> 
> 12:00:00 AM kbmemfree kbmemused  %memused kbmemshrd kbbuffers 
>  kbcached kbswpfree kbswpused  %swpused
> 12:10:00 AM     33956   3840508     99.12         0    381020 
>   3085476   2048248         0      0.00
> 
> # swapon -s
> Filename                        Type            Size    Used  
>   Priority
> /dev/sda6                       partition       2048248 0       -1
> 
> # more /etc/fstab
> LABEL=/                 /                       ext3    
> defaults        1 1
> LABEL=/boot             /boot                   ext3    
> defaults        1 2
> none                    /dev/pts                devpts  
> gid=5,mode=620  0 0
> LABEL=/home             /home                   ext3    
> defaults        1 2
> none                    /proc                   proc    
> defaults        0 0
> none                    /dev/shm                tmpfs   
> defaults        0 0
> LABEL=/tmp              /tmp                    ext3    
> defaults        1 2
> LABEL=/usr              /usr                    ext3    
> defaults        1 2
> LABEL=/var              /var                    ext3    
> defaults        1 2
> /dev/md0 /hosting ext3 defaults,usrquota 0 0
> /dev/sda6               swap                    swap    
> defaults        0 0
> /dev/cdrom              /mnt/cdrom              iso9660 
> noauto,owner,kudzu,ro 0
> 0
> /dev/fd0                /mnt/floppy             auto    
> noauto,owner,kudzu 0 0
> 
> 
> # sar -B
> Linux 2.4.18-18.7.xbigmem 05/29/2003
> 
> 12:00:00 AM  pgpgin/s pgpgout/s  activepg  inadtypg  inaclnpg 
>  inatarpg ...
> Average:         0.02     55.34    561672    225090    115799 
>    180512
> 
