From: "Andrew Herdman" <andrew@whine.com>
Subject: RE: Sanity check installation scheme
Date: Wed, 14 Apr 2004 22:13:55 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040415021355.9824110185@mail.whine.com>
References: <6.0.1.1.0.20040414175626.04221ec0@no.incoming.mail>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6.0.1.1.0.20040414175626.04221ec0@no.incoming.mail>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

With that configuration, when you loose a disk, you loose the computer, swap
does not do any raid features itself, important sections of memory may have
been on that disk.  I would actually suggest creating the mirrors over all
four disks for the swap, / and /boot.  You'll eat more disk space, but you
will recover from a failed disk no matter which disk failed.

Andrew


-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Jeff Woods
Sent: Wednesday, April 14, 2004 8:13 PM
To: robin-lists@robinbowes.com
Cc: linux-raid@vger.kernel.org
Subject: Re: Sanity check installation scheme

At 4/15/2004 12:37 AM +0100, robin-lists@robinbowes.com wrote:
>Partition | sda          | sdb          | sdc      | sdd      |
>----------+--------------+--------------+----------+----------+
>         1 | RAID-1       | RAID-1       | swap     | swap     |
>           | (/boot, 80M) | (/boot, 80M) | (180M)   | (180M)   |
>           +--------------+--------------+----------+----------+
>         2 | RAID-1       | RAID-1       | RAID-5   | RAID-5   |
>           | (/, 100M)    | (/, 100M)    | (~4G)    | (~4G)    |
>           +--------------+--------------+----------+----------+
>         3 | RAID-5       | RAID-5       |
>           | (~4G)        | (~4G)        |
>           +--------------+--------------+
>
>This will give me the following partitions:
>
>/     100MB, mirrored
>/boot 80MB, mirrored
>/usr, /var, et. All on ~12G RAID-5 array.
>
>Does this look feasible? Can you see any major gotchas? Any better
>suggestions?

How about:

Partition | sda          | sdb          | sdc      | sdd      |
----------+--------------+--------------+----------+----------+
         1 | RAID-1       | RAID-1       | swap     | swap     |
           | (/boot, 80M) | (/boot, 80M) | (130M)   | (130M)   |
           +--------------+--------------+          |          |
         2 | swap         | swap         |          |          |
           | (50M)        | (50M)        |          |          |
           +--------------+--------------+----------+----------+
         3 | RAID-5       | RAID-5       | RAID-5   | RAID-5   |
           | (/, ~4G)     | (/, ~4G)     | (/, ~4G) | (/, ~4G) |
           +--------------+--------------+----------+----------+

This will give me the following partitions:

/boot 80MB, mirrored
/, /usr, /var, et. All on ~12G RAID-5 array.
360M swap spread across all 4 spindles

Adjust the capacities to suit.

Alternatively, use the other two spindles "next to" the /boot RAID-1 
partitions to provide a RAID-1 or RAID-0 /tmp filesystem.  However, I'd be 
inclined to increase the swap area and use tmpfs (which is virtual-memory 
based; i.e. RAM+swap) for /tmp.
--
Jeff Woods <kazrak+kernel@cesmail.net> 


-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

