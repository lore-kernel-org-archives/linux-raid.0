From: "3tcdgwg3" <3tcdgwg3@prodigy.net>
Subject: Software RAID level performance
Date: Thu, 6 Nov 2003 23:29:39 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <001d01c3a500$e99bf100$bb601e43@neptune>
References: <C587FF391BCAD411B8120008C7864670057DA5B8@mtvxch07.veritas.com> <1054403067.14818.280.camel@testlin.hades> <3ED7B898.4409555F@SteelEye.com> <01f101c326e7$c9084890$7b07a8c0@pluto> <3ED7BF97.BAB11B12@SteelEye.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Cc: 'Linux raid mailing list' <linux-raid@vger.kernel.org>, Paul Clements <Paul.Clements@SteelEye.com>
List-Id: linux-raid.ids

Hello,

I have a question regarding the RAID1 performance.

I tought the RAID1 will access disk in a con-current way, but
today I installed a 2.4-18 (Redhat 9.0). Seems RAID1 code
is not doing the disk access in a balanced way? I see single disk
is faster the RAID1.  
First,  do dd, read from /dev/zero write to disk, 
then  dd again,  read from disk write write to /dev/null,
in both cases, single disk out run 2 disk RAID1.

Any one can help me to understand this?

Thank you so much.

