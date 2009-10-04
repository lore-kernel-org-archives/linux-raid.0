From: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Subject: Re: ANNOUNCE: mdadm 3.0.1 - A tool for managing Soft RAID under
 Linux
Date: Sun, 4 Oct 2009 15:16:56 -0800 (AKDT)
Message-ID: <alpine.LNX.2.01.0910041514180.11684@filesrv1.baby-dragons.com>
References: <19132.27836.474548.540600@notabene.brown>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <19132.27836.474548.540600@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

 	Hello Neil (& All) ,  Am I missing something here ?  I've not had much 
if any difficulties compiling mdadm ,  from -very- old distro. tooled boxen to 
very new ,  But ...

 		Tia ,  JimL

...snip...
gcc  -o mdadm mdadm.o config.o mdstat.o  ReadMe.o util.o Manage.o Assemble.o 
Build.o Create.o Detail.o Examine.o Grow.o Monitor.o dlink.o Kill.o Query.o 
Incremental.o mdopen.o super0.o super1.o super-ddf.o super-intel.o bitmap.o 
restripe.o sysfs.o sha1.o mapfile.o crc32.o sg_io.o msg.o platform-intel.o 
probe_roms.o
gcc -Wall -Werror -Wstrict-prototypes -ggdb -DSendmail=\""/usr/sbin/sendmail 
-t"\" -DCONFFILE=\"/etc/mdadm.conf\" -DCONFFILE2=\"/etc/mdadm/mdadm.conf\"   -c 
-o mdmon.o mdmon.c
gcc -Wall -Werror -Wstrict-prototypes -ggdb -DSendmail=\""/usr/sbin/sendmail 
-t"\" -DCONFFILE=\"/etc/mdadm.conf\" -DCONFFILE2=\"/etc/mdadm/mdadm.conf\"   -c 
-o monitor.o monitor.c
monitor.c: In function `signal_manager':
monitor.c:139: error: `SYS_tgkill' undeclared (first use in this function)
monitor.c:139: error: (Each undeclared identifier is reported only once
monitor.c:139: error: for each function it appears in.)
make: *** [monitor.o] Error 1

# uname -a
Linux ns3 2.6.30.6 #1 SMP Wed Sep 9 05:50:45 UTC 2009 i686 pentium3 i386 GNU/Linux

# /usr/src/linux/scripts/ver_linux
If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.

Linux ns3 2.6.30.6 #1 SMP Wed Sep 9 05:50:45 UTC 2009 i686 pentium3 i386 
GNU/Linux

Gnu C                  3.4.6
Gnu make               3.81
binutils               2.15.92.0.2
util-linux             2.12r
mount                  2.12r
module-init-tools      3.2.2
e2fsprogs              1.38
jfsutils               1.1.11
reiserfsprogs          3.6.19
xfsprogs               2.8.10
pcmciautils            014
pcmcia-cs              3.2.8
quota-tools            3.13.
PPP                    2.4.4
Linux C Library        2.3.6
Dynamic linker (ldd)   2.3.6
Linux C++ Library      6.0.3
Procps                 3.2.7
Net-tools              1.60
Kbd                    1.12
oprofile               0.9.1
Sh-utils               5.97
udev                   097
Modules Loaded         i2c_piix4

  -- 
+------------------------------------------------------------------+
| James   W.   Laferriere | System    Techniques | Give me VMS     |
| Network&System Engineer | 2133    McCullam Ave |  Give me Linux  |
| babydr@baby-dragons.com | Fairbanks, AK. 99701 |   only  on  AXP |
+------------------------------------------------------------------+
