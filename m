From: Niccolo Rigacci <niccolo@texnet.it>
Subject: Re: Forcing a more random uuid (random seed bug)
Date: Wed, 2 Feb 2005 14:33:41 +0100
Message-ID: <200502021433.42108.niccolo@texnet.it>
References: <200502011847.39444.niccolo@texnet.it>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
In-Reply-To: <200502011847.39444.niccolo@texnet.it>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> I get /dev/md5, /dev/md6, /dev/md7
> and /dev/md8 all with the same UUID!

It seems that there is a bug in mdadm: when generating the UUID for a 
volume, the random() function is called, but the random sequence is never 
initialized.

The result is that every volume created with mdadm has an uuid of:
6b8b4567:327b23c6:643c9869:66334873

See also Debian bug 292784 at
http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=292784

I fixed the problem adding the following patch to mdadm.c, but please bear 
in mind that I'm totally unaware of mdadm code and quite naive in C 
programming:

$ diff -u mdadm.c.orig mdadm.c
--- mdadm.c.orig        2004-11-02 06:11:06.000000000 +0100
+++ mdadm.c     2005-02-02 14:27:55.000000000 +0100
@@ -86,6 +86,15 @@
        ident.super_minor= UnSet;
        ident.devices=0;

+        int my_fd;
+        unsigned int my_seed;
+        if ((my_fd = open("/dev/random", O_RDONLY)) != -1) {
+            if (read(my_fd, &my_seed, sizeof(my_seed)) == sizeof(my_seed)) 
{
+                srandom(my_seed);
+            }
+            close(my_fd);
+        }
+
        while ((option_index = -1) ,
               (opt=getopt_long(argc, argv,
                                short_options, long_options,




-- 
Niccolo Rigacci
http://www.texnet.it/
