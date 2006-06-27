From: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Subject: mdadm 2.5.2 - Static built , Interesting warnings when
Date: Tue, 27 Jun 2006 11:52:20 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0606271147410.12026@filesrv1.baby-dragons.com>
References: <17569.6292.142280.859690@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17569.6292.142280.859690@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

 	Hello All ,  What change in Glibc mekes this necessary ?  Is there a
 	method available to include the getpwnam & getgrnam structures so that
 	full static build will work .  Tia ,  JimL

gcc -Wall -Werror -Wstrict-prototypes -ggdb -DSendmail=\""/usr/sbin/sendmail -t"\" -DCONFFILE=\"/etc/mdadm.conf\" -DCONFFILE2=\"/etc/mdadm/mdadm.conf\" -DHAVE_STDINT_H -o sha1.o -c sha1.c
gcc -static -o mdadm mdadm.o config.o mdstat.o  ReadMe.o util.o Manage.o Assemble.o Build.o Create.o Detail.o Examine.o Grow.o Monitor.o dlink.o Kill.o Query.o mdopen.o super0.o super1.o bitmap.o restripe.o sysfs.o sha1.o
config.o(.text+0x8c4): In function `createline': /home/archive/mdadm-2.5.2/config.c:341: warning: Using 'getgrnam' in statically linked applications requires at runtime the shared libraries from the glibc version used for linking
config.o(.text+0x80b):/home/archive/mdadm-2.5.2/config.c:326: warning: Using 'getpwnam' in statically linked applications requires at runtime the shared libraries from the glibc version used for linking
nroff -man mdadm.8 > mdadm.man

-- 
+----------------------------------------------------------------------+
| James   W.   Laferriere |   System    Techniques   | Give me VMS     |
| Network        Engineer | 3600 14th Ave SE #20-103 |  Give me Linux  |
| babydr@baby-dragons.com |  Olympia ,  WA.   98501  |   only  on  AXP |
+----------------------------------------------------------------------+
