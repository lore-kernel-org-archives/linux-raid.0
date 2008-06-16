From: "Ken Drummond" <ken.drummond@kendrummond.com>
Subject: Re: Failed RAID5 array grow after reboot interruption;
      mdadm: Failed to restore critical section for reshape, sorry.
Date: Mon, 16 Jun 2008 20:00:25 +1000 (EST)
Message-ID: <49481.61.88.57.1.1213610425.squirrel@home.kendrummond.com>
References: <3E998AD6CC01E746957550D4CD642A742303F8@TGEN-M2.ad.tgen.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3E998AD6CC01E746957550D4CD642A742303F8@TGEN-M2.ad.tgen.org>
Sender: linux-raid-owner@vger.kernel.org
To: jmolina@tgen.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> There does not appear to be anything wrong with the hardware of any disk.
> Kernel version was 2.6.23.11 -- I am aware of some nasty bug in -rc3, but
> I don't think this is the same issue.  mdadm is v2.6.3.

I had exactly the same problem on the weekend and after some investigation
the problem seems to be mdadm v2.6.3.  There was an announcement on this
list for v2.4.4 which included fixes to restarting an interrupted grow.  I
was using ubuntu 8.04 which uses mdadm v2.6.3 and doesn't seem to have an
easy method to upgrade.  However, my "fix" was to boot from a gentoo
livecd 2008.0b2 and use mdadm v2.6.2 to reconstruct the array (it's still
going, adding 1TiB disk to the previous 3 disk raid 5 array).

> Advice?  I'll give just about anything a try, but I'll have to start
> creating new partitions, arrays, and the whole bit tomorrow and restore
> the data.

Try using a different version of mdadm I think it's up to 2.6.7 now but
for me the older v2.6.2 worked too. I did mount the array after it started
rebuilding on 2.6.2 and everything seems to be there.

--
Ken.

