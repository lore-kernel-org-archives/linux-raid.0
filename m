From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: [PATCH] mdadm: do not read the 'clean' flag from potentially
 non-up-to-date drive
Date: Fri, 6 Apr 2012 15:24:22 +0300
Message-ID: <CAGRgLy5=xP3ZJz71j2qYiCFLFFD6uCH0O92p3Ev2s2GnonRc8A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>, NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

Hi Neil,

I noticed that mdadm may decide that array is dirty, based on the
non-freshest drive. This happens, e.g., when there is a drive failure
during initial resync, and then array is stopped and re-assembled. The
failed drive still has a valid sb->resync_offset, so if this drive is
visible during assembly, array will be considered dirty, even though
the rest of the drives have sb->resync_offset==MaxSector.

Do you think array should be considered as dirty in this case? Because
if the failed drive was not visible during assembly, array would have
been considered clean.

The below patch is only to demonstrate the possible fix. The idea is
that we decide that array is dirty only according to up-to-date
drives. Currently the "clean" flag is initialized from the first
superblock, which might not be the freshest one.

I haven't tested it at all. If you think the direction is reasonable,
I will test.

Thanks,
  Alex.


diff --git a/Assemble.c b/Assemble.c
index 23695e7..42cbbd5 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -929,7 +929,6 @@ int Assemble(struct supertype *st, char *mddev,
                st->minor_version = 90;

        st->ss->getinfo_super(st, content, NULL);
-       clean = content->array.state & 1;

        /* now we have some devices that might be suitable.
         * I wonder how many
@@ -1122,6 +1121,7 @@ int Assemble(struct supertype *st, char *mddev,
 #ifndef MDASSEMBLE
        sysfs_init(content, mdfd, 0);
 #endif
+       clean = 1; /* Assume that array is clean, until we see otherwise */
        for (i=0; i<bestcnt; i++) {
                int j = best[i];
                unsigned int desired_state;
