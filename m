From: Robert Heinzmann <Robert.Heinzmann@gmx.net>
Subject: mdadm 2.2 compile problem
Date: Thu, 15 Dec 2005 23:25:30 +0100
Message-ID: <43A1ED5A.2050406@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,
I tried to compile mdadm 2.2 on my machine (sles8)

Kernel: 2.4.21-295-athlon
gcc: gcc version 2.95.3 20010315

The compile fails with this error message:

cc1: warnings being treated as errors
In file included from mdadm.h:219,
                 from bitmap.c:23:
/usr/include/ftw.h:93: warning: `struct stat64' declared inside 
parameter list
/usr/include/ftw.h:93: warning: its scope is only this definition or 
declaration, which is probably not what you want.
/usr/include/ftw.h:102: warning: `struct stat64' declared inside 
parameter list
bitmap.c: In function `bitmap_fd_read':
bitmap.c:130: warning: unknown conversion type character `z' in format
bitmap.c:130: warning: too many arguments for format
make: *** [bitmap.o] Error 1

I changed the makefile and removed -Werror. Is there another way to fix 
this issue ?

Regards,
Robert Heinzmann

