From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Converting a regular (non-RAID) HD into a (degraded) RAID 1
 installation in-place
Date: Wed, 10 Apr 2013 07:20:01 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1304100713520.23668@uplift.swm.pp.se>
References: <CAOtrxKNxLDDOkD-9A-1fxPO-SGH97ZBMWt0aG5Eej7osx73LnA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-137064504-1902154990-1365570917=:23668"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAOtrxKNxLDDOkD-9A-1fxPO-SGH97ZBMWt0aG5Eej7osx73LnA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-15?Q?Rog=E9rio_Brito?= <rbrito@ime.usp.br>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---137064504-1902154990-1365570917=:23668
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-15; FORMAT=flowed
Content-Transfer-Encoding: 8BIT

On Tue, 9 Apr 2013, Rogério Brito wrote:

> I would like to understand better this situation and I can provide all 
> the details (commands) that I tried so far.

My recommendation would be to choose a metadatatype that stores the 
metadata at the end of the partition, and before this you shrink your ext4 
fs by 100 megabyte or alike, and then after you see this correctly through 
the md device, you resize it again to "max".

You didn't state if you needed partitions here, but I would imagine not.

So let's say you have sdb1 with ext4 fs. Shrink fs on sdb1 by 100 
megabyte. mdadm --create md0 raid1 on sdb1 with metadata v1.0, then you 
can most likely mount ext4 properly on md0, and after this you can resize 
the fs to max size. Now you have md0 on sdb1 and one missing, then you can 
add sdc1 to this to have a fully functioning raid1 setup.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
---137064504-1902154990-1365570917=:23668--
