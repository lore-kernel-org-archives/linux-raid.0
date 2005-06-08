From: Harry Mangalam <hjm@tacgi.com>
Subject: Re: 3Ware on 64bit Linux.
Date: Wed, 8 Jun 2005 11:56:30 -0700
Message-ID: <200506081156.31051.hjm@tacgi.com>
References: <602f2f2b050608100938ddad81@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <602f2f2b050608100938ddad81@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Jason Leach <jason.leach@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm working thru this right now, so it can't be said that I HAVE a stable 
system.  What I have is a lot of experience with UNSTABLE systems, so you can 
learn from my misadventures.  

I have what is probably a relatively common setup for a medium high end, 
stand-alone, PC-based server:

- dual opteron IWILL Mobo, Gb ethernet
- Silicon image 4port SATA controller onboard (now disabled), 
- 3ware 9500S 8 port card running 8x250GB WD 2500SD disks in RAID5.  
- Disks are in 2x 4slot Chenbro hotswap RAID cages. 
- running kubuntu Linux in pure 64bit mode (altho bringing up KDE 
  currently locks the system in some configurations)
- using kernel image 2.6.11-1-amd64-k8-smp as a kubuntu debian install 
    (NOT custom-compiled)
- OS is running from a separate 200GB IDE disk 
    (which recently bonked at 3 months old)
- on an APC UPS (runnning apcupsd w/ a usb cable)

I've had nothing but trouble for a couple of months - some it my fault, some 
of it 3ware's fault, some of it WD's fault, some of it the server vendor's 
fault.

I tried SW raid 1st using the onboard controller SATA - it was a bit confusing 
to set up, but it worked well, and performed well on the bonnie++ tests and 
on real-life copy and read/write tasks.  I probably should have bought 
another similar controller (<$50) and stayed with SW RAID and mdadm.

However, because of the trickiness of it, I wanted to leave the machine 
simpler to administer, so I tried an 3ware 8506-8 controller with a full set 
of WD JD-series disks.  That was a catastrophe - all kinds of problems 
setting it up, finding out the bash script software installer installed 32b 
versions of the software and then silently died without error.  This led to a 
disk failing silently and the rebuild failed leading to the loss of the 
entire array's data.  Since we had just started using it, it was surprising, 
but not devastating.  In investigating this, I found that there ARE 64 bit 
versions of both the commandline software and the 3dm2 web-enabled software 
but they're difficult to find.  I have a much longer rant on this - I'll mail 
it to anyone interested.

The short version is that due to 'one of those things', my support call to 
3ware went awry and wasn't answered for several days - and their web site is 
truly frustrating and ill-designed (don't type anything into any of their 
support forms without having 1st typed into a local buffer - the 3ware 
support forms will allow you to type and type and type and then reject 
everything on submitting it if you've gone over their (often unannounced) 
word count.  Support URLS are hidden as plain text (their web designer is 
going to a special place in hell), click paths are taken direct from 
'adventure' (you are in a maze of dark, twisty web pages, all alike..).
However, I have to say that in the end they came thru - after the fumbled 
support call, they replaced the faulty 8506 with a 9500S, and came up with a 
lot of good, useful advice and stayed with me.  Good hardware, good tech 
people, VERY lousy web pages, lousy initial support routing, fair software, 
fairly lousy SW docs.

The 3dm2 software, once the correct version was installed, works fine (tho the 
docs are a bit fuzzy (no way to find out what the passwords were to the 3dm2 
accounts (they're buried in the installation scripts) and on Debian, it 
doesn't write a config file when you change the defaults so that it reverts 
to the defaults on reboot, leaving your spiffing new array vulnerable to 
anyone who probes port 888.  Make sure that you've 'touch'ed 
a  /etc/3dm2/3dm2.conf file before starting.

Then problems with the disks - the JD series are particularly ill suited to 
RAID5 apparently because of the BIOS algorithms and WD will replace them for 
more expensive SD series disks without complaint but the replacement web form 
is quite confusing and this delayed things even longer (they replaced only 
SOME of the disks with SD and some of them with more JDs).  This was 
admittedly my fault, but the WD support person had a similarly difficult time 
with the form.  

Dan Stromberg who has been posting here recently can speak to the 
viability/reliability of the right Maxtor disks to use, but the 3ware tech 
said that the WD SD series disks were very reliable and fast.

The Chenbro hotswap cages have also been a source of trouble - one port on one 
cage (I have 2 cages of 4 disks each) has been giving me trouble and the 
actual hardware is not well-made - the SATA connectors are just pushed onto 
very fragile pins on the circuit board, so when the cables are pulled off, 
the whole connector comes away as well and the pins can be bent out of 
position very easily when trying to put them back.
Unless you absolutely need the hotswap ability, DON'T.  It's one more piece of 
electronica that can go wrong.

The upside is that the 3ware card on a 64 bit opteron seems to be usable, tho 
I can't say that the whole system has been stable for a long time. The 3ware 
cards are supported in the kernel source so there's no need for separate 
drivers.  There's no messing with separate devices as the 3ware card presents 
as a huge SCSI disk.  The 3ware card (supposedly) takes care of mapping & 
remapping some of the low-level disk problems recently reported here.  
However, the speed of the array is really no better than SW raid5 as judged 
by bonnie++ and some large manual copies and programmatic reads/writes.  What 
I liked about the SW RAID is the degree of flexibility there is in both 
software and hardware (can mix and match much cheaper controllers), the 
price, and the much wider availability of knowlegable support (this list, 
google searches, etc).  With 3ware, you really are at the mercy of their 
support system.


 I finally have most of the above described problems addressed and as I write 
this, the last few inodes of an ext3 fs are being written to the 1.7TB array. 
(altho this was the 3rd time I tried it, using various parameters ( tho I 
suspect network problems interrupting my session rather than failure on the 
array). We'll see if it lasts).

I have been getting several emails from the 3ware card describing various 
repairs-on-the-fly that it's been making:

Wed, Jun 08, 2005 10:09.19AM - Controller 0
WARNING - (0x04:0x0023): Sector repair completed: port=6, LBA=0xDF6022E so 
that gives me a little more confidence in the system.


The UPS is yet another story for another time.

OK - Nuff said for now.  Maybe more later.

hjm



On Wednesday 08 June 2005 10:09 am, Jason Leach wrote:
> hi,
>
> Does anyone have a 3ware 90500S card working on 64bit Linux to a point
> where it is very stable and preforming as advertised?  If so, can you
> send me the HW specs you are using? (mobo, cpu, chipsets).  I'm
> considering putting one together but don't want an unstable system.
>
> Jason.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Cheers, Harry
Harry J Mangalam - 949 856 2847 (vox; email for fax) - hjm@tacgi.com 
            <<plain text preferred>>
