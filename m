From: peter.zeipelt@arcor.de
Subject: raidreconf "disk too small"
Date: Sun, 22 Feb 2004 08:15:30 +0100 (CET)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <349425.1077434131016.JavaMail.ngmail@webmail01.arcor-online.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello List

Experimenting with Software-Raid 5, I tried to expand an array with 3 partions.
I wanted to add one more partittion with raidreconf.
I took the /etc/raidtab, copied it and made a newraidtab, as subcribed in the Howto.
But when I ran raidreconf --test -o ... -n .. -m /dev/md0, I get the message
/dev/hdx too small (0kB).
I wrote hdx, because it seems that it is the first partition in mentioned in the
raidtabfiles .
I changed the configuration with different disks and different partitons.
Every time the messages prints out the first partition in raidtab.
The partitions are 9.3GB.
The disks I tried are 3X 120 GB mator, 1X 20GB IBM and 1X 20 GB IBM.

Any idea?
Thanks

Peter




