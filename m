From: Michael Tokarev <mjt@tls.msk.ru>
Subject: announce: tiny raidtools-alike for use e.g. in initrd
Date: Thu, 30 Oct 2003 10:25:05 +0300
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3FA0BCD1.1060003@tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

http://www.corpit.ru/mjt/mdctl.c - a very small utility similar
to raidtools suite.  I wrote this program to use it inside an
initrd to bring raid arrays up at boot time - where the size of
executable and simplicity is at premium.  Differences between this
implementation and raidtools are:

  - size.  When compiled with dietlibc, executable is about
    7kb on i386.

  - it does not have mkraid utility and other fun stuff.
    Supported are
    - raidstart
    - raidstop
    - raidhot{add,remove,generateerror)
    - raidsetfaulty
   i.e., only "simple" commands - just ioctls in fact.

  - it uses NO config file like all the raidtools suite.
    I.e., it is more like mdadm in this respect.  All
    parameters are accepted in the command line.  This
    makes the utility handy inside read-only boot-time
    environment (you may e.g. parse md=... kernel
    parameter and convert it into mdctl commandline)

  - `mdctl start' tries to bring an array using ALL components
    of the array given in the command line, until successeful
    (raidstart tries only first component, and if that is missing
    but other component(s) are available, operation will fail).

Usage:

  mdctl start /dev/mdN /dev/hda1 /dev/hdb1 /dev/hdc1
    equivalent to md=N,/dev/hda1,/dev/hdb1,/dev/hdc1 boot
    parameter, but you can't specify raid level (it will
    be read from the superblock), and kernel may choose to
    bring up another mdN (as indicated by super-minor)

  mdctl {stop,readonly,ro,readwrite,rw} /dev/mdN

  mdctl {add,remove,setfaulty,generaterror} /dev/mdN /dev/hda1

This tiny code released under GPL licence... in a hope it will
be useful to someone else too, not only to me ;)

Enjoy.

/mjt

