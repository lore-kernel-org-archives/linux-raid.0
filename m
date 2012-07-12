From: Jacek Danecki <Jacek.Danecki-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [mdadm PATCH] bcache: add bcache superblock
Date: Thu, 12 Jul 2012 17:03:50 +0200
Message-ID: <4FFEE756.1070901@intel.com>
References: <20120511203835.26301.1937.stgit@dwillia2-linux.jf.intel.com> <alpine.LNX.2.01.1205150042200.12473@stax.localdomain> <CABE8wwu_TXJckRXg1eSny8TnciJ6GOM_Vy7FNW1FX84YT6QZzQ@mail.gmail.com> <alpine.LNX.2.01.1205152200500.13405@stax.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LNX.2.01.1205152200500.13405-4jfXtw+jRJ582hYKe6nXyg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Hills <mark-UrrBsZIrrsb10XsdtD+oqA@public.gmane.org>
Cc: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, neilb-l3A5Bk7waGM@public.gmane.org, koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-raid.ids

On 05/15/12 23:16, Mark Hills wrote:
> Presumably there's a little more too this, as I can't even investigate the
> UIDs in use:
>
>    # make-bcache -C /dev/sdb
>    [...]
>    # make-bcache -B /dev/sdc
>    [...]
>    # mdadm -E /dev/sd[bc]
>    /dev/sdb:
>       MBR Magic : aa55
>    /dev/sdc:
>       MBR Magic : aa55
>
> I confirmed that I'm using the patched mdadm, but it still doesn't seem to
> recognise the magic.

As I can see the problem could be in mdadm which can recognize mbr superblock
if partition table exists on disk, and then uses load_super_mbr() instead of load_bcache().
You can look at guess_super_type() function in util.c file. See log below.
I've attached small patch, which I used to find out where issue is.
Btw, I've not idea why getinfo_super() for imsm and bcache set info.array.ctime always to 0.
Probably it should be fixed also because this value is used by guess_super_type() function.

		rv = ss->load_super(st, fd, NULL);
		if (rv == 0) {
			struct mdinfo info;
			st->ss->getinfo_super(st, &info, NULL);
			if (bestsuper == -1 ||
			    besttime < info.array.ctime) {
				bestsuper = i;
				besttime = info.array.ctime;
			}
			ss->free_super(st);
		}


  ./mdadm -E /dev/sdb
check 0.90 0x685a60
load super
check 1.x 0x685be0
load super
check ddf 0x686060
load super
check imsm 0x686240
load super
check mbr 0x686400
load super
getinfo_super for mbr bestsuper=-1
set bestsuper to 4
check gpt 0x686580
load super
check bcache 0x686700
load super
load_cache_sb
getinfo_super for bcache bestsuper=4
load super again: mbr 0x45a3c1
load_super: 0x686400 mbr 0x45a3c1
/dev/sdb: 0x686400 mbr 0x45a3c1
    MBR Magic : aa55

To workaround this issue I've destroyed partition table on /dev/sdb,
and now mdadm can examine bcache superblock correctly.

./mdadm -E /dev/sdb
check 0.90 0x685a60
load super
check 1.x 0x685be0
load super
check ddf 0x686060
load super
check imsm 0x686240
load super
check mbr 0x686400
load super
check gpt 0x686580
load super
check bcache 0x686700
load super
load_cache_sb
getinfo_super for bcache bestsuper=-1
set bestsuper to 6
load super again: bcache 0x45bb6b
load_cache_sb
load_super: 0x686700 bcache 0x45bb6b
load_cache_sb
/dev/sdb: 0x686700 bcache 0x45bb6b
        Magic : <bcache>
      Version : 0
         Role : cache
     Set UUID : 1eefbc0e:e4405d53:e6c630a7:83b523c0
   Cache Devs : 1
  Device UUID : 4a9e3223:cb403537:b05209b0:26948206
        Flags :
       Policy : lru
        Label :
  Device Size : 234439680 (111.79 GiB 120.03 GB)
  Bucket Size : 1024
  Num Buckets : 228946
     this dev : 0
First Bucket : 1
     Checksum : 6730f38d517c4db2 correct


diff --git a/Examine.c b/Examine.c
index 5d71e53..5173f4a 100644
--- a/Examine.c
+++ b/Examine.c
@@ -88,10 +88,12 @@ int Examine(struct mddev_dev *devlist, int brief, int export, int scan,
                         if (st) {
                                 err = 1;
                                 st->ignore_hw_compat = 1;
-                               if (!container)
+                               if (!container) {
+                                       printf("load_super: %p %s %p\n", st->ss, st->ss->name, st->ss->load_super);
                                         err = st->ss->load_super(st, fd,
                                                                  (brief||scan) ? NULL
                                                                  :devlist->devname);
+                               }
                                 if (err && st->ss->load_container) {
                                         err = st->ss->load_container(st, fd,
                                                                  (brief||scan) ? NULL
@@ -149,7 +151,7 @@ int Examine(struct mddev_dev *devlist, int brief, int export, int scan,
                                 st->ss->export_examine_super(st);
                         st->ss->free_super(st);
                 } else {
-                       printf("%s:\n",devlist->devname);
+                       printf("%s: %p %s %p\n",devlist->devname, st->ss, st->ss->name, st->ss->load_super);
                         st->ss->examine_super(st, homehost);
                         st->ss->free_super(st);
                 }
diff --git a/super-bcache.c b/super-bcache.c
index ec8f3db..ebee248 100644
--- a/super-bcache.c
+++ b/super-bcache.c
@@ -72,6 +72,7 @@ static int load_cache_sb(struct bcache_super *super, int keep_fd)
         if (memcmp(c->magic, bcache_magic, sizeof(bcache_magic)) != 0)
                 return ENODEV;

+       printf("load_cache_sb\n");
         return 0;
  }

diff --git a/util.c b/util.c
index d9e49cf..5aaa986 100644
--- a/util.c
+++ b/util.c
@@ -1043,19 +1043,23 @@ struct supertype *guess_super_type(int fd, enum guess_types guess_type)
         for (i=0 ; superlist[i]; i++) {
                 int rv;
                 ss = superlist[i];
+               printf("check %s %p\n", ss->name, ss);
                 if (guess_type == guess_array && ss->add_to_super == NULL)
                         continue;
                 if (guess_type == guess_partitions && ss->add_to_super != NULL)
                         continue;
                 memset(st, 0, sizeof(*st));
                 st->ignore_hw_compat = 1;
+               printf("load super\n");
                 rv = ss->load_super(st, fd, NULL);
                 if (rv == 0) {
                         struct mdinfo info;
+                       printf("getinfo_super for %s bestsuper=%d\n", st->ss->name, bestsuper);
                         st->ss->getinfo_super(st, &info, NULL);
                         if (bestsuper == -1 ||
                             besttime < info.array.ctime) {
                                 bestsuper = i;
+                               printf("set bestsuper to %d\n", i);
                                 besttime = info.array.ctime;
                         }
                         ss->free_super(st);
@@ -1065,6 +1069,7 @@ struct supertype *guess_super_type(int fd, enum guess_types guess_type)
                 int rv;
                 memset(st, 0, sizeof(*st));
                 st->ignore_hw_compat = 1;
+               printf("load super again: %s %p\n", superlist[bestsuper]->name, superlist[bestsuper]->load_super);
                 rv = superlist[bestsuper]->load_super(st, fd, NULL);
                 if (rv == 0) {
                         superlist[bestsuper]->free_super(st);
-- 
Jacek
