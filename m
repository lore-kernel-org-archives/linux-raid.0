From: Jeroen Vriesman <jeroen.vriesman@dynaserv.nl>
Subject: very slow reconstruction on firewire disks
Date: Fri, 23 Aug 2002 13:22:43 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020823132243.082f383f.jeroen.vriesman@dynaserv.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear mr. linux-raid,

I'm running kernel 2.4.19 with two firewire disks attached (Maxtor 60G), as a normal disk they work fine, but when I configure it as raid-1 with the md module, the reconstruction would take about 60 days.

In the log I get this:

Aug 24 11:48:54 syngloom kernel: Read (10) 00 00 00 19 3f 00 00 30 00
Aug 24 11:49:54 syngloom kernel: ieee1394: sbp2: aborting sbp2 command
Aug 24 11:49:54 syngloom kernel: Write (10) 00 00 00 1a 3f 00 00 28 00
Aug 24 11:50:54 syngloom kernel: ieee1394: sbp2: aborting sbp2 command
Aug 24 11:50:54 syngloom kernel: Write (10) 00 00 00 1c 3f 00 00 18 00
Aug 24 11:51:54 syngloom kernel: ieee1394: sbp2: aborting sbp2 command
Aug 24 11:51:54 syngloom kernel: Write (10) 00 00 00 1e 3f 00 00 08 00
Aug 24 11:52:54 syngloom kernel: ieee1394: sbp2: aborting sbp2 command
Aug 24 11:52:54 syngloom kernel: Read (10) 00 00 00 2b bf 00 00 18 00
Aug 24 11:53:54 syngloom kernel: ieee1394: sbp2: aborting sbp2 command

Note that it is exactly every 60 seconds, don't know if this is an md or an sbp2 problem.

Regards,
Jeroen.
