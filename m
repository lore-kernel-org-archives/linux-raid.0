From: Kubes <pkubat.mlist@freepricealerts.com>
Subject: Expanding raid0
Date: Wed, 19 Dec 2012 16:23:35 -0500
Message-ID: <CAFn++Q4XMw9DLpg=d_WhkteW=qQ_cFct_kr4THfpcgZuYjyX+w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

All,

I have yet to find THE definitive word (via any search and forums) if
this is possible;  expanding a raid0 set by adding drives.  (Please, I
know there is no redundancy, and that is fine as these volumes are
really Amazon WS EBS volumes, so we only strip for speed improvements)



It seem this works:
  more /proc/diskstats
  mdadm --create /dev/md0 --chunk=256 --level=0 --raid-devices=2 /dev/sd[b-c]
  mdadm --detail /dev/md0
  mkfs.xfs /dev/md0
  mount /dev/md0 /mnt
  vi /mnt/test
  umount /dev/md0

  mdadm --grow /dev/md0 --level=0 --backup-file=/tmp/grow
--raid-devices=3 --add /dev/sdd   <= changes to raid4
  mdadm --detail /dev/md0
  mdadm --grow /dev/md0 --level=0 --backup-file=/tmp/grow  <== changes to raid0
  mdadm --detail /dev/md0

Can someone please confirm this correct and that raid0 can be
expanded, or is there a better means to expand an raid0 raid set?

Thanks!
