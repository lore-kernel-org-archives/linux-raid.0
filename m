From: "Duncan, Mike" <Mike.Duncan@Sonopress.com>
Subject: RE: MD/RAID1 Large File Support
Date: Wed, 14 May 2003 15:55:41 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <EC803175C921D411BCE2000000006429081C3645@ash-exch_lg>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
To: 'Bernd Schubert' <bernd-schubert@web.de>
Cc: "'linux-raid@vger.kernel.org'" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This makes sense, because I upgraded (not reinstalled) my SuSE 7.3 -> 8.0
when running tests. 7.3 comes with the old driver and formatted the drive
with 3.5.x format. On my other box, the one that the tests worked out
correctly on, I am running ReiserFS v3.6.25 format.

Thanks for pointing that out to me. It been really helpful.

------------------------------------ 
Mike Duncan
Web Master/Developer
Sonopress LLC

mike.duncan@sonopress.com
828.658.6082 (desk)
828.423.3310 (cell)
------------------------------------


-----Original Message-----
From: Bernd Schubert [mailto:bernd-schubert@web.de] 
Sent: Wednesday, May 14, 2003 1:46 PM
To: Duncan, Mike; 'linux-raid@vger.kernel.org'
Subject: Re: MD/RAID1 Large File Support


> trans len 1024, max batch 900, max commit age 30, max trans age 30
> reiserfs: checking transaction log (md0) for (md0)
> Using r5 hash to sort names
> reiserfs: using 3.5.x disk format
                 ^^^^^^^^^^^^^^^^^^^^

Hi,

there is no 2GB support with reiserfs-3.5. You have used Suses default 
reiserfs-utils, didn't you ? Well, the tools from namesys.com have 3.6 as 
default since ages, the tools by patched by Suse do have 3.5 .

Try to convert with '-o conv' on mounting. If you plan to export this 
partition by nfs, you should consider to reformat, since the old files are 
not updated by -oconv, only new files will be in 3.6 format.

Bernd
