From: danci@agenda.si
Subject: mdadm --monitor
Date: Wed, 29 Jan 2003 15:59:58 +0100 (CET)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0301291541270.10474-100000@duplo.agenda.si>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi!

I'm trying to use mdadm to monitor my Linux RAID stuff, but it fails to
send an email and/or run the program:

/etc/mdadm.conf

DEVICE /dev/hd*
ARRAY /dev/md0 uuid=9338f6b6:ccadf20b:0fd08433:8285e108
ARRAY /dev/md1 uuid=91bdf2b7:f6e83922:49437c5e:da5d7930
ARRAY /dev/md2 uuid=5f7f8c33:a492a6a3:4129ff63:ac152b4b
MAILADDR raidalert
PROGRAM /usr/local/sbin/raidalert

'raidalert' is an alias for my account. If I do 'ls | mail raidalert', I
get a mail containin the directory listing...

/usr/local/sbin/raidalert is very simple (for now) and it works:

#!/bin/bash
/usr/bin/logger -p user.crit -t raidalert $@

So I guess I'm all set. I try 'mdadm --fail /dev/md0 /dev/hdg1' and wait.
On the console, where 'mdadm --monitor' is running, I get this:

Jan 29 15:48:25: FailSpare on /dev/md0 /dev/hdg1

But why doesn't it send the mail and/or run the program??

Thanks, D.

