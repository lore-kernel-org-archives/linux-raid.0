From: maarten van den Berg <maarten@ultratux.net>
Subject: Re: Moving a RAID5 array
Date: Fri, 28 May 2004 01:20:05 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200405280120.05296.maarten@ultratux.net>
References: <000001c44436$a5df15c0$7001a8c0@darwin>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <000001c44436$a5df15c0$7001a8c0@darwin>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday 28 May 2004 00:04, Tim Harvey wrote:

Disclaimer: I'm not a real expert, but have had my share of raid5 experiences.

> My question is that, not being very familiar with Linux raid or mdadm,
> I'm wondering if I can mount the array on my Linux system when the
> devices are other than described above (they would likely be /dev/hdc1,
> /dev/hdd1, etc as my boot/root drives use hda/hdb).  Additionally, how

I did shuffle my disks at several points in time, and it figures that out by 
itself somehow (there must be something in the superblock identifying which 
drive it is). 

> should I go about mounting this array in a way that if anything doesn't
> work right, it doesn't trash the array.  I'm a little paranoid that I
> may do something wrong and the raidutils will start reconstructing or
> otherwise altering the information on the array.

There are several things to note. You want to disallow the raid to start any 
reconstruction, and you need to skip any fsck at mount, as well as replaying 
of journals if they are journaling filesystems.

Issue #1 Can be assured (AFAIK) by just attaching one disk less. Then the 
array will be in degraded mode and cannot / will not attempt a resync.
In addition, this will enable you to choose another set of disks, should the 
outlook on the first three be less than favourable...

Issue #2 Should be assured by mounting read-only, without prior fsck.

Issue #3 I'm not sure about. Consult the manualpage detailing your specific 
filesystem...  Maybe instead of mounting you could run an fsck with an option 
to do only a test-run / dry-run i.e. allow no writes whatsoever during fsck. 
If that fsck succeeds, chances are very good that all is in order.

Anyway, my guess is, you'll have no trouble at all.  A power-loss is not the 
very worst that can happen to an array. In my humble opinion...

> Thanks for any help.  I've read over the Linux RAID FAQ and looked
> through the man pages for mdadm, but I'm pretty paranoid about loosing
> the data and want to consult the experts here.

<Grin> No backups huh ?  Been there,  done that,  still got my data back. :)

Well, good luck with your endeavors !

Maarten

> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
When I answered where I wanted to go today, they just hung up -- Unknown

