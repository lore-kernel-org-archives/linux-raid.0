From: Phil Turmel <philip@turmel.org>
Subject: Re:
Date: Sun, 16 Dec 2012 22:55:20 -0500
Message-ID: <50CE97A8.4060901@turmel.org>
References: <a242a8e5475e737e42902d043d9cf4d0.squirrel@admin.purwin-it.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <a242a8e5475e737e42902d043d9cf4d0.squirrel@admin.purwin-it.de>
Sender: linux-raid-owner@vger.kernel.org
To: maik@purwin-it.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Maik,

On 12/16/2012 07:59 PM, Maik Purwin wrote:
> Hello,
> i make a misstake and disconnected 2 of my 6 disk in a software raid 5 on
> debian squeeze. After that the two disks reported as missing and spare so
> i have 4 on 4 in raid5.
> 
> after that i tried to add and re-add but without no efforts. Then i do this:
> 
> mdadm --assemble /dev/md2 --scan --force
> mdadm: failed to add /dev/sdd4 to /dev/md2: Device or resource busy
> mdadm: /dev/md2 assembled from 4 drives and 1 spare - not enough to start
> the array.
> 
> and now i didnt know to go on. i have fear to setup the raid new. I hope
> you can help.

You are in the right place.

Before doing anything else, it is vital that you collect and show
critical data about your array.

First, show the output of "mdadm -D /dev/md2"

Then, for all of the partitions involved, show "mdadm -E /dev/sdXN"

Finally, show "cat /proc/mdstat" and "dmesg".

Don't try to post them on a website--just make a big text e-mail.

Phil
