From: Bernd Schubert <bernd-schubert@web.de>
Subject: Re: MD/RAID1 Large File Support
Date: Wed, 14 May 2003 19:45:46 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200305141945.46988.bernd-schubert@web.de>
References: <EC803175C921D411BCE2000000006429081C363F@ash-exch_lg>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <EC803175C921D411BCE2000000006429081C363F@ash-exch_lg>
Content-Disposition: inline
To: "Duncan, Mike" <Mike.Duncan@sonopress.com>, "'linux-raid@vger.kernel.org'" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

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
