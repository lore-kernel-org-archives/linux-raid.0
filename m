From: Mario Holbe <Mario.Holbe@TU-Ilmenau.DE>
Subject: Re: Spares and partitioning huge disks
Date: Sat, 8 Jan 2005 11:22:28 +0100
Message-ID: <croc94$kiu$1@sea.gmane.org>
References: <crmt7e$8d6$1@sea.gmane.org> <200501072157.j07Lvg906301@www.watkins-home.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Guy <bugzilla@watkins-home.com> wrote:
> Each of his six RAID5 arrays will only use 1 partition of each physical
> disk.
> His plan is to combine the 6 arrays with LVM or a linear array.

Ah, I just missed that part, sorry & thanks :)
I agree with you then - it's something like a RAID5+0 (analogue
to RAID1+0) then and it *should* work just fine :)



regards,
   Mario
-- 
Independence Day: Fortunately, the alien computer operating system works just
fine with the laptop. This proves an important point which Apple enthusiasts
have known for years. While the evil empire of Microsoft may dominate the
computers of Earth people, more advanced life forms clearly prefer Mac's.

