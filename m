From: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Subject: Re: ANNOUNCE: mdadm 3.0 - A tool for managing Soft RAID under
 Linux
Date: Wed, 3 Jun 2009 17:52:20 -0800 (AKDT)
Message-ID: <alpine.LNX.2.01.0906031749270.15124@filesrv1.baby-dragons.com>
References: <18980.48553.328662.80987@notabene.brown>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18980.48553.328662.80987@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

 	Hello Neil ,  I am getting a interesting Error during compiling 3.0 .
 	Is there a particular version of kernel that 3.0 is supposed to be 
compiled with ?

 		Tia ,  JimL

gcc -Wall -Werror -Wstrict-prototypes -ggdb -DSendmail=\""/usr/sbin/sendmail 
-t"\" -DCONFFILE=\"/etc/mdadm.conf\" -DCONFFILE2=\"/etc/mdadm/mdadm.conf\"   -c 
-o super-intel.o super-intel.c
cc1: warnings being treated as errors
super-intel.c: In function 'mark_failure':
super-intel.c:3632: warning: comparison is always false due to limited range of 
data type
make: *** [super-intel.o] Error 1


root@bigscrn-vm:/home/archive/mdadm-3.0# cat /etc/slackware-version
Slamd64 12.1.0


# /usr/src/linux/scripts/ver_linux
If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.

Linux bigscrn-vm 2.6.27.7 #3 SMP Sat May 16 14:55:51 AKDT 2009 x86_64 x86_64 
x86_64 GNU/Linux

Gnu C                  4.2.3
Gnu make               3.81
binutils               2.17.50.0.17.20070615
util-linux             2.13.1
mount                  2.13.1
module-init-tools      3.4
e2fsprogs              1.40.8
jfsutils               1.1.12
reiserfsprogs          3.6.19
xfsprogs               2.9.7
pcmciautils            014
quota-tools            3.13.
PPP                    2.4.4
Linux C Library        2.7
Dynamic linker (ldd)   2.7
Linux C++ Library      6.0.9
Procps                 3.2.7
Net-tools              1.60
Kbd                    1.12
oprofile               0.9.2
Sh-utils               6.9
udev                   118
wireless-tools         29
Modules Loaded         vmnet vsock vmci vmmon fglrx



# make
gcc -Wall -Werror -Wstrict-prototypes -ggdb -DSendmail=\""/usr/sbin/sendmail 
-t"\" -DCONFFILE=\"/etc/mdadm.conf\" -DCONFFILE2=\"/etc/mdadm/mdadm.conf\"   -c 
-o mdadm.o mdadm.c
gcc -Wall -Werror -Wstrict-prototypes -ggdb -DSendmail=\""/usr/sbin/sendmail 
-t"\" -DCONFFILE=\"/etc/mdadm.conf\" -DCONFFILE2=\"/etc/mdadm/mdadm.conf\"   -c 
-o config.o config.c
gcc -Wall -Werror -Wstrict-prototypes -ggdb -DSendmail=\""/usr/sbin/sendmail 
-t"\" -DCONFFILE=\"/etc/mdadm.conf\" -DCONFFILE2=\"/etc/mdadm/mdadm.conf\"   -c 
-o mdstat.o mdstat.c
gcc -Wall -Werror -Wstrict-prototypes -ggdb -DSendmail=\""/usr/sbin/sendmail 
-t"\" -DCONFFILE=\"/etc/mdadm.conf\" -DCONFFILE2=\"/etc/mdadm/mdadm.conf\"   -c 
-o ReadMe.o ReadMe.c
gcc -Wall -Werror -Wstrict-prototypes -ggdb -DSendmail=\""/usr/sbin/sendmail 
-t"\" -DCONFFILE=\"/etc/mdadm.conf\" -DCONFFILE2=\"/etc/mdadm/mdadm.conf\"   -c 
-o util.o util.c
gcc -Wall -Werror -Wstrict-prototypes -ggdb -DSendmail=\""/usr/sbin/sendmail 
-t"\" -DCONFFILE=\"/etc/mdadm.conf\" -DCONFFILE2=\"/etc/mdadm/mdadm.conf\"   -c 
-o Manage.o Manage.c
gcc -Wall -Werror -Wstrict-prototypes -ggdb -DSendmail=\""/usr/sbin/sendmail 
-t"\" -DCONFFILE=\"/etc/mdadm.conf\" -DCONFFILE2=\"/etc/mdadm/mdadm.conf\"   -c 
-o Assemble.o Assemble.c
gcc -Wall -Werror -Wstrict-prototypes -ggdb -DSendmail=\""/usr/sbin/sendmail 
-t"\" -DCONFFILE=\"/etc/mdadm.conf\" -DCONFFILE2=\"/etc/mdadm/mdadm.conf\"   -c 
-o Build.o Build.c
gcc -Wall -Werror -Wstrict-prototypes -ggdb -DSendmail=\""/usr/sbin/sendmail 
-t"\" -DCONFFILE=\"/etc/mdadm.conf\" -DCONFFILE2=\"/etc/mdadm/mdadm.conf\"   -c 
-o Create.o Create.c
gcc -Wall -Werror -Wstrict-prototypes -ggdb -DSendmail=\""/usr/sbin/sendmail 
-t"\" -DCONFFILE=\"/etc/mdadm.conf\" -DCONFFILE2=\"/etc/mdadm/mdadm.conf\"   -c 
-o Detail.o Detail.c
gcc -Wall -Werror -Wstrict-prototypes -ggdb -DSendmail=\""/usr/sbin/sendmail 
-t"\" -DCONFFILE=\"/etc/mdadm.conf\" -DCONFFILE2=\"/etc/mdadm/mdadm.conf\"   -c 
-o Examine.o Examine.c
gcc -Wall -Werror -Wstrict-prototypes -ggdb -DSendmail=\""/usr/sbin/sendmail 
-t"\" -DCONFFILE=\"/etc/mdadm.conf\" -DCONFFILE2=\"/etc/mdadm/mdadm.conf\"   -c 
-o Grow.o Grow.c
gcc -Wall -Werror -Wstrict-prototypes -ggdb -DSendmail=\""/usr/sbin/sendmail 
-t"\" -DCONFFILE=\"/etc/mdadm.conf\" -DCONFFILE2=\"/etc/mdadm/mdadm.conf\"   -c 
-o Monitor.o Monitor.c
gcc -Wall -Werror -Wstrict-prototypes -ggdb -DSendmail=\""/usr/sbin/sendmail 
-t"\" -DCONFFILE=\"/etc/mdadm.conf\" -DCONFFILE2=\"/etc/mdadm/mdadm.conf\"   -c 
-o dlink.o dlink.c
gcc -Wall -Werror -Wstrict-prototypes -ggdb -DSendmail=\""/usr/sbin/sendmail 
-t"\" -DCONFFILE=\"/etc/mdadm.conf\" -DCONFFILE2=\"/etc/mdadm/mdadm.conf\"   -c 
-o Kill.o Kill.c
gcc -Wall -Werror -Wstrict-prototypes -ggdb -DSendmail=\""/usr/sbin/sendmail 
-t"\" -DCONFFILE=\"/etc/mdadm.conf\" -DCONFFILE2=\"/etc/mdadm/mdadm.conf\"   -c 
-o Query.o Query.c
gcc -Wall -Werror -Wstrict-prototypes -ggdb -DSendmail=\""/usr/sbin/sendmail 
-t"\" -DCONFFILE=\"/etc/mdadm.conf\" -DCONFFILE2=\"/etc/mdadm/mdadm.conf\"   -c 
-o Incremental.o Incremental.c
gcc -Wall -Werror -Wstrict-prototypes -ggdb -DSendmail=\""/usr/sbin/sendmail 
-t"\" -DCONFFILE=\"/etc/mdadm.conf\" -DCONFFILE2=\"/etc/mdadm/mdadm.conf\"   -c 
-o mdopen.o mdopen.c
gcc -Wall -Werror -Wstrict-prototypes -ggdb -DSendmail=\""/usr/sbin/sendmail 
-t"\" -DCONFFILE=\"/etc/mdadm.conf\" -DCONFFILE2=\"/etc/mdadm/mdadm.conf\"   -c 
-o super0.o super0.c
gcc -Wall -Werror -Wstrict-prototypes -ggdb -DSendmail=\""/usr/sbin/sendmail 
-t"\" -DCONFFILE=\"/etc/mdadm.conf\" -DCONFFILE2=\"/etc/mdadm/mdadm.conf\"   -c 
-o super1.o super1.c
gcc -Wall -Werror -Wstrict-prototypes -ggdb -DSendmail=\""/usr/sbin/sendmail 
-t"\" -DCONFFILE=\"/etc/mdadm.conf\" -DCONFFILE2=\"/etc/mdadm/mdadm.conf\"   -c 
-o super-ddf.o super-ddf.c
gcc -Wall -Werror -Wstrict-prototypes -ggdb -DSendmail=\""/usr/sbin/sendmail 
-t"\" -DCONFFILE=\"/etc/mdadm.conf\" -DCONFFILE2=\"/etc/mdadm/mdadm.conf\"   -c 
-o super-intel.o super-intel.c
cc1: warnings being treated as errors
super-intel.c: In function 'mark_failure':
super-intel.c:3632: warning: comparison is always false due to limited range of 
data type
make: *** [super-intel.o] Error 1

  -- 
+------------------------------------------------------------------+
| James   W.   Laferriere | System    Techniques | Give me VMS     |
| Network&System Engineer | 2133    McCullam Ave |  Give me Linux  |
| babydr@baby-dragons.com | Fairbanks, AK. 99701 |   only  on  AXP |
+------------------------------------------------------------------+
