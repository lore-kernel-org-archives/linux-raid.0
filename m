From: Gordon Henderson <gordon@drogon.net>
Subject: Re: Test program for raid
Date: Thu, 19 Dec 2002 12:13:28 +0000 (GMT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.43.0212191145360.20588-100000@unicorn.drogon.net>
References: <984305F1827DD5118FEA0000D1105F0A01BDC0B7@HW_MAIL>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <984305F1827DD5118FEA0000D1105F0A01BDC0B7@HW_MAIL>
To: "SCHEP. - Schepke, Arnt" <SCHEP@Hoeft-Wessel.de>
Cc: "'linux-raid@vger.kernel.org'" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, 19 Dec 2002, SCHEP. - Schepke, Arnt wrote:

> Hi,
> just a little question: I want to test my Software-RAID1 System.
> I have some errors and want something like a one year usage in a one day
> test.

What sort of errors?

> Do you have an idea what program to use?

It depends on what you want to test ...

To test the disk system, data paths and so on, I use 'bonnie' which is a
disk benchmark program. I run about 6 or 8 of them in a loop for several
days (if possible) before making a server go live. Running more than one
is obviously no use as a benchmark, but it does seem give it it good
thrashing. The trick is to not start them at the same time, but to stagger
them - that way you get a good mix of the different operations that Bonnie
performs.

I use this:

  #!/bin/sh
  # /usr/local/bin/dob
  dobon & sleep 120 ;  dobon & sleep 120
  dobon & sleep 120 ;  dobon & sleep 120
  dobon & sleep 120 ;  dobon & sleep 120
  dobon & sleep 120 ;  dobon & sleep 120

And:

  #!/bin/csh
  #	/usr/local/bin/dobon
  @ n = 1
  while (1)
    echo Pass number $n
    bonnie -s1047 -n0 -u0
    @ n++
  end

You many have to alter the flags to bonnie depending on what version you
use (this is for bonnie++ as supplied with Debian 3)

Make sure the filesystem has enough disk space - this will require 8GB of
disk space...

I've managed to break an IBM server raid controller with this - so much
for RAID in hardware. IBM acknowledge the fault too and are supposed to be
working on it... Don't buy IBM, stick to software raid :)

However, I recently had a Linux (s/w raid + ext2) system which would run
this all night, but FAIL on FSCK... So after running this for some time,
stop it, then umount the filesystem and run several FSCKs on it. (The
failure reason was an AMD hardware fault - cured by plugging in a PS2
mouse and compiling the mouse driver back into the kernel)

Good luck!

Gordon

