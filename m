From: Matthew Elvey <matthew@elvey.com>
Subject: Solution: Re: (Can I mark a RAID 1 drive as old?   Move it? SCA hangs)
  Troubles   creating a reliable backup system.
Date: Tue, 10 Aug 2004 18:49:24 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <41197B24.8000002@elvey.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Thu, 08 Jul 2004 14:42:13 -0700, "Matthew (RAID)"
<RAID@lists.elvey.com> said:
> I think I want to [...] move arrays around...
> 
...
> I've been using raidtools, as that's what all the HOWTOs use; I'm not
> comfortable with mdadm yet.
> 
> So, I (safely) hot pull sdb, sdd and sdf from LIVE, put them in BK, make
> them redundant, and put them back in LIVE.
> I'm debating not using the hot-swap feature, and trying to resolve the
> problems I ran into when doing the above.
> 
...
> Reasons to use the hot-swap feature : 
> If I add and remove drives with the sytem off, I hit a different set of
> problems:
> 1)If the system comes up with half the drives removed, the drives get
> relabled : they are always sda, sdb, and sdc.
>   I could rearrange things so that it's sdd,sde,and sdf that get pulled,
>   but I don't know how to do that. Hence the second question in this
>   email's subject.
The solution was to switch to using mdadm in startup scripts.  It
can handle drive letter changes.  It looks in all partitions for
superblocks indicating a raid array component.  Apply the patch below.
I also did the e2label thing on the web page; not sure if that's
necessary too.  Worked great.

 >> 2)If I put back the pulled drives, when the system restarts, sometimes
 >> these drives are chosen by the RAID code as being newer than the drives
 >> that haven't been pulled. Hence the first question in this email's
 >> subject.

  "To mark a drive (old) you have to fail it, remove it from the array,
  and re-insert it."

I haven't tried this yet.  I'd come up with and tried my own solution:
Change the partition table to make the partitions all of size 0.
This seemed to work at first, but then I ran into problems.

I got the above solutions from Derek Vadala (thanks again!)  He wrote a
book on Linux raid, which I just bought - but it's still en route, and
he's a friend of a friend, so I called him up.

Still having other problems though; will post an update.
Still failing to change the system partitions to raid.

--
Matthew

http://togami.com/~warren/guides/remoteraidcrazies/ has the following:

Apply this patch to /etc/rc.d/rc.sysinit so your system will use mdadm
rather than raidtools during bootup for starting the RAID arrays.

--- rc.sysinit.orig     2004-02-04 01:42:10.000000000 -0600
+++ rc.sysinit  2004-02-04 02:26:45.000000000 -0600
@@ -435,6 +435,10 @@
         /etc/rc.modules
  fi

+if [ -f /etc/mdadm.conf ]; then
+       /sbin/mdadm -A -s
+fi
+
  update_boot_stage RCraid
  if [ -f /etc/raidtab ]; then
      # Add raid devices
@@ -467,6 +471,10 @@
                             RESULT=0
                             RAIDDEV="$RAIDDEV(skipped)"
                         fi
+                       if [ $RESULT -gt 0 -a -x /sbin/mdadm ]; then
+                               /sbin/mdadm -Ac partitions $i -m dev
+                               RESULT=$?
+                       fi
                         if [ $RESULT -gt 0 -a -x /sbin/raidstart ]; then
                                 /sbin/raidstart $i
                                 RESULT=$?
