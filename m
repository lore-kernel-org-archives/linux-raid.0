From: david@hpcf.upr.edu
Subject: RAID5 bug on SuSE 8.2->9.1
Date: Wed, 26 May 2004 09:21:37 -0400 (AST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1803.136.145.126.5.1085577697.squirrel@136.145.126.5>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
Cc: suse-linux@suse.com
List-Id: linux-raid.ids

Hi,

I am having problems with the RAID 5 option on SuSE 8.2, 9.0, 9.1.

On each of the version the are diferent issues,

SuSE 9.1: First notice during the setup, the systems stops responding
after a few MB have been copied, during this time I executed the command
"cat /proc/mdstat" which will make the Raid volumen usefull again, ones
the system is instaled the problem persisted.

SuSE 9.0 & 8.2: Kernel panics, the parity disc 4/4 is never done.
Reconstruct has to be issue with Knoppix bootcd.

Loading the same volumen with any other Linux distro will make the volumen
usefull without issues.

My config:

AMD64 3200
1.5GB ram
Asus k8v Deluxe
Nvidia 5900
2 Adaptec 29160 with 2 IBM 36GB each

Thanks

David
