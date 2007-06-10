From: Bernd Schubert <bs@q-leap.de>
Subject: Re: LVM on raid10 - severe performance drop
Date: Sun, 10 Jun 2007 03:06:45 +0200
Message-ID: <20070610010644.GA24847@lanczos.q-leap.de>
References: <466B3E24.1020203@rabbit.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <466B3E24.1020203@rabbit.us>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Rabbitson <rabbit@rabbit.us>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Jun 10, 2007 at 01:56:20AM +0200, Peter Rabbitson wrote:
> Hi,
> 
> This question might be better suited for the lvm mailing list, but 
> raid10 being rather new, I decided to ask here first. Feel free to 
> direct me elsewhere.
> 
> I want to use lvm on top of a raid10 array, as I need the snapshot 
> capability for backup purposes. The tuning and creation of the array 
> went fine, I am getting the read performance I am looking for. However 
> as soon as I create a VG using the array as the only PV, the raw read 
> performance drops to the ground. I suspect it has to do with some minima 
> l tuning of LVM parameters, but I am at a loss on what to tweak (and 
> Google is certainly evil to me today). Below I am including my 
> configuration and test results, please let me know if you spot anything 
> wrong, or have any suggestions.
> 

[snip]
> 
> 
> root@Arzamas:~# dd if=/dev/md1 of=/dev/null bs=512 count=4000000
> 4000000+0 records in
> 4000000+0 records out
> 2048000000 bytes (2.0 GB) copied, 11.4032 seconds, 180 MB/s
> root@Arzamas:~#
> 
> 
> root@Arzamas:~# dd if=/dev/raid10/space of=/dev/null bs=1M count=2000
> 2000+0 records in
> 2000+0 records out
> 2097152000 bytes (2.1 GB) copied, 25.7089 seconds, 81.6 MB/s
> root@Arzamas:~#
> 

Try to increase the read-ahead size of your lvm devices:

blockdev --setra 8192 /dev/raid10/space

or increase it at least to the same size as of your raid (blockdev
--getra /dev/mdX).


Hope it helps,
Bernd
