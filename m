From: Adam Goryachev <adam@websitemanagers.com.au>
Subject: Re: Best practice for large storage?
Date: Fri, 15 Feb 2013 12:01:53 +1100
Message-ID: <511D8901.2020803@websitemanagers.com.au>
References: <CAH3kUhGVt1iyn9tt=2-+f6H++obOGSK3x0pBBPZV8CFUXjp5yw@mail.gmail.com> <29597293.40.1360884193537.JavaMail.root@zimbra> <CAH3kUhHG=jqKB1BdNh5YxR-TfE4Wh4-eOrGduhu2ksWtO4LJtA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAH3kUhHG=jqKB1BdNh5YxR-TfE4Wh4-eOrGduhu2ksWtO4LJtA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <rspadim@gmail.com>
Cc: Roy Sigurd Karlsbakk <roy@karlsbakk.net>, Jeff Johnson <jeff.johnson@aeoncomputing.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 15/02/13 10:42, Roberto Spadim wrote:
> the problem is checksum? i really don't understand why the filesystem
> is not the problem, and why storage is the 'key'
>
> storage -> mdadm + harddisks / raid hardware + harddisks / network
> storage + hard disks -> here the key is data integrity WITHOUT SILENT
> DATA LOSS, today i only saw this on enterprise hardware raid
> controlers + enterprise sas disks
>
> lvm + filesystem -> don't have problem increasing storage -> here a
> filesystem that can grow without problems is mandatory since you want
> but more disks... the lvm part is to easly work with devices
>
> any part that i forgot?
>
> 2013/2/14 Roy Sigurd Karlsbakk <roy@karlsbakk.net>:
>> xfs+lvm+mdadm works, but I'm still back to my original question. I don't care about what filesystem is on top, only about the storage underneath. Read the original question again, please

I assume the question can be reduced to:
1) You need a very large amount of space (requires a large number of disks)
2) You need to be able to expand that space over time
3) You want decent data redundancy
4) You will have a reasonable amount of concurrent access by multiple users and want decent performance

From my readings of the list, it would seem the suggestion is to use RAID6 + concatenation, with around 6 to 8 drives in each RAID6, and use XFS with certain parameters to ensure it balances the directories across multiple groups of the RAID6. Basically, you want to put as many drives into each RAID6 to reduce wasted space, but not too many or else you will suffer a triple drive failure and lose the whole lot.

If you did not need to grow the space, then you would use RAID60, and do striping, but I think you can't grow that, although some pages I just read suggest it might be possible to grow a raid0 by converting to raid4 and back again.

Another option would be to use LVM to join multiple RAID6's together

Don't know if this helps, but hopefully.

Regards,
Adam

-- 
Adam Goryachev
Website Managers
Ph: +61 2 8304 0000                            adam@websitemanagers.com.au
Fax: +61 2 8304 0001                            www.websitemanagers.com.au

