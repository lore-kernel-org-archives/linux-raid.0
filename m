From: "Andrew Skolarz" <pletopia@gmail.com>
Subject: PLEASE HELP ... raid5 array degraded ...
Date: Tue, 11 Jul 2006 22:09:01 -0500
Message-ID: <51adc5d50607112009v476d680fqe9918d607b90def4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

as the topic says i was running a raid5 array.  i was using this
because i assumed it wouldn't die .. even if i lost a drive.  well, i
guess i was wrong :(

a little background .. i have 2 raid5 arrays.  one is compromised of 4
200gb hd's (this crashed as of last night) and one is 4 300gb's.  last
night, i was accessing a file on the 2x200 while my server decided to
crash.  When i booted up today, the boot up sequence started yelling
at me that it couldn't load the reiserfs cause of a bad superblock.
upon further investigation i determined it wasn't the a bad superblock
in the reiserfs .. but rather one of the md superblocks on my hd's was
corrupt.

myth ~ # dmesg | grep md
md: raid0 personality registered as nr 2
md: raid5 personality registered as nr 4
md: md driver 0.90.2 MAX_MD_DEVS=256, MD_SB_DISKS=27
md: bitmap version 3.38
md: Autodetecting RAID arrays.
md: invalid superblock checksum on hdl1
md: hdl1 has invalid sb, not importing!
md: autorun ...
md: considering hdk1 ...
md:  adding hdk1 ...
md:  adding hdj1 ...
md:  adding hdi1 ...
md: created md0
md: bind<hdi1>
md: bind<hdj1>
md: bind<hdk1>
md: running: <hdk1><hdj1><hdi1>
md: md0: raid array is not clean -- starting background reconstruction
raid5: cannot start dirty degraded array for md0
raid5: failed to run raid set md0
md: pers->run() failed ...
md: do_md_run() returned -5
md: md0 stopped.
md: unbind<hdk1>
md: export_rdev(hdk1)
md: unbind<hdj1>
md: export_rdev(hdj1)
md: unbind<hdi1>
md: export_rdev(hdi1)
md: ... autorun DONE.

is the whole array dead ?? is there no way to recover the 450gb of
data i have on there ?

i tried even unplugging /dev/hdl and prayed it would start up with
just 3 drives (like raid5 should) but no luck .. just like here
without that drive, it doesn't want to reconstruct.

PLEASE HELP and tell me that my data is not lost .. i beg you
