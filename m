From: <lilha@legend.com.cn>
Subject: Re: some question in SoftRaid
Date: Fri, 24 May 2002 10:40:56 +0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <OFFD9E56CF.EF1F1E2A-ON48256BC3.000D7788@legend.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
To: danci@agenda.si
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Thanks a lot.
i have setup raid0 and raid1 in the same disk and
i also create a RAID1 array with two different partition sizes, the
resultin array is the size of the
smaller partition.(it don't care the order. )

but how to use raidhotremove combination or the new mdadm?
i try it:
#raidstop /dev/md3
#raidhotremove /dev/md3
No target disk specified!

is there any doc about how to remove raid?
and what is the new mdadm?

thank very much!

Regards, Echo



