From: Xiao Ni <xni@redhat.com>
Subject: The dev node can't be released at once after stopping raid
Date: Wed, 31 May 2017 23:47:19 -0400 (EDT)
Message-ID: <1159964415.16461871.1496288839399.JavaMail.zimbra@redhat.com>
References: <51439640.15505639.1496113073965.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51439640.15505639.1496113073965.JavaMail.zimbra@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all

I tried with the latest linux stable kernel and latest mdadm.

After stopping a raid device, the dev node directory can't be released
at once. I did a simple test, the script is:

#!/bin/sh

while [ 1 ]; do 
mdadm -CR /dev/md0 -l1 -n2 /dev/loop0 /dev/loop1 
sleep 5
mdadm -S /dev/md0 
ls /dev/md0
sleep 1
ls /dev/md0
done

mdadm: stopped /dev/md0
/dev/md0
ls: cannot access /dev/md0: No such file or directory

It usually detects dev node /dev/md0 isn't released after stopping raid. 
I'm not sure whether it's a bug or not. Do we need to do some job to
make sure that the node should be released before command mdadm -S return?

Best Regards
Xiao
