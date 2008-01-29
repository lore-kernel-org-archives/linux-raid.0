From: Moshe Yudkowsky <moshe@pobox.com>
Subject: Re: In this partition scheme, grub does not find md information?
Date: Tue, 29 Jan 2008 05:02:57 -0600
Message-ID: <479F07E1.7060408@pobox.com>
References: <479EAF42.6010604@pobox.com> <18334.46306.611615.493031@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18334.46306.611615.493031@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil, thanks for writing. A couple of follow-up questions to you and the 
group:

Neil Brown wrote:
> On Monday January 28, moshe@pobox.com wrote:
>> Perhaps I'm mistaken but I though it was possible to do boot from 
>> /dev/md/all1.
> 
> It is my understanding that grub cannot boot from RAID.

Ah. Well, even though LILO seems to be less classy and in current 
disfavor, can I boot RAID10/RAID5 from LILO?

> You can boot from raid1 by the expedient of booting from one of the
> halves.

One of the puzzling things about this is that I conceive of RAID10 as 
two RAID1 pairs, with RAID0 on top of to join them into a large drive. 
However, when I use --level=10  to create my md drive, I cannot find out 
which two pairs are the RAID1's: the --detail doesn't give that 
information. Re-reading the md(4) man page, I think I'm badly mistaken 
about RAID10.

Furthermore, since grub cannot find the /boot on the md drive, I deduce 
that RAID10 isn't what the 'net descriptions say it is.

> A common approach is to make a small raid1 which contains /boot and
> boot from that.  Then use the rest of your devices for raid10 or raid5
> or whatever.

Ah. Ny understanding from a previous question to this group was that 
using one partition of the drive for RAID1 and the other for RAID5 would 
(a) create inefficiencies in read/write cycles as the two different md 
drives maintained conflicting internal tables of the overall physical 
drive state and (b) would create problems if one or the other failed.

Under the alternative solution (booting from half of a raid1) since I'm 
booting from just one of the halves or the raid1, I would have to set up 
grub on both halves. If one physical drive fails, grub would fail over 
to the next device.

(My original question was prompted by my theory that multiple RAID5s, 
built out of different partitions, would be faster than a single large 
drive -- more threads to perform calculations during writes to different 
parts of the physical drives.)

>> Am I trying to do something that's basically impossible?
> 
> I believe so.

If the answers above don't lead to a resolution, I can create two RAID1 
pairs and join them using LVM. I would take a hit by using LVM to tie 
the pairs intead of RAID0, I suppose, but I would avoid the performance 
hit of multiple md drives on a single physical drive, and I could even 
run a hot spare through a sparing group. Any comments on the performance 
hit -- is raid1L a really bad idea for some reason?

-- 
Moshe Yudkowsky * moshe@pobox.com * www.pobox.com/~moshe
  "It's a sobering thought, for example, to realize that by the time
   he was my age, Mozart had been dead for two years."
    					-- Tom Lehrer
