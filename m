From: berk walker <berk@panix.com>
Subject: Re: Tyan, RAID-6, and other recent hassles... (long, a bit OT)
Date: Sat, 19 Feb 2005 07:17:26 -0500
Message-ID: <42172E56.3040007@panix.com>
References: <Pine.LNX.4.56.0502170923200.819@lion.drogon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <Pine.LNX.4.56.0502170923200.819@lion.drogon.net>
Sender: linux-raid-owner@vger.kernel.org
To: Gordon Henderson <gordon@drogon.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Do you want a glass or some cheese?
Actually, I am thinking that your main problem is a generic [almost] 
BIOS issue, as no one in "right mind" would expect your configuration.  
Might I suggest a somewhat more expensive, yet safer work-around?

Split your drives between more boxes and gigabite link them.  If you 
work this well, you will have increased the survival of disk/other 
failures - stick 'em in the mail room, or where-ever.

You have spent some big bux to set this up, spend a few more and harden 
it. Eh?

Just an old guy rambling-

Gordon Henderson wrote:

>This is a bit OT and long, but it might help someone in the future, you
>never know!
>
>I've been struggling recently to get a box together with some supposedly
>nice hardware and it's turned out to be a bit of a nightmare.. The good
>news is that it's now sorted and working well enough to go into
>production.
>
>A big thanks to everyone who's contributed both on the list and in private
>email with some of the issues I've had with it.
>
>I've been building & running servers for many years, using Linux RAID for
>the past 5 or so, so thought this would be just another server (admittedly
>one of the biggest in disk terms I've built) alas it was nearly my
>nemesis!
>
>It's a 3U case with 8 hot-swap SATA drives and triple redundant 600W PSU.
>Nice case, 3 big fans inside, space for 3 5.25" units on one side. (I just
>have a CD-ROM drive in there). I opted for a 3U case rather than 2U just
>to make sure there was room inside it to take standard PCI cards without
>any risers and restricted air-flows. I chose a dual Opteron mobo (clients
>request) with on-board 4-port SATA controller (SII 3114) and initially got
>2 more SII based 2-port PCI cards.
>
>Mobo was a Tyan Thunder K8W. (S2885)
>1GB of Crucial RAM (2x512MB PC2700)
>Case: http://www.acme-technology.co.uk/acm338.htm
>8 x Hitachi Deskstar 250GB SATA.
>2 x Opteron 240 processors
>Debian Woody with 2.6 kernel.
>
>Then the trouble started )-:
>
>It seems that that motherboard, or the AMD chipset just can't hack PCI-X.
>(or maybe PCI cards in the PCI-X slots)  There are various jumpers and
>BIOS options to fiddle with, but nothing seemed to work well. It did seem
>to work better with just one PCI card though, but not perfect. I
>re-flashed the BIOS to their latest (beta) version and that was better but
>not 100%.
>
>The mobo on its own, with just 4 drives on the on-board controller seemed
>solid. It would boot OK, and run just fine, but as soon as I plugged
>additional SII cards into the PCI slots it all went pear-shaped.
>
>Finally, I got a 4-port Highpoint card (Rocket 1540) and that's made a lot
>of difference.
>
>I also found (along with someone else who emailled me about this), that
>the SATA cables supplied with the motherboard are less than reliable.
>Replacing them with nice flexable cables improved things too. I've
>subsequently gone off SATA. Damnit! The cables fiddly, the connectors
>fragile. Give me good old wide cables and chunky connectors anyday!
></rant> :)
>
>(FWIW: I tested the same disks and 4 2-port SII cards in a Xeon system
>with 4 PCI-X slots and it really flew, so I was confident it wasn't an OS
>problem, or a problem with the cards, or disks)
>
>The down-side is that the Highpoint driver is somewhat slower than the SII
>drivers (I'm losing ~5-8Mb/sec disk performance) and it's not open source.
>Another irritation is that it won't pass through the SMART commands. Yet
>another irritation is that it won't compile into the kernel, and must be
>loaded as a module, so I can't use auto-detection on the RAID arrays (I
>don't do initrd) No real issue, as in the startup scripts, I added another
>script after it checks the root filesystem, and before it checks & mounts
>the others - do an explicit modload, and explicit mdadm --assemble
>instructions.
>
>I also had issues trying to boot the damn thing. It really wasn't happy
>booting when the extra (SII) PCI cards installed, even when trying to just
>boot off the first drive on the on-board controller. In the end, I was
>booting it off an IDE flash drive and mounting / under /dev/sda1, then
>subsequently /dev/md1 (raid-1 of the first 4 drives on the on-board
>controller)
>
>Now, with a different chip-set PCI card, (The Highpoint) the BIOS is happy
>to boot off any one of the on-board drives, boot is /dev/md1, root is
>/dev/md1 and I'm happy. (md1 is a RAID-1 comprised of /dev/sd{a,b,c,d}1
>which are connected to the on-board SII 3114 controller)
>
>I've played with 2.6.10 and 2.6.11 RC kernels. Applied patches for the
>libata stuff to sort of make SMART work (the 4 drives on the 3114 need the
>-w flag to hddtemp, as it thinks they are asleep all the time), the
>Highpoint driver just won't pass the SMART commands.
>
>I had concerns after I got the case about airflow and keeping the drives
>cool - however, monitoring the 4 drives I can, shows them to be running at
>about 30C in my non AC office. Airflow is adequate through the drives and
>I'm happy. The Tyan motherboard has a plethora of sensors too - 3 on the
>motherboard, as well as one in each CPU, and Tyan (to their credit!)
>supply (almost) the right runes required to make lm_sensors work. The case
>comes with a fan and temperature monitoring board too, with 2 temperature
>probes which you can stick somewhere inside. I connected the 3 internal
>case fans to the motherboard which has space for 6 fans and can read them
>via lm_sensors. It's a shame the PSU doesn't provide a tacho output for
>its fans. I actually ran it for a couple of hours last night with the
>front and side vents blocked to see quickly it would get to an
>unacceptable temperature - not a terribly scientific test, and the fans
>were still running. It got to 40C then stabilised. I guess there was
>enough airflow through it somehow. The place it will be installed is an AC
>computer room.
>
>After experiments with RAID-6 on a test server, I've installed this box
>with RAID-6 on all partitions except the root partition which is RAID-1.
>(Even swap is on 3 x 4-way RAID-6 partitions, so sue me) Performance is
>adequate although not stellar - a single run of bonnie yields:
>
>Version 1.02b       ------Sequential Output------ --Sequential Input- --Random-
>                    -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
>Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
>mayday-ext3      2G 19098  98 66984  36 33246  19 19544  96 133123  38 300.2   1
>mayday-xfs       2G 20066  98 75102  27 27659  15 19826  96 126766  38 386.3   1
>
>A bit slow on writes, but maybe thats just RAID-6, although xfs improved
>writes and seeks it's slower than the other stuff. Still, benchmarks are
>not much use when compared to real-life!
>
>I've since moved the 3 data partitions on this box over to XFS. Root and
>/usr are still on ext3. Under XFS, It felt more responsive to interactive
>stuff when I was running 2 copies of bonnie on each of the data
>partitions. ie. I was still able to compile packages, kernel, etc. under
>the /usr partition in a reasonable matter. It felt clunkier under ext3,
>but this is just a feeling and nothing scientific. The applications it'll
>run are MySQL and CVS (data on md5, md6 being an overnight snapshot which
>gets dupped to tape. md7 is just data fileserverd via nfs and samba)
>
>If anyones interested, it looks like:
>
>Filesystem            Size  Used Avail Use% Mounted on
>/dev/md1              471M  324M  122M  73% /
>/dev/md3              1.9G  1.5G  425M  78% /usr
>/dev/md5               46G  5.7G   40G  13% /mounts/local0
>/dev/md6               46G  4.1G   41G   9% /mounts/local0.yesterday
>/dev/md7              1.3T  528k  1.2T   1% /mounts/pdrive
>
>all 8 disks are partitioned identically:
>
>Disk /dev/sda: 255 heads, 63 sectors, 30401 cylinders
>Units = cylinders of 16065 * 512 bytes
>
>   Device Boot    Start       End    Blocks   Id  System
>/dev/sda1   *         1        62    497983+  fd  Linux raid autodetect
>/dev/sda2            63       186    996030   83  Linux
>/dev/sda3           187       229    345397+  83  Linux
>/dev/sda4           230     30401 242356590    5  Extended
>/dev/sda5           230      1225   8000338+  83  Linux
>/dev/sda6          1226      2221   8000338+  83  Linux
>/dev/sda7          2222     30401 226355818+  83  Linux
>
>Swap is comprised of 3 RAID-6 units, sd{a,b,c,d}2 (md10) + sd{e,f,g,h}2
>(md11) + sd{e,f,g,h}1 (md12). /proc/swaps looks like:
>
>Filename                       Type            Size    Used    Priority
>/dev/md10                     partition       1991800 0       1
>/dev/md11                     partition       1991800 0       1
>/dev/md12                     partition       995704  0       0
>
>I'll be surprised if this machine ever needs any swap, but it's there just
>in-case.
>
>So there you go. I've got a 2nd one of these to build now, which I already
>have the same hardware for, (it'll be acting as a backup for this one) and
>possibly a few more after that, although I won't be buying a Tyan
>motherboard for them (The others don't require dual CPUs, being just
>filestores and not filestore + applications servers)
>
>This box has passed an initial 3-day test and will get a full weeks
>soak-testing before it finally goes live, but so-far it's looking very
>good.
>
>Cheers,
>
>Gordon
>-
>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>.
>
>  
>

