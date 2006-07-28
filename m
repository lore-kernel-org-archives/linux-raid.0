From: Sander Smeenk <ssmeenk@freshdot.net>
Subject: Re: Weird blocks at fsync() calls using md
Date: Fri, 28 Jul 2006 13:47:04 +0200
Message-ID: <20060728114704.GA2241@freshdot.net>
References: <20060728101645.GA32686@freshdot.net> <17609.61671.113267.692986@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <17609.61671.113267.692986@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Quoting Neil Brown (neilb@suse.de):

> Precisely what evidence do you have?

I had a nicer strace. With the 30 seconds fsync() call in it. This one
only took 4 seconds, but that's because only two of us were trying to
generate enough disk IO to make it happen ;)

Look here, the read(0, "\r", 250) = 1 is the moment i hit <CR> on the :w
command to vim.

13:28:06.183890 open(".js_gen.pl.swp", O_RDWR|O_CREAT|O_EXCL, 0600) = 4

[..]

13:28:07.006968 select(1, [0], NULL, [0], NULL) = 1 (in [0])
13:28:07.007535 read(0, "\r", 250)      = 1
13:28:07.007585 select(1, [0], NULL, [0], {0, 0}) = 0 (Timeout)
13:28:07.007634 write(1, "\r", 1)       = 1
13:28:07.007772 getcwd("/raid/web/invoer/prices", 1024) = 24
13:28:07.007834 select(1, [0], NULL, [0], {0, 0}) = 0 (Timeout)
13:28:07.007902 write(1, "\33[?25l\"js_gen.pl\" ", 18) = 18
13:28:07.007968 stat("js_gen.pl", {st_mode=S_IFREG|0770, st_size=2189, ...}) = 0
13:28:07.008031 access("js_gen.pl", W_OK) = 0
13:28:07.008083 lstat("js_gen.pl", {st_mode=S_IFREG|0770, st_size=2189, ...}) = 0
13:28:07.008142 lstat("4913", 0x7fff2f8b1330) = -1 ENOENT (No such file or directory)
13:28:07.008183 open("4913", O_WRONLY|O_CREAT|O_EXCL, 0100770) = 3
13:28:07.008271 fchown(3, 1001, 33)     = -1 EPERM (Operation not permitted)
13:28:07.008305 stat("4913", {st_mode=S_IFREG|0700, st_size=0, ...}) = 0
13:28:07.009368 close(3)                = 0
13:28:07.009420 unlink("4913")          = 0
13:28:07.009483 open("js_gen.pl", O_RDONLY) = 3
13:28:07.009536 stat("js_gen.pl~", 0x7fff2f8b12a0) = -1 ENOENT (No such file or directory)
13:28:07.009575 unlink("js_gen.pl~")    = -1 ENOENT (No such file or directory)
13:28:07.009609 open("js_gen.pl~", O_WRONLY|O_CREAT|O_EXCL, 0770) = 5
13:28:07.009657 chmod("js_gen.pl~", 0770) = 0
13:28:07.009695 fchown(5, 4294967295, 33) = 0
13:28:07.009727 read(3, "#!/usr/bin/perl -w\nuse strict;\nu"..., 8192) = 2189
13:28:07.009772 write(5, "#!/usr/bin/perl -w\nuse strict;\nu"..., 2189) = 2189
13:28:07.009856 select(1, [0], NULL, [0], {0, 0}) = 0 (Timeout)
13:28:07.009908 read(3, "", 8192)       = 0
13:28:07.009960 close(5)                = 0
13:28:07.010709 utime("js_gen.pl~", [2006/07/28-13:28:06, 2006/07/28-13:27:50]) = 0
13:28:07.010764 close(3)                = 0
13:28:07.010809 lseek(4, 4096, SEEK_SET) = 4096
13:28:07.010859 write(4, "tp\1\0\177\0\0\0\2\0\0\0\0\0\0\0L\0\0\0\0\0\0\0\1\0\0\0"..., 4096) = 4096
13:28:07.010925 lseek(4, 8192, SEEK_SET) = 8192
13:28:07.011598 write(4, "ad\0\0$\6\0\0p\7\0\0\0\20\0\0L\0\0\0\0\0\0\0\355\17\0\0"..., 4096) = 4096
13:28:07.011671 select(1, [0], NULL, [0], {0, 0}) = 0 (Timeout)
*********
13:28:07.011717 fsync(4)                = 0
13:28:12.748252 open("js_gen.pl", O_WRONLY|O_CREAT|O_TRUNC, 0770) = 3
*********
13:28:12.748427 write(3, "#!/usr/bin/perl -w\nuse strict;\nu"..., 2189) = 2189
13:28:12.748506 fsync(3)                = 0
13:28:13.006702 close(3)                = 0
13:28:13.006759 chmod("js_gen.pl", 0100770) = -1 EPERM (Operation not permitted)
13:28:13.006852 write(1, "\r\"js_gen.pl\" [converted] 76L, 21"..., 43) = 43
13:28:13.006917 stat("/raid/web/invoer/prices/js_gen.pl", {st_mode=S_IFREG|0770, st_size=2189, ...}) = 0
13:28:13.007646 unlink("js_gen.pl~")    = 0

I'll see if i can pull an ltrace out of vim too.

-- 
| He had a photographic memory which was never developed.  
| 1024D/08CEC94D - 34B3 3314 B146 E13C 70C8  9BDB D463 7E41 08CE C94D
