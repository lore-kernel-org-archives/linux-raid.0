From: Jamie Guinan <guinan@bluebutton.com>
Subject: raidtab.5 trivial patch
Date: Tue, 13 Aug 2002 21:21:23 -0400 (EDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.33.0208132114270.15019-100000@gemini.home.net>
Reply-To: <guinan@bluebutton.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


( I'm not subscribed, but this list is mentioned in
  raidtools-20010914/README )


--- raidtab.5.ori	Tue Aug 13 21:13:40 2002
+++ raidtab.5	Tue Aug 13 21:13:43 2002
@@ -106,7 +106,7 @@
 
 .TP
 \fBchunk-size \fIsize\fR
-Sets the stripe size to \fIsize\fR bytes. Has to be a power of 2 and
+Sets the stripe size to \fIsize\fR kilobytes. Has to be a power of 2 and
 has a compilation-time maximum of 4M. (MAX_CHUNK_SIZE in the kernel
 driver) typical values are anything from 4k to 128k, the best value
 should be determined by experimenting on a given array, alot depends


