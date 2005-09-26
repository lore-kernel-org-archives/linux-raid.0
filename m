From: Stephan van Hienen <raid@a2000.nu>
Subject: mdadm 2.0 and 2.1 compile error
Date: Mon, 26 Sep 2005 22:20:56 +0200 (CEST)
Message-ID: <Pine.LNX.4.63.0509262217180.24352@adsl.a2000.nu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I am trying to compile mdadm 2.x (currently running version 1.12)

On "make" I get the following fatal error for both 2.0 and 2.1:

In file included from super0.c:31:
/usr/include/asm/byteorder.h:6:2: #warning using private kernel header; 
include <endian.h> instead!
make: *** [super0.o] Error 1

any idea ?

system is tao 1.0 (based on rhel3) with 2.6.13.2 kernel source (also tried 
2.6.11.7 source)
