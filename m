From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm 3.2.1: Segfaulting with -p
Date: Tue, 5 Apr 2011 09:18:06 +1000
Message-ID: <20110405091806.52ff3111@notabene.brown>
References: <747613.94276.qm@web130110.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <747613.94276.qm@web130110.mail.mud.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Eugene <hdejin@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 2 Apr 2011 05:28:43 -0700 (PDT) Eugene <hdejin@yahoo.com> wrote:

> /sbin/mdadm -F --scan -1 -p /etc/mdcheck.sh causes a segfault
> with 3.2.1
> 
> Tested on 2.6.38.2 32-bit kernel.
> 
> GDB backtrace
> Program terminated with signal 11, Segmentation fault.
> #0  0xb77dba01 in __strncmp_ia32 () from /lib/libc.so.6
> (gdb) bt
> #0  0xb77dba01 in __strncmp_ia32 () from /lib/libc.so.6
> #1  0x0806d603 in add_new_arrays (mdstat=0x80c8198, statelist=0xbf862cbc, test=0, info=0xbf862cac) at Monitor.c:691
> #2  0x0806c189 in Monitor (devlist=0x0, mailaddr=0x0, alert_cmd=0xbf864cc8 "/etc/mdcheck.sh", period=1000, daemonise=0, scan=1, oneshot=1,
>     dosyslog=0, test=0, pidfile=0x0, increments=20, share=1) at Monitor.c:228
> #3  0x0804e275 in main (argc=6, argv=0xbf8632c4) at mdadm.c:1596
> 
> Monitor.c line 691 is doing strncmp on a NULL pointer
> if (strncmp(mse->metadata_version, "external:", 9) == 0 &&
>                             is_subarray(mse->metadata_version+9))
>                                 st->parent_dev =
> 
>

Hi Eugene,
 thanks for the report.

 The following patch will be in my git tree
    git://neil.brown.name/mdadm master
 shortly and should fix the problem.

Thanks,
NeilBrown

commit eb28e119b03fd5149886ed516fa4bb006ad3602e
Author: NeilBrown <neilb@suse.de>
Date:   Tue Apr 5 09:16:57 2011 +1000

    Monitor: avoid NULL dereference with 0.90 metadata
    
    0.90 array do not report the metadata type in /proc/mdstat, so
    we cannot assume that mse->metadata_version is non-NULL.
    
    So add an appropriate check.
    
    Reported-by: Eugene <hdejin@yahoo.com>
    Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/Monitor.c b/Monitor.c
index 291e465..337785d 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -688,7 +688,8 @@ static int add_new_arrays(struct mdstat_ent *mdstat, struct state **statelist,
 			st->devnum = mse->devnum;
 			st->percent = -2;
 			st->expected_spares = -1;
-			if (strncmp(mse->metadata_version, "external:", 9) == 0 &&
+			if (mse->metadata_version &&
+			    strncmp(mse->metadata_version, "external:", 9) == 0 &&
 			    is_subarray(mse->metadata_version+9))
 				st->parent_dev =
 					devname2devnum(mse->metadata_version+10);
