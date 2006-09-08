From: Michael Tokarev <mjt@tls.msk.ru>
Subject: proactive-raid-disk-replacement
Date: Fri, 08 Sep 2006 12:48:51 +0400
Message-ID: <45012E73.5040900@tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Recently Dean Gaudet, in thread titled 'Feature
Request/Suggestion - "Drive Linking"', mentioned his
document, http://arctic.org/~dean/proactive-raid5-disk-replacement.txt

I've read it, and have some umm.. concerns.  Here's why:

....
> mdadm -Gb internal --bitmap-chunk=1024 /dev/md4
> mdadm /dev/md4 -r /dev/sdh1
> mdadm /dev/md4 -f /dev/sde1 -r /dev/sde1
> mdadm --build /dev/md5 -ayes --level=1 --raid-devices=2 /dev/sde1 missing
> mdadm /dev/md4 --re-add /dev/md5
> mdadm /dev/md5 -a /dev/sdh1
>
> ... wait a few hours for md5 resync...

And here's the problem.  While new disk, sdh1, are resynced from
old, probably failing disk sde1, chances are high that there will
be an unreadable block on sde1.  And this means the whole thing
will not work -- md5 initially contained one working drive (sde1)
and one spare (sdh1) which is being converted (resynced) to working
disk.  But after read error on sde1, md5 will contain one failed
drive and one spare -- for raid1 it's fatal combination.

While at the same time, it's perfectly easy to reconstruct this
failing block from other component devices of md4.

That to say: this way of replacing disk in a software raid array
isn't much better than just removing old drive and adding new one.
And if the drive you're replacing is failing (according to SMART
for example), this method is more likely to fail.

/mjt
