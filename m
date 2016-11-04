From: Marc MERLIN <marc@merlins.org>
Subject: Re: clearing blocks wrongfully marked as bad if --update=no-bbl
 can't be used?
Date: Fri, 4 Nov 2016 11:50:40 -0700
Message-ID: <20161104185040.yrznk3j4rvtwsxbk@merlins.org>
References: <20161030170242.GA5724@metamorpher.de>
 <20161030021614.asws67j34ji64qle@merlins.org>
 <20161030093337.GA3627@metamorpher.de>
 <20161030153857.GB28648@merlins.org>
 <20161030161929.GA5582@metamorpher.de>
 <f6b83548-cb8b-be21-ee4f-cae9f7fa2950@turmel.org>
 <20161030171234.GD28648@merlins.org>
 <20161030171654.GE28648@merlins.org>
 <20161104181808.lplrtmafwlub3ck4@merlins.org>
 <90cf5c8f-fcd3-d510-7f6e-6be6ade3969f@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <90cf5c8f-fcd3-d510-7f6e-6be6ade3969f@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Neil Brown <neilb@suse.de>, Andreas Klauer <Andreas.Klauer@metamorpher.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Nov 04, 2016 at 02:22:48PM -0400, Phil Turmel wrote:
> On 11/04/2016 02:18 PM, Marc MERLIN wrote:
> 
> > Right, so I thought I was home free, but not even close. My array is
> > back up, the badblock feature is disabled, array reports clean, but I
> > cannot access data past 8.8TB, it just fails.
> > 
> > myth:~# dd if=/dev/md5 of=/dev/null bs=1GB skip=8797
> > dd: reading `/dev/md5': Invalid argument
> > 0+0 records in
> > 0+0 records out
> > 0 bytes (0 B) copied, 0.000403171 s, 0.0 kB/s
> > myth:~# dd if=/dev/md5 of=/dev/null bs=1GB skip=8796
> > dd: reading `/dev/md5': Invalid argument
> > 1+0 records in
> > 1+0 records out
> > 1000000000 bytes (1.0 GB) copied, 10.5817 s, 94.5 MB/s
> 
> That has nothing to do with MD.  You are using a power of ten suffix in
> your block size, so you are running into non-aligned sector locations.

not really, I read the whole device from scratch (without skip) and it
read 8.8TB before it failed. It just takes 2 days to run, so it's a bit
annoying to do repeatedly :)

myth:/dev# dd if=/dev/md5 of=/dev/null bs=1GB skip=8790
dd: reading `/dev/md5': Invalid argument
7+0 records in
7+0 records out
7000000000 bytes (7.0 GB) copied, 76.7736 s, 91.2 MB/s

It doesn't matter where I start, it fails exactly in the same place, and
I can't skip over it, anything after that mark is unreadable.

I can switch to GiB if you'd like, same thing:
myth:/dev# dd if=/dev/md5 of=/dev/null bs=1GiB skip=8190
dd: reading `/dev/md5': Invalid argument
2+0 records in
2+0 records out
2147483648 bytes (2.1 GB) copied, 21.9751 s, 97.7 MB/s
myth:/dev# dd if=/dev/md5 of=/dev/null bs=1GiB skip=8200
dd: reading `/dev/md5': Invalid argument
0+0 records in
0+0 records out
0 bytes (0 B) copied, 0.000281885 s, 0.0 kB/s
myth:/dev# dd if=/dev/md5 of=/dev/null bs=1GiB skip=8500
dd: reading `/dev/md5': Invalid argument
0+0 records in
0+0 records out
0 bytes (0 B) copied, 0.000395691 s, 0.0 kB/s

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
