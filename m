From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Looking for the cause of poor I/O performance
Date: Thu, 2 Dec 2004 22:54:08 -0500
Message-ID: <200412030354.iB33sD913132@www.watkins-home.com>
References: <Pine.LNX.4.44.0412021919400.21152-100000@coffee.psychology.mcmaster.ca>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0412021919400.21152-100000@coffee.psychology.mcmaster.ca>
Sender: linux-raid-owner@vger.kernel.org
To: 'Mark Hahn' <hahn@physics.mcmaster.ca>, 'TJ' <systemloc@earthlink.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

My linux system is a P3-500 with 2 CPUs and 512 Meg RAM.  My system is much
faster than my network.  I don't know how your K6-500 compares to my P3-500.
But RAM may be your issue.  That amount of ram seems very low.  Are you
swapping?  What is your CPU load during the tests?  If you are at 100%, then
you are CPU bound.

Your disk performance is faster than a 100BaseT network.  So, your
performance may not be an issue.

My array gives about 60MB /second.

# hdparm -tT /dev/md2

/dev/md2:
 Timing buffer-cache reads:   128 MB in  0.87 seconds =147.13 MB/sec
 Timing buffered disk reads:  64 MB in  0.99 seconds = 64.65 MB/sec

# bonnie++ -d . -u 0:0

Version  1.03   ------Sequential Output------ --Sequential Input- --Random-
                -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
Machine    Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
watkins-home 1G  3414  99 30899  66 20449  46  3599  99 77781  74 438.7   9
                ------Sequential Create------ --------Random Create--------
                -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
          files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
             16   475  98 +++++ +++ 15634  88   501  99  1277  99  1977  98

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Mark Hahn
Sent: Thursday, December 02, 2004 7:50 PM
To: TJ
Cc: linux-raid@vger.kernel.org
Subject: Re: Looking for the cause of poor I/O performance

> 	My server is a K6-500 with 43MB of RAM, standard x86 hardware. The

such a machine was good in its day, but that day was what, 5-7 years ago?
in practical terms, the machine probably has about 300 MB/s of memory 
bandwidth (vs 3000 for a low-end server today).  further, it was not
uncommon
for chipsets to fail to cache then-large amounts of RAM (32M was a common
limit for caches configured writeback, for instance, that would magically
cache 64M if set to writethrough...)

> OS is Slackware 10.0 w/ 2.6.7 kernel I've had similar problems with the

with a modern kernel, manual hdparm tuning is unnecessary and probably
wrong.

> To tune these drives, I use:
> hdparm -c3 -d1 -m16 -X68 -k1 -A1 -a128 -M128 -u1 /dev/hd[kigca]

if you don't mess with the config via hdparm, what mode do they come up in?

> hda: WD 400JB  40GB
> hdc: WD 2000JB 200GB
> hdg: WD 2000JB 200GB
> hdi: IBM 75 GXP  120GB
> hdk: WD 1200JB 120GB

iirc, the 75GXP has a noticably lower density (and thus bandwidth).

> Controllers:
> hda-c: Onboard controller, VIA VT82C596B (rev 12)
> hdd-g: Silicon Image SiI 680 (rev 1)
> hdh-k: Promise PDC 20269 (rev 2)
> /dev/hda:  Timing buffered disk reads:   42 MB in  3.07 seconds =  13.67
MB/sec
> /dev/hdc:  Timing buffered disk reads:   44 MB in  3.12 seconds =  14.10
MB/sec

not that bad for such a horrible controller (and PCI, CPU, memory system)

> /dev/hdg:  Timing buffered disk reads:   68 MB in  3.04 seconds =  22.38
MB/sec
> /dev/hdi:  Timing buffered disk reads:   72 MB in  3.06 seconds =  23.53
MB/sec
> /dev/hdk:  Timing buffered disk reads:   66 MB in  3.05 seconds =  21.66
MB/sec

fairly modern controllers help, but not much.

> /dev/md0:  Timing buffered disk reads:   70 MB in  3.07 seconds =  22.77
MB/sec
> /dev/md1:  Timing buffered disk reads:   50 MB in  3.03 seconds =  16.51
MB/sec

since the cpu/mem/chipset/bus are limiting factors, raid doesn't help.

> I would appriciate any thoughts, leads, ideas, anything at all to point me
in
> a direction here.

keeping a K6 alive is noble and/or amusing, but it's just not reasonable to 
expect it to keep up with modern disks.  expecting it to run samba well is 
not terribly reasonable.

plug those disks into any entry-level machine bought new (celeron, sempron)
and you'll get whiplash.  plug those disks into a proper server
(dual-opteron, few GB ram) and you'll never look back.  in fact,
you'll start looking for a faster network.

regards, mark hahn.

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

