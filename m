From: Marc MERLIN <marc@merlins.org>
Subject: Re: clearing blocks wrongfully marked as bad if --update=no-bbl
 can't be used?
Date: Fri, 4 Nov 2016 13:02:27 -0700
Message-ID: <20161104200226.dldmcwgqnopuuqet@merlins.org>
References: <20161030153857.GB28648@merlins.org>
 <20161030161929.GA5582@metamorpher.de>
 <f6b83548-cb8b-be21-ee4f-cae9f7fa2950@turmel.org>
 <20161030171234.GD28648@merlins.org>
 <20161030171654.GE28648@merlins.org>
 <20161104181808.lplrtmafwlub3ck4@merlins.org>
 <90cf5c8f-fcd3-d510-7f6e-6be6ade3969f@turmel.org>
 <20161104185040.yrznk3j4rvtwsxbk@merlins.org>
 <20161104235917.2d6d0fcc@natsu>
 <20161105003109.25964c52@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161105003109.25964c52@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.net>
Cc: Phil Turmel <philip@turmel.org>, Neil Brown <neilb@suse.de>, Andreas Klauer <Andreas.Klauer@metamorpher.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Nov 05, 2016 at 12:31:09AM +0500, Roman Mamedov wrote:
> Also check that member devices of /dev/md5 (/dev/sd*1 partitions) are still
> larger than 2TB, and are still readable past 2TB.

Just for my own sanity: if the drives had rear errors, those would be
logged by the kernel, right?
I did run hdrecover on all those drives and it completed on all of them
(I did that first before checking anything else)

Here's me reading 1GB from each drive at the 3.5TB mark:
myth:/sys/block/md5/md# for i in /dev/sd[defgh]; do dd if=$i of=/dev/null bs=1GiB skip=3500 count=1; done
1+0 records in
1+0 records out
1073741824 bytes (1.1 GB) copied, 77.4343 s, 13.9 MB/s
1+0 records in
1+0 records out
1073741824 bytes (1.1 GB) copied, 50.1179 s, 21.4 MB/s
1+0 records in
1+0 records out
1073741824 bytes (1.1 GB) copied, 39.6499 s, 27.1 MB/s
1+0 records in
1+0 records out
1073741824 bytes (1.1 GB) copied, 71.6397 s, 15.0 MB/s
1+0 records in
1+0 records out
1073741824 bytes (1.1 GB) copied, 73.1003 s, 14.7 MB/s

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
