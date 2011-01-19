From: Jan Kasprzak <kas@fi.muni.cz>
Subject: Re: Optimize RAID0 for max IOPS?
Date: Wed, 19 Jan 2011 10:32:17 +0100
Message-ID: <20110119093217.GA15700@fi.muni.cz>
References: <20110118210112.D13A236C@gemini.denx.de> <4D361F26.3060507@stud.tu-ilmenau.de> <AANLkTi=v6yA_0OOfi2ymA67X0x+KsvV9VC5OgG+0DvKq@mail.gmail.com> <20110119071138.7B2D02FC@gemini.denx.de> <4D369E6D.8020604@stud.tu-ilmenau.de> <4D36A0F9.6040306@jcz.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4D36A0F9.6040306@jcz.nl>
Sender: linux-raid-owner@vger.kernel.org
To: Jaap Crezee <jaap@jcz.nl>
Cc: stefan.huebner@stud.tu-ilmenau.de, Wolfgang Denk <wd@denx.de>, Roberto Spadim <roberto@spadim.com.br>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jaap Crezee wrote:
: On 01/19/11 09:18, Stefan /*St0fF*/ H=FCbner wrote:
: >Am 19.01.2011 08:11, schrieb Wolfgang Denk:
: >Lol - I wouldn't have answered in the first place if I didn't have a=
ny
: >expertise.  So suit yourself - as you don't bring up any real number=
s
: >(remember: you've got the weird setup, you asked, you don't have eno=
ugh
: >money for the enterprise solution - so ...) nobody who worked with 3=
ware
: >controllers will believe you.
:=20
: Here's one: I switched from 3ware hardware based raid to linux softwa=
re=20
: raid and I am getting better throughputs. I had a 3ware PCI-X car (do=
n't=20
: know which type by hearth).
: Okay, to be honest I did not have a (enterprise solution?)=20
: battery-backup-unit. So probably no write caching...
:=20
	A "me too": 3ware 9550SX with 8 drives, RAID-5. The performance
(especially latency) was very bad. After I switched to the md SW RAID
and lowered the TCQ depth in the 3ware controller to 16[*], the filesys=
tem
and latency feels much faster.

	The only problem I had was a poor interaction of the CFQ
iosched with the RAID-5 rebuild process, but I have fixed this
by moving to deadline I/O scheduler.

	Another case was the LSI SAS 2008 (I admit it is a pretty low-end
HW RAID controller): 10 disks WD RE4 black 2TB in HW and SW RAID-10
configurations:

time mkfs.ext4 /dev/md0  # SW RAID
real	8m4.783s
user	0m9.255s
sys	2m30.107s

time mkfs.ext4 -F /dev/sdb # HW RAID
real	22m13.503s
user	0m9.763s
sys	2m51.371s

	The problem with HW RAID is that today's computers can dedicate tens
of gigabytes to buffer cache, which allows the I/O scheduler to reorder
requests based on latency and other criteria, which no RAID controller
can match, because it cannot see which requests are latency-critical
and which are not.

	Also, Linux I/O scheduler works really hard to keep all spindles
busy, while when you fill the TC queue of a HW RAID volume with request=
s
which maps to one or small number of physical disks, there is no way th=
e
controller can tell "send me more requests, but not from this area
of the HW RAID volume".

[*] 3ware driver is especially bad here, because its default queue
	depth is 1024, IIRC, which makes the whole I/O scheduler
	with queue size 512 a no-op. Think bufferbloat in the storage area.

--=20
| Jan "Yenya" Kasprzak  <kas at {fi.muni.cz - work | yenya.net - privat=
e}> |
| GPG: ID 1024/D3498839      Fingerprint 0D99A7FB206605D7 8B35FCDE05B18=
A5E |
| http://www.fi.muni.cz/~kas/    Journal: http://www.fi.muni.cz/~kas/bl=
og/ |
Please don't top post and in particular don't attach entire digests to =
your
mail or we'll all soon be using bittorrent to read the list.     --Alan=
 Cox
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
