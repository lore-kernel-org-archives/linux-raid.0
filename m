From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Bitmap did not survive reboot
Date: Sat, 14 Nov 2009 15:48:21 -0600
Message-ID: <20091114214824046.GOED3390@cdptpa-omta03.mail.rr.com>
References: <4AFB9B92.505@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AFB9B92.505@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'Doug Ledford' <dledford@redhat.com>
Cc: 'Linux RAID Mailing List' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> dbench -t 300 -D $mpoint --clients-per-process=4 16 | tail -19 >>
> $log_file
> mkdir $mpoint/bonnie
> chown nobody.nobody $mpoint/bonnie
> bonnie++ -u nobody:nobody -d $mpoint/bonnie -f -m
> RAID${lvl}-${num}Disk-${chunk}k -n 64:65536:1024:16 >>$log_file
> 2>/dev/null
> tiotest -f 1024 -t 6 -r 1000 -d $mpoint -b 4096 >> $log_file
> tiotest -f 1024 -t 6 -r 1000 -d $mpoint -b 16384 >> $log_file
> 
> Obviously, I pulled these tests out of a script I use where all these
> various variables are defined.  Just replace the variables with
> something sensible for accessing your array, run them, save off the
> results, run again with a different chunk size, then please post the
> results back here as I imagine they would be very informative.
> Especially the dbench results as I think they are likely to benefit the
> most from the change.  Note: dbench, bonnie++, and tiotest should all be
> available in the debian repos.

	I could not find tiotest.  Also, the version dbench in the distro
does not support the --clients-per-process switch.  I'll post the results
from the backup system here, and from the primary system in the next post.

Backup with bitmap-chunk 65M:

  16    363285   109.22 MB/sec  execute 286 sec
  16    364067   109.05 MB/sec  execute 287 sec
  16    365960   109.26 MB/sec  execute 288 sec
  16    366880   109.13 MB/sec  execute 289 sec
  16    368850   109.35 MB/sec  execute 290 sec
  16    370444   109.45 MB/sec  execute 291 sec
  16    372360   109.64 MB/sec  execute 292 sec
  16    373973   109.74 MB/sec  execute 293 sec
  16    374821   109.61 MB/sec  execute 294 sec
  16    376967   109.88 MB/sec  execute 295 sec
  16    377813   109.77 MB/sec  execute 296 sec
  16    379422   109.87 MB/sec  execute 297 sec
  16    381197   110.05 MB/sec  execute 298 sec
  16    382029   109.92 MB/sec  execute 299 sec
  16    383868   110.10 MB/sec  cleanup 300 sec
  16    383868   109.74 MB/sec  cleanup 301 sec
  16    383868   109.37 MB/sec  cleanup 302 sec

Throughput 110.101 MB/sec 16 procs
Version 1.03d       ------Sequential Output------ --Sequential Input-
--Random-
                    -Per Chr- --Block-- -Rewrite- -Per Chr- --Block--
--Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec
%CP
RAID5-7Disk-6 3520M           66779  23 46588  22           127821  29 334.7
2
                    ------Sequential Create------ --------Random
Create--------
                    -Create-- --Read--- -Delete-- -Create-- --Read---
-Delete--
files:max:min        /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec
%CP
   64:65536:1024/16    35   1   113   2   404   9    36   1    54   1   193
5


Backup with default (2048K) bitmap-chunk


  16    306080    91.68 MB/sec  execute 286 sec
  16    307214    91.69 MB/sec  execute 287 sec
  16    307922    91.61 MB/sec  execute 288 sec
  16    308828    91.53 MB/sec  execute 289 sec
  16    310653    91.78 MB/sec  execute 290 sec
  16    311926    91.82 MB/sec  execute 291 sec
  16    313569    92.01 MB/sec  execute 292 sec
  16    314478    91.96 MB/sec  execute 293 sec
  16    315578    91.99 MB/sec  execute 294 sec
  16    317416    92.18 MB/sec  execute 295 sec
  16    318576    92.25 MB/sec  execute 296 sec
  16    320391    92.39 MB/sec  execute 297 sec
  16    321309    92.40 MB/sec  execute 298 sec
  16    322461    92.42 MB/sec  execute 299 sec
  16    324486    92.70 MB/sec  cleanup 300 sec
  16    324486    92.39 MB/sec  cleanup 301 sec
  16    324486    92.17 MB/sec  cleanup 302 sec

Throughput 92.6969 MB/sec 16 procs
Version 1.03d       ------Sequential Output------ --Sequential Input-
--Random-
                    -Per Chr- --Block-- -Rewrite- -Per Chr- --Block--
--Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec
%CP
RAID5-7Disk-2 3520M           38751  14 31738  15           114481  28 279.0
1
                    ------Sequential Create------ --------Random
Create--------
                    -Create-- --Read--- -Delete-- -Create-- --Read---
-Delete--
files:max:min        /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec
%CP
   64:65536:1024/16    30   1   104   2   340   8    30   1    64   1   160
4

