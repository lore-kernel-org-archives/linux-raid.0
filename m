From: Mike Accetta <maccetta@laurelnetworks.com>
Subject: Re: Partitioned arrays initially missing from /proc/partitions
Date: Mon, 23 Apr 2007 15:31:47 -0400
Message-ID: <16046.1177356707@mdt.dhcp.pit.laurelnetworks.com>
References: <462CC91B.8030008@dgreaves.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: Your message of "Mon, 23 Apr 2007 15:56:27 BST."
             <462CC91B.8030008@dgreaves.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

David Greaves writes:

...
> It looks like the same (?) problem as Mike (see below - Mike do you have a
> patch?) but I'm on 2.6.20.7 with mdadm v2.5.6
...

We have since started assembling the array from the initrd using
--homehost and --auto-update-homehost which takes a different path through
the code, and in this path the kernel figures out there are partitions
on the array before mdadm exists.

For the previous code path, we had been ruuning with the patch I described
in my original post which I've included below.  I'd guess that the bug
is actually in the kernel code and I looked at it briefly but couldn't
figure out how things all fit together well enough to come up with a
patch there.  The user level patch is a bit of a hack and there may be
other code paths that also need a similar patch.  I only made this patch
in the assembly code path we were executing at the time.

==== BUILD/mdadm/mdadm.c#2 (text) - BUILD/mdadm/mdadm.c#3 (text) ==== content
@@ -983,6 +983,10 @@
                                                               NULL,
                                                               readonly, runstop, NULL, verbose-quiet, force);
                                        close(mdfd);
+                                       mdfd = open(array_list->devname, O_RDONLY); 
+                                       if (mdfd >= 0) {
+                                           close(mdfd);
+                                       }
                                }
                }
                break;
--
Mike Accetta

ECI Telecom Ltd.
Data Networking Division (previously Laurel Networks)
