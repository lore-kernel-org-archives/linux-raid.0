From: Michael Tokarev <mjt@tls.msk.ru>
Subject: mdadm: bitmaps not supported by this kernel?
Date: Thu, 26 Oct 2006 01:16:11 +0400
Message-ID: <453FD41B.5080908@tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Another 32/64 bits issue, it seems.
Running 2.6.18.1 x86-64 kernel and mdadm 2.5.3 (32 bit).

# mdadm -G /dev/md1 --bitmap=internal
mdadm: bitmaps not supported by this kernel.

# mdadm -G /dev/md1 --bitmap=none
mdadm: bitmaps not supported by this kernel.

etc.

Recompiling mdadm in 64bit mode eliminates the problem.

So far, only bitmap manipulation is broken this way.
I dunno if other things are broken too - at least
--assemble, --create, --stop, --detail works.

Thanks.

/mjt
