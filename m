From: Steve Brueggeman <xioborg@yahoo.com>
Subject: Re: raidreconf success report
Date: Tue, 05 Nov 2002 11:14:51 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <b2vfsusu29ejgivvg19fpe42dicfekjk9h@4ax.com>
References: <Pine.LNX.4.44.0211031621180.29013-100000@frank.gwc.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0211031621180.29013-100000@frank.gwc.org.uk>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is the first I've heard of raidreconf.  

Where is it, and can it be used to reduce a RAID-5 configuration???

Steve Brueggeman

On Sun, 3 Nov 2002 16:33:09 +0000 (GMT), you wrote:

>I am happy to report successfully using raidreconf to grow a 7 x 73GB
>RAID5 to 10 x 73GB RAID5.
>
>The operation took around 16 hours. Machine is a 4-way xeon with 6GB RAM;
>though the kernel on the CD I booted from only supported UP/1GB RAM. I'm
>not sure whether the extra CPUs/memory would have helped performance.
>Disks are 10kRPM scsi disks.
>
>The sequence of commands was:
>
>boot from cd (raid is root filesystem)
>reiserfsck /dev/md0
>raidstop /dev/md0
>raidreconf -o oldraidtab -n newraidtab -m /dev/md0
>go home and sleep!
>reiserfsck /dev/md0
>resize_reiserfs /dev/md0
>reiserfsck /dev/md0
>then reboot, and machine carried on as before!
>
>No errors were reported at any stage.
>
>All very impressive. Thanks for the good work!

