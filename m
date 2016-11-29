From: "Randall C. Grimshaw" <rgrimsha@esf.edu>
Subject: RE: md prefered minor has been renumbered
Date: Tue, 29 Nov 2016 01:12:10 +0000
Message-ID: <BC4985417D7F7B49B9AB545333BDB61B191FE2D1@Exchange-MBX1.esf.edu>
References: <BC4985417D7F7B49B9AB545333BDB61B191FE1A2@Exchange-MBX1.esf.edu>
 <BC4985417D7F7B49B9AB545333BDB61B191FE1BC@Exchange-MBX1.esf.edu>
 <91b64061-6026-c738-75a6-8d80a177aec8@turmel.org>
 <BC4985417D7F7B49B9AB545333BDB61B191FE20C@Exchange-MBX1.esf.edu>
 <bccbeb42-82b5-87fc-aa74-11a34b8c9d8d@turmel.org>
 <BC4985417D7F7B49B9AB545333BDB61B191FE29B@Exchange-MBX1.esf.edu>,<5b2eb59e-7447-da7f-bb0a-85866f2146ef@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5b2eb59e-7447-da7f-bb0a-85866f2146ef@turmel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


________________________________________
From: Phil Turmel [philip@turmel.org]
Sent: Monday, November 28, 2016 6:10 PM
To: Randall C. Grimshaw
Cc: Linux-RAID
Subject: Re: md prefered minor has been renumbered

Hi Randall,

{ Convention on kernel.org is reply-to-all and to avoid top-posting. I
added the list back. }

On 11/28/2016 05:56 PM, Randall C. Grimshaw wrote:
> Thank you Phil:
>   the linux rescue mode didn't have blkid but I had the uuid's from mdadm --examine,
> so I tried uuid=xxxxx in the fstab file. no joy. it is failing in the load of the ramfs, after assembly but before fstab.
>   it appears that I am caught in the catch22 where I cannot update initramfs until I minimally fix the duplicate md122 problem so that I can assemble /var and mount it.
> Randall

You must use the form UUID="xxxx" with caps and quotes.

you can test with mount UUID="....." /path/to/mount/point to check.

Phil
----------------------------------

Phil:
  Sorry for the typos and the top posts. Even with Caps and Quotes I was still in trouble.
sequentially it complains that md122 is already running - it cannot run /sdb5 (the duplicate)
then it tries to resume from /dev/md1 -- (md1 remains as swap) then a bunch of indicators that the initramfs
is unable to mount everything... but the post I found was basically correct.
I suspect it was the conflicting devices that made my situation different but the solution was to specify the 
device to mdadm using uuid= (thank you for that tip)
so my assembly command looked like: mdadm -A --uuid=xxxx --update=super-minor /dev/mdx
it solved the conflicting devices and returned my system to running state.
[SOLVED]


