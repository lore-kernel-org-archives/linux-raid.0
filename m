From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: ANNOUNCE: mdadm 3.1.3 - A tool for managing Soft RAID under
 Linux
Date: Fri, 6 Aug 2010 09:08:03 +0200 (CEST)
Message-ID: <alpine.DEB.1.10.1008060906060.19930@uplift.swm.pp.se>
References: <19547.45749.153826.476559@notabene.brown>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-137064504-1714676185-1281078483=:19930"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <19547.45749.153826.476559@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---137064504-1714676185-1281078483=:19930
Content-Type: TEXT/PLAIN; charset=ISO-8859-7; format=flowed
Content-Transfer-Encoding: 8BIT

On Fri, 6 Aug 2010, Neil Brown wrote:

>
> I am pleased to announce the availability of
>   mdadm version 3.1.3

I get the following compile error:

gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter -ggdb 
-DSendmail=\""/usr/sbin/sendmail -t"\" -DCONFFILE=\"/etc/mdadm.conf\" 
-DCONFFILE2=\"/etc/mdadm/mdadm.conf\" -DMAP_DIR=\"/dev/.mdadm\" 
-DMAP_FILE=\"map\" -DMDMON_DIR=\"/dev/.mdadm\" -DUSE_PTHREADS   -c -o 
super-intel.o super-intel.c
cc1: warnings being treated as errors
super-intel.c: In function ¡imsm_process_update¢:
super-intel.c:5393: error: format not a string literal and no format arguments
super-intel.c:5393: error: format not a string literal and no format arguments
make: *** [super-intel.o] Error 1

This is on a ubuntu 10.04 system with their 2.6.32 kernel.

mdadm-3.1.2 compiles fine on the same system.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
---137064504-1714676185-1281078483=:19930--
