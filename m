From: Phil Turmel <philip@turmel.org>
Subject: Re: md prefered minor has been renumbered
Date: Mon, 28 Nov 2016 18:10:20 -0500
Message-ID: <5b2eb59e-7447-da7f-bb0a-85866f2146ef@turmel.org>
References: <BC4985417D7F7B49B9AB545333BDB61B191FE1A2@Exchange-MBX1.esf.edu>
 <BC4985417D7F7B49B9AB545333BDB61B191FE1BC@Exchange-MBX1.esf.edu>
 <91b64061-6026-c738-75a6-8d80a177aec8@turmel.org>
 <BC4985417D7F7B49B9AB545333BDB61B191FE20C@Exchange-MBX1.esf.edu>
 <bccbeb42-82b5-87fc-aa74-11a34b8c9d8d@turmel.org>
 <BC4985417D7F7B49B9AB545333BDB61B191FE29B@Exchange-MBX1.esf.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BC4985417D7F7B49B9AB545333BDB61B191FE29B@Exchange-MBX1.esf.edu>
Sender: linux-raid-owner@vger.kernel.org
To: "Randall C. Grimshaw" <rgrimsha@esf.edu>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

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
