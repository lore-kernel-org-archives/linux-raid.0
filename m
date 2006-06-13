From: Gordon Henderson <gordon@drogon.net>
Subject: Re: RAID tuning?
Date: Tue, 13 Jun 2006 11:32:44 +0100 (BST)
Message-ID: <Pine.LNX.4.56.0606131124160.27931@lion.drogon.net>
References: <4558af040606121737w1bab008am1110e4e1c2cd8934@mail.gmail.com>
 <17550.2944.728044.154492@cse.unsw.edu.au> <448E127F.5010708@comcast.net>
 <Pine.LNX.4.56.0606130906370.27931@lion.drogon.net>
 <Pine.LNX.4.64.0606130620410.8834@p34.internal.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0606130620410.8834@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Adam Talbot <talbotx@comcast.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 13 Jun 2006, Justin Piszcz wrote:

>     mkfs -t xfs -f -d su=128k,sw=14 /dev/md9
>
> Gordon, What speed do you get on your RAID, read and write?
>
> When I made my XFS/RAID-5, I accepted the defaults for the XFS filesystem
> but used a 512kb stripe.  I get 80-90MB/s reads and ~39MB/s writes.
>
> On 5 x 400GB ATA/100 Seagates (on a regular PCI bus, max, 133mb/s)

Standard Bonnie (which I find to be a crude, but reasonable test of overal
throughput of a device - server has 1G of RAM)

zem:/mounts/pdrive# bonnie -n0 -f -g0 -u0
Using uid:0, gid:0.
Writing intelligently...done
Rewriting...done
Reading intelligently...done
start 'em...done...done...done...
Version  1.03       ------Sequential Output------ --Sequential Input- --Random-
                    -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
zem              2G           195984  59 68699  31           217398  52  1028   3
zem,2G,,,195984,59,68699,31,,,217398,52,1028.3,3,,,,,,,,,,,,,


Other tests:

zem:/mounts/pdrive# hdparm -T /dev/md9
/dev/md9:
 Timing cached reads:   3592 MB in  2.00 seconds = 1797.08 MB/sec

zem:/mounts/pdrive# hdparm -t /dev/sda /dev/md9
/dev/sda:
 Timing buffered disk reads:  228 MB in  3.01 seconds =  75.87 MB/sec
/dev/md9:
 Timing buffered disk reads:  242 MB in  3.02 seconds =  80.14 MB/sec

The server is some Dell 1U box with a single P4/HT processor and 1G of
RAM. It has twin internal SCSI drives on a Fusion MPT driver, drives are
using Linux s/w RAID-1, of course, and it has 2 external SCSI connectors
(dual Adaptec controller) going to some big Dell 14-drive chasis with 7
drives on each chain. I've not actually seen this box - I did the entire
build remote with the aid of someone in-front of the box who loaded Debian
on it under my instructions, until I could SSH into it and complete the
process, and did the neccessary BIOS fiddling to make sure it would boot
off the internal drives - it's in Califronia, US I'm in Devon, UK...

Gordon
