From: Luca Berra <bluca@comedia.it>
Subject: Re: announce: tiny raidtools-alike for use e.g. in initrd
Date: Fri, 31 Oct 2003 09:43:21 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20031031084320.GC26757@percy.comedia.it>
References: <3FA0BCD1.1060003@tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3FA0BCD1.1060003@tls.msk.ru>
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

well, 
since it is announce week :)))

I made a small patch to mdadm to build a subset of mdadm with diet-libc,
for use in initrds. (it is 44k statically linked)

I cannot rebuild whole mdadm with dietlibc due to dietlibc not
understanding non option arguments beetween option (optarg starting
with "-")

to build use:
diet gcc -DCONFFILE="\"/etc/mdadm.conf\"" -o mdassemble \
        mdassemble.c Assemble.c config.c dlink.c util.c

mdassemble will just scan /etc/mdadm.conf and try to assemble everything
it finds like running "mdadm -A -s".

regards,
L.


-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
