From: Johnny Wezel <j@netfeed.ch>
Subject: BUG? lockf () on RAID5
Date: Sun, 02 Mar 2003 23:56:53 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3E628C35.8090601@netfeed.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi

I moved my home directories onto a software RAID5 array, and from this 
time on, Mozilla refused to start.

Since I had some similar problems with pgp and StarOffice which turned 
out to be lock problems on NFS, I also suspected a lock problem here.

First, I tried to move to home directory onto a "normal" (ie. non-RAID 
hosted) directory, and Mozilla worked.

Then I wrote a short program, which tests the lockf () function:

#include <sys/types.h>                                                                                                                                               
#include <sys/stat.h>                                                                                                                                                
#include <fcntl.h>                                                                                                                                                   
#include <sys/file.h>                                                                                                                                                
#include <errno.h>                                                                                                                                                   
#include <stdio.h>                                                                                                                                                   
                                                                                                                                                                     
int main (int argc, char * argv [])                                                                                                                                  
{                                                                                                                                                                    
        int f, st;                                                                                                                                                   
        if (argc < 2) exit (1);                                                                                                                                      
        f = open (argv[1], O_RDWR);                                                                                                                                  
        st = lockf (f, F_LOCK, 1);                                                                                                                                   
        if (st) {                                                                                                                                                    
                fprintf (stderr, "Error %d: ", errno);                                                                                                               
                perror ("flock");                                                                                                                                    
                exit (1);                                                                                                                                            
        }                                                                                                                                                            
        exit (0);                                                                                                                                                    
}                                                                                                                                                                    

Executed on a file in a RAID directory, it returned

Error 37: flock: No locks available

On files in non-RAID-directories it worked without error.

So, I come to the conclusion, that the RAID system does not support 
locks, or the lock support is buggy.

The RAID hosts a ReiserFS. The kernel info is as follows:

Linux jellyfish 2.4.20 #3 Tue Feb 18 17:35:43 CET 2003 i686 unknown
 
Gnu C                  2.95.3
Gnu make               3.79.1
binutils               2.11.90.0.29
util-linux             2.11i
mount                  2.11i
modutils               2.4.8
e2fsprogs              1.24a
reiserfsprogs          3.x.0k-pre9
Linux C Library        x    1 root     root      1384072 Oct  1 18:10 /lib/libc.so.6
Dynamic linker (ldd)   2.2.4
Procps                 2.0.7
Net-tools              1.60
Kbd                    1.04
Sh-utils               2.0
Modules Loaded         isofs zlib_inflate vfat fat sr_mod cdrom sg ide-scsi reiserfs serial parport_pc lp parport nfsd lockd sunrpc uhci usbcore 8139too mii dummy0 nls_iso8859-1


The client kernl info is:

Linux beluga 2.4.20 #8 SMP Tue Feb 18 15:45:24 CET 2003 i686 Pentium III (Coppermine) GenuineIntel GNU/Linux
 
Gnu C                  3.2.1
Gnu make               3.80
util-linux             2.11y
mount                  2.11y
modutils               2.4.22
e2fsprogs              1.32
reiserfsprogs          3.6.4
Linux C Library        2.3.1
Dynamic linker (ldd)   2.3.1
Procps                 2.0.10
Net-tools              1.60
Kbd                    1.06
Sh-utils               2.0.15
Modules Loaded         snd-pcm-oss snd-mixer-oss parport_pc lp parport usb-uhci usbcore 8139too mii snd-intel8x0 snd-pcm snd-timer snd-ac97-codec snd-mpu401-uart snd-rawmidi snd-seq-device snd


Cheers
Johnny Wezel


