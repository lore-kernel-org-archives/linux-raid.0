From: Tim Small <tim@buttersideup.com>
Subject: wdidle3
Date: Thu, 22 Apr 2010 12:40:37 +0100
Message-ID: <4BD035B5.2010203@buttersideup.com>
References: <4BAB8D41.4010801@gmail.com>	 <F50E50EC-32CF-4FC4-949B-E8DA56B08D50@santools.com>	 <4BABA12D.6040605@shiftmail.org> <4BAF8185.9040307@gmx.net>	 <4BC61D47.6090403@tmr.com> <4BCC65EB.3080803@cfl.rr.com>	 <4BCEFB99.9080806@tmr.com> <4BCF163C.6040604@cfl.rr.com>	 <y2x5bdc1c8b1004211036ra8e10a43kc1a13c2b374a5f7b@mail.gmail.com>	 <4BCF4693.3020101@buttersideup.com> <m2x5bdc1c8b1004211201ob1ea0c67k67b03eb4627a1375@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <m2x5bdc1c8b1004211201ob1ea0c67k67b03eb4627a1375@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Knecht <markknecht@gmail.com>
Cc: Phillip Susi <psusi@cfl.rr.com>, Bill Davidsen <davidsen@tmr.com>, st0ff@npl.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mark Knecht wrote:

>> [wdidle3.exe]...

> Yeah, that's been reported here before, but how does someone run this
> Windows program on a remote machine that boots only Linux? Even if it
> was a DOS executable the machine has no floppy.

It is a DOS executable.  As previously mentioned, you can use:

USB floppy emulation (if the BIOS supports it)
USB HD emulation
Booting from an HD partition (e.g. temporarily break RAID for one of the
swap partitons, and install DOS in that partition).
syslinux + memdisk + image file
pxelinux + memdisk + image file

I use the latter for using DOS bios upgrades etc. remotely using IPMI+SoL.

If anyone want to try and reverse-engineer wdidle3, it appears to have
been compiled with Watcom (now open source), and a free DOS extender and
then packed (again using an open tool).  You can run it under the Watcom
disassembler / debugger (which is packaged with FreeDOS).

With all this open source software rattling around Western Digital, it'd
be nice if they just did a bloody Linux version (or at least documented
the vendor-specific commands which they use).

Tim.

