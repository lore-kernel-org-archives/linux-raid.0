From: Richard Michael <rmichael-raid@edgeofthenet.org>
Subject: Re: Why can't I stop these arrays? PATCH
Date: Sun, 22 Jun 2008 20:46:13 -0400
Message-ID: <20080623004613.GA6189@nexus.edgeofthenet.org>
References: <20080622223517.GD5474@nexus.edgeofthenet.org> <485ED8F9.70203@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <485ED8F9.70203@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roger Heflin <rogerheflin@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>> Any advice?  Probably I've missed something obvious..

Yes, of course I did. :)  (To other poster, I checked lsof immediately.)

> Do they have volume groups on them?

Yes, I do.  I should know, since I created them.  I've been fooling
around all day with lvm, but somehow completely forget it would keep the
array active..

> I would "vgdisplay" and if they show up in there they will need to be 
> turned off there before they can be unmounted (vgchange -a y device).

I'm fairly certain here you mean: "vgchange -a n <vg_name>".

Thanks Roger!

Since this has come up on the mailing before, is there any interest in
this trivial one liner?  (Perhaps it needs to go elsewhere in the code
as well.)

diff -u -r mdadm-2.6.7/Manage.c mdadm-2.6.7-local/Manage.c
--- mdadm-2.6.7/Manage.c        2008-06-05 22:11:04.000000000 -0400
+++ mdadm-2.6.7-local/Manage.c  2008-06-22 20:35:25.000000000 -0400
@@ -115,6 +115,7 @@
                        if (quiet==0)
                                fprintf(stderr, Name ": fail to stop array %s: %s\n",
                                        devname, strerror(errno));
+                               fprintf(stderr, "Perhaps a running process, mounted filesystem or active volume group?\n");
                        return 1;
                }
                if (quiet <= 0)


Regards,
Richard
