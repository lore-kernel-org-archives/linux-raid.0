From: Jeff Woods <Kazrak+kernel@cesmail.net>
Subject: Re: Sanity check installation scheme
Date: Wed, 14 Apr 2004 18:12:51 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <6.0.1.1.0.20040414175626.04221ec0@no.incoming.mail>
References: <S262063AbUDNXhL/20040414233712Z+1806@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <S262063AbUDNXhL/20040414233712Z+1806@vger.kernel.org>
References: <S262063AbUDNXhL/20040414233712Z+1806@vger.kernel.org>
To: robin-lists@robinbowes.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

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


