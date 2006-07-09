From: "Molle Bestefich" <molle.bestefich@gmail.com>
Subject: Re: only 4 spares and no access to my data
Date: Sun, 9 Jul 2006 21:23:37 +0200
Message-ID: <62b0912f0607091223y3d0a1ab5xbc5fb01ce2a74f9e@mail.gmail.com>
References: <loom.20060709T205013-455@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <loom.20060709T205013-455@post.gmane.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Karl Voit <news@karl-voit.at>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Karl Voit wrote:
> I published the whole story (as much as I could log during my reboots
> and so on) on the web:
>
>               http://paste.debian.net/8779

From the paste bin:

> 443: root@ned ~ # mdadm --examine /dev/sd[abcd]

Shows that all 4 devices are ACTIVE SYNC....

Next command:

> 563: root@ned ~ # mdadm --assemble --update=summaries /dev/md0 /dev/sda1 /dev/sdb1 /dev/sdc1 /dev/sdd1
> mdadm: /dev/md0 assembled from 0 drives and 4 spares - not enough to start the array.

Then:

> 568: root@ned ~ # mdadm --examine /dev/sd[abcd]1

Suddenly shows all 4 devices as SPARE?

What the heck happened in between?
Did you do anything evil, or is it a MD bug, or what?


> mdadm-version: 1.12.0-1
> uname: Linux ned 2.6.13-grml

You should probably upgrade at some point, there's always a better
chance that devels will look at your problem if you're running the
version that they're sitting with..


> Andreas Gredler suggested following lines as a last attempt but risk
> of loosing data which I want to avoid:
>
> mdadm --stop /dev/md0
> mdadm --zero-superblock /dev/sda
> mdadm --zero-superblock /dev/sdb
> mdadm --zero-superblock /dev/sdc
> mdadm --zero-superblock /dev/sdd
> mdadm --assemble /dev/md0 /dev/sda1 /dev/sdb1 /dev/sdc1\
>  /dev/sdd1 --force
> mdadm --create -n 4 -l 5 /dev/md0 missing /dev/sdb1\
>  /dev/sdc1 /dev/sdd1

Running zero-superblock on "sd[abcd]" and then assembling the array
from "sd[abcd]_1_" sounds odd to me.
