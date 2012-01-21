From: Wolfgang Denk <wd@denx.de>
Subject: Re: Preventative replacement of active RAID1 disks
Date: Sat, 21 Jan 2012 18:21:11 +0100
Message-ID: <20120121172111.AB3CD1FD330@gemini.denx.de>
References: <4F16FB90.5000905@gmail.com> <4F1AE34D.8030209@iki.fi> <4F1AECB8.6020905@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <4F1AECB8.6020905@fnarfbargle.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <brad@fnarfbargle.com>
Cc: Anssi Hannula <anssi.hannula@iki.fi>, Jan Ceuleers <jan.ceuleers@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear Brad Campbell,

In message <4F1AECB8.6020905@fnarfbargle.com> you wrote:
>
> If you've got no reallocations, SMART tells you the drive is ok and you are not noticing any odd 
> behaviour the chances of the drive being in distress are pretty slim.

Agreed.  That's also what I do: routinely check for reallocated
sectors.

This is what it looks when a disk is slowly dying:


--- previous	2011-12-24 19:18:02.117252227 +0100
+++ latest	2011-12-25 07:18:02.332549299 +0100
@@ -1,4 +1,5 @@
...
-=== /dev/sdb : ST31000340AS S/N 9QJ5DS23 OK
+=== /dev/sdb : ST31000340AS S/N 9QJ5DS23 *** ERRORS ***
+	Reallocated Sectors:    20

--- previous	2011-12-26 07:18:01.948581196 +0100
+++ latest	2011-12-26 19:18:01.968947510 +0100
@@ -1,5 +1,5 @@
...
 === /dev/sdb : ST31000340AS S/N 9QJ5DS23 *** ERRORS ***
-	Reallocated Sectors:    20
+	Reallocated Sectors:    31

--- previous	2011-12-31 19:18:02.009911235 +0100
+++ latest	2012-01-01 07:18:02.678021034 +0100
...
 === /dev/sdb : ST31000340AS S/N 9QJ5DS23 *** ERRORS ***
-	Reallocated Sectors:    31
+	Reallocated Sectors:    33

--- previous	2012-01-09 19:18:02.433054750 +0100
+++ latest	2012-01-10 07:18:02.207395854 +0100
@@ -1,7 +1,4 @@
...
 === /dev/sdb : ST31000340AS S/N 9QJ5DS23 *** ERRORS ***
-	Reallocated Sectors:    33
+	Reallocated Sectors:    34

--- previous	2012-01-10 19:18:02.502390238 +0100
+++ latest	2012-01-11 07:18:02.147518681 +0100
...
 === /dev/sdb : ST31000340AS S/N 9QJ5DS23 *** ERRORS ***
-	Reallocated Sectors:    34
+	Reallocated Sectors:    71

--- previous	2012-01-11 19:18:02.502390238 +0100
+++ latest	2012-01-12 07:18:02.147518681 +0100
...
 === /dev/sdc : ST31000340AS S/N 9QJ5DS23 *** ERRORS ***
-	Reallocated Sectors:    71
+	Reallocated Sectors:   103

--- previous	2012-01-14 19:18:01.773819479 +0100
+++ latest	2012-01-15 07:18:02.414494003 +0100
...
 === /dev/sdb : ST31000340AS S/N 9QJ5DS23 *** ERRORS ***
-	Reallocated Sectors:   103
+	Reallocated Sectors:   127

If you see such behaviour you really want to replace the drive.

Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
What's the sound a name makes when it's dropped?
