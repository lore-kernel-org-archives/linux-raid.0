From: Jean-Rene Cormier <jean-rene.cormier@cipanb.ca>
Subject: Software RAID1 problems
Date: 20 Feb 2003 09:20:09 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1045747209.795.7.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Well since I had some trouble with raidtools giving me a Segfault when I
tried to create an array, I decided to try mdadm, I can create an array
and format it and mount it afterwards but after I unmount it I can't
mount it again. I get an error saying unknown FS type or something like
that. When I do an mdadm --detail /dev/md0 in the state it says dirty,
no-error, shouldn't that be clean, no-error? How can I get that array to
that state? I tried recreating that array like 5 times already and still
the same thing. btw I'm running Linux 2.4.20 with glibc-2.3.1 if that
changes anything.

Jean-Rene Cormier


