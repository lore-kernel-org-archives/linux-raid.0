From: noriok <noriok@kitakami.hss.iwate-u.ac.jp>
Subject: Re: Software RAID 1 Problem: "raid_autorun failed" booting from /dev/md0
Date: Fri, 27 Jun 2003 12:19:45 +0900
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200306270319.AA01562@ran.kitakami.hss.iwate-u.ac.jp>
References: <02b901c33be0$7a0f9320$c8de11cc@black>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <02b901c33be0$7a0f9320$c8de11cc@black>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mike wrote:
>Make sure you've fdisk'd the disks and changed the partition type:
>fd  Linux raid autodetect

Thank you very much for your reply, Mike.
But I had already finished the setting you mentioned.

I think the best way is to delete the software RAID 1 setting completely once
and set up again. But I don't know how to delete the setting I've done before.

--
# fdisk /dev/hdb
    :    :    :
Command (m for help): p

Disk /dev/hdb: 255 heads, 63 sectors, 1027 cylinders
Units = cylinders of 16065 * 512 bytes

   Device Boot    Start       End    Blocks   Id  System
/dev/hdb1             1       970   7791493+  fd  Linux raid autodetect
/dev/hdb2           971      1020    401625   fd  Linux raid autodetect
