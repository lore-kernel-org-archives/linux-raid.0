From: Robert Osiel <bob@osiel.org>
Subject: Re: A few mdadm questions
Date: Mon, 15 Nov 2004 09:50:25 -0600
Message-ID: <4198D041.70302@osiel.org>
References: <200411140203.iAE23rN08652@www.watkins-home.com>	<419783F7.5030807@osiel.org> <16791.60777.951575.384927@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16791.60777.951575.384927@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: Guy <bugzilla@watkins-home.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Neil:
The machine is/was running plain Mandrake 8.0 (Debian wouldn't install 
on that box); I built the box more than a year ago and haven't had to 
mess with it after the first week or so -- no reboots until this drive 
failed.  Methinks Mandrake 8 is 2.4.3 (the box won't boot on its own merits
now -- so I'm afraid I can't be more specific); currently I'm booting 
via a live CD with a gentoo 2.6 kernel.

Guy:
The array is a five-disk array -- hde1, hdi1, hdk1, hdm1, hdo1.  That's 
how I created it.  When I do mdadm -E on any of the drives, it also 
shows a device 1 as "faulty removed", but that device never existed and 
I don't know why it is listed (and it doesn't seem to matter to the 
array, since I've run degraded on 4 disks before).  I created the array 
with the old tools and a raidtab.

hde1, hdm1, and hdo1 are the "good" drives.
hdk1 is the drive which initially failed (and is listed as faulty)
hdi1 (device 5) is the disk I raidhotremoved (and now is spare)

It has been a while since this happened, but as I remember it was a 
Saturday when I checked on the array and noticed that there was a bad 
disk.  What doesn't make sense is that it would have been in the 
afternoon -- is the time stamp in the superblock GMT?  If so, that might 
make sense.  However, I certainly did not notice a drive was out and do 
the remove within 2 seconds -- at a minimum it would have been several 
minutes, and could have been as long as weeks.

Continued thanks!

Bob.

>I'm still very surprised that you managed to "raidhotremove" without
>"raidsetfaulty" first... What kernel (exactly) are you running?
>
>NeilBrown
>  
>

