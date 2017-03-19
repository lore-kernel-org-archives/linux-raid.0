From: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>
Subject: component device mismatches found
Date: Sun, 19 Mar 2017 11:00:36 +0100
Message-ID: <CAJH6TXgA-5-PXmFdY7b1J8eYc3zbmb7ui8Fa8k+ihMKd7nQ8vw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I've seen this in my log:

Mar 19 00:57:01 x /USR/SBIN/CRON[17832]: (root) CMD (if [ -x
/usr/share/mdadm/checkarray ]; then /usr/share/mdadm/checkarray --cron
--all --idle --quiet; fi)
Mar 19 00:57:01 x mdadm[1576]: RebuildStarted event detected on md
device /dev/md/0
Mar 19 01:30:21 x mdadm[1576]: Rebuild24 event detected on md device /dev/md/0
Mar 19 02:03:41 x mdadm[1576]: Rebuild47 event detected on md device /dev/md/0
Mar 19 02:37:02 x mdadm[1576]: Rebuild68 event detected on md device /dev/md/0
Mar 19 03:10:22 x mdadm[1576]: Rebuild87 event detected on md device /dev/md/0
Mar 19 03:38:00 x mdadm[1576]: RebuildFinished event detected on md
device /dev/md/0, component device  mismatches found: 4608

This is a 3way mirror.

I've tought that swap was the culpit, but swap isn't used:

# free -m
             total       used       free     shared    buffers     cached
Mem:         32230      31844        386          0       1679      26026
-/+ buffers/cache:       4137      28092
Swap:         8191          0       8191

and IIRC, linux never clean the swap usage up to 0.

Are my data safe ? Is something to be worried about ?
