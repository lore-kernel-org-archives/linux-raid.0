From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: mdadm segfault when assembling the array
Date: Wed, 07 Oct 2009 10:33:41 +0200
Message-ID: <4ACC5265.2020602@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

My development machine crashed (a couple of times - X ati driver does 
not seem to like multiple graphics cards), and I lost one of the md 
RAID-1 arrays (other arrays work just fine):

# mdadm -V
mdadm - v3.0.2 - 25th September 2009

# mdadm /dev/md2 -A /dev/sda5 /dev/sdb5
Segmentation fault

# dmesg
[ 4736.407237] md: md2 stopped.
[ 4736.568062] mdadm[10019]: segfault at 0 ip 00007fc7172ed711 sp 
00007fff9b486af8 error 4 in libc-2.10.1.so[7fc717274000+154000]

The kernel is 2.6.31.1.

Any hints before I try to fix it my way?



-- 
Tomasz Chmielewski
http://wpkg.org
