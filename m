From: David Greaves <david@dgreaves.com>
Subject: Re: ANNOUNCE: mdadm 1.6.0 - A tool for managing Soft RAID under
          Linux
Date: Fri, 04 Jun 2004 16:22:38 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40C093BE.2030103@dgreaves.com>
References: <16576.5818.189830.563396@cse.unsw.edu.au>    <40287.194.60.85.4.1086343951.squirrel@194.60.85.4>    <16576.26485.323313.378671@cse.unsw.edu.au> <27831.194.60.85.4.1086361244.squirrel@194.60.85.4>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <27831.194.60.85.4.1086361244.squirrel@194.60.85.4>
To: linux-raid@vger.kernel.org
Cc: Robin Bowes <robin-lists@robinbowes.com>
List-Id: linux-raid.ids

Robin Bowes wrote:

>Anyway, back to the subject in hand...
>
>I have a linux box into which I shall be installed 6 x 250GB SATA drives on a couple of
>Promise controllers (3 per controller). I guess these will be named
>/dev/sd{a,b,c,d,e,f}.
>  
>
<grin>
I just installed a single controller (TX4) and 3 250Gb drives...
the 4th, as I type, is with a courier, lost somewhere in Berkshire...

>I then intend to create a couple of mirrored partitions, one to boot from and one for
>swap, plus a large RAID5 array with several partitions for /usr,/home, /data, etc.
>
>So, would I do something like:
>  
>
<snip>
yes.

But any reason not to use lvm2? (anyone?)

If you fancy a cut'n'paste of my commands and output, look here: 
http://www.mythtv.info/moin.cgi/AdministrationSoftware_2fLvmRaid

Also talks you through setting up lvm2 on your new raid 5 array.
Later, when you run out of space (!) you can add another array and or 
shuffle partitions about using lvm.

David
