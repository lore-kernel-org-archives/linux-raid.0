From: "Timothy D. Lenz" <tlenz@vorgon.com>
Subject: Re: Converting system to raid
Date: Fri, 10 Apr 2009 12:22:44 -0700
Message-ID: <008001c9ba12$3ac92c10$0a00a8c0@vorg>
References: <003801c9b96d$21a0f420$0a00a8c0@vorg> <20090410132233.GA15442@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

How can cp not work? every guide I found used ether cp or rsync. Even guides on seting up an auto backup system use cp or rsync.
Seems the only files/folders that shouldn't get copied are the block device ones that are created at boot and are not really on the
drive.

----- Original Message ----- 
From: "Robin Hill" <robin@robinhill.me.uk>
To: <linux-raid@vger.kernel.org>
Sent: Friday, April 10, 2009 6:22 AM
Subject: Re: Converting system to raid

On Thu Apr 09, 2009 at 04:44:25PM -0700, Timothy D. Lenz wrote:

> I used "sudo cp -axu / /mnt/md0" to copy hda to md0. I changed
> /mnt/md0/etc/fstab so that "/" os /md0 instead of /hda.
>
This won't work properly, for a start.  You _cannot_ copy a running
system - there's bound to be data which hasn't yet been flushed to disk,
as well as locked files.  You need to boot off a CD (or another
partition) and do the copy from there.

HTH,
    Robin
-- 
     ___
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

