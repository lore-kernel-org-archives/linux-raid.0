From: rob <rob@fantinibakery.com>
Subject: Re: Linux drivers for ICH5R (RAID1) and Promise PDC20378, Performance
Date: Mon, 13 Oct 2003 20:06:05 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3F8B3DED.1030403@fantinibakery.com>
References: <200310140008.43189.dusty@strike.wu-wien.ac.at> <1066083358.4761.254.camel@persist.az.mvista.com> <200310140023.13957.dusty@strike.wu-wien.ac.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200310140023.13957.dusty@strike.wu-wien.ac.at>
To: Hermann Himmelbauer <dusty@strike.wu-wien.ac.at>
Cc: sdake@mvista.com, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

fyi,  this is reading from an ide disk, writting to a software raid 
partition:

# time rsync --stats -v sever* /tmp
severn-i386-disc1.iso
severn-i386-disc2.iso
severn-i386-disc3.iso

Number of files: 3
Number of files transferred: 3
Total file size: 1959821312 bytes
Total transferred file size: 1959821312 bytes
Literal data: 1959821312 bytes
Matched data: 0 bytes
File list size: 72
Total bytes written: 1960060740
Total bytes read: 68

wrote 1960060740 bytes  read 68 bytes  13950610.73 bytes/sec
total size is 1959821312  speedup is 1.00

68.19user 80.37system 2:20.26elapsed 105%CPU (0avgtext+0avgdata 
0maxresident)k
0inputs+0outputs (180major+308minor)pagefaults 0swaps
-----------------------------------
here I deleted the files on the ide drive, then cp from software raid 
drive to the ide drive:

root@fbc5:/tmp # time rsync --stats -v sever* /bkup3
severn-i386-disc1.iso
severn-i386-disc2.iso
severn-i386-disc3.iso

Number of files: 3
Number of files transferred: 3
Total file size: 1959821312 bytes
Total transferred file size: 1959821312 bytes
Literal data: 1959821312 bytes
Matched data: 0 bytes
File list size: 72
Total bytes written: 1960060740
Total bytes read: 68

wrote 1960060740 bytes  read 68 bytes  12136599.43 bytes/sec
total size is 1959821312  speedup is 1.00

69.26user 73.34system 2:40.93elapsed 88%CPU (0avgtext+0avgdata 
0maxresident)k
0inputs+0outputs (180major+308minor)pagefaults 0swaps




--------------------------------------
this is a listing of the files used in the above:

root@fbc5:/bkup3 # ls -l sev*
-rw-r--r--    1 rob      pro      658309120 Sep 24 16:08 
severn-i386-disc1.iso
-rw-r--r--    1 rob      pro      668598272 Sep 24 16:10 
severn-i386-disc2.iso
-rw-r--r--    1 rob      pro      632913920 Sep 24 16:12 
severn-i386-disc3.iso

and comments on the speed or cpu usage?

here is info on the cpus... this is an old dell  computer... 

root@fbc5:/bkup3 # cat /proc/cpuinfo
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 7
model name      : Pentium III (Katmai)
stepping        : 3
cpu MHz         : 547.187
cache size      : 512 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge 
mca cmov pat pse36 mmx fxsr sse
bogomips        : 1091.17

processor       : 1
vendor_id       : GenuineIntel
cpu family      : 6
model           : 7
model name      : Pentium III (Katmai)
stepping        : 3
cpu MHz         : 547.187
cache size      : 512 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge 
mca cmov pat pse36 mmx fxsr sse
bogomips        : 1091.17

root@fbc5:/bkup3 # uname -r
2.4.21-0.25mdksmp










Hermann Himmelbauer wrote:

>reading/writing with full speed? (e.g. cat big-file > /dev/null)
>I read that the ICH5R and the Promise use only ~ 3% of the CPU.
>
>		Best Regards,
>		Hermann
>
>  
>

