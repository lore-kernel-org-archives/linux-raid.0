From: Tyler <pml@dtbb.net>
Subject: [Fwd: Re: Failed assertion in the MegaRAID driver]
Date: Mon, 09 May 2005 18:10:13 -0700
Message-ID: <428009F5.9050609@dtbb.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080705050201020401090406"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------080705050201020401090406
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

I believe this reply was meant for the list, and a different user, not 
myself... basically he suggests trying the RHEL 4 UP1 Beta.

Regards,
Tyler.

--------------080705050201020401090406
Content-Type: message/rfc822;
 name="Re: Failed assertion in the MegaRAID driver"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="Re: Failed assertion in the MegaRAID driver"

X-Account-Key: account2
Return-Path: <haruo.tomita@toshiba.co.jp>
Delivered-To: tyler@goliath.digitallyperfect.com
Received: (qmail 5452 invoked by alias); 9 May 2005 23:31:58 -0000
Delivered-To: pml@dtbb.net
Received: (qmail 5448 invoked from network); 9 May 2005 23:31:57 -0000
Received: from inet-tsb5.toshiba.co.jp (202.33.96.24)
  by 0 with SMTP; 9 May 2005 23:31:57 -0000
Received: from tsb-wall.toshiba.co.jp ([133.199.160.134])
	by inet-tsb5.toshiba.co.jp  with ESMTP id j49Na6nf005648
	for <pml@dtbb.net>; Tue, 10 May 2005 08:36:06 +0900 (JST)
Received: (from root@localhost)
	by tsb-wall.toshiba.co.jp  id j49Na70I001590
	for <pml@dtbb.net>; Tue, 10 May 2005 08:36:07 +0900 (JST)
Received: from ovp1.toshiba.co.jp [133.199.192.124] by tsb-wall.toshiba.co.jp with SMTP id JAA01589 ; Tue, 10 May 2005 08:36:07 +0900
Received: from mx2.toshiba.co.jp (localhost [127.0.0.1])
	by ovp1.toshiba.co.jp  with ESMTP id j49Na65G023180
	for <pml@dtbb.net>; Tue, 10 May 2005 08:36:06 +0900 (JST)
Received: from tsbomi.ome.toshiba.co.jp by toshiba.co.jp id j49Na1oH002333; Tue, 10 May 2005 08:36:04 +0900 (JST)
Received: from mx.pcs.pc.ome.toshiba.co.jp by tsbomi.ome.toshiba.co.jp (8.9.3/3.7W)
	id IAA27609; Tue, 10 May 2005 08:36:00 +0900 (JST)
Received: from pcsmail03.pcs.pc.ome.toshiba.co.jp by mx.pcs.pc.ome.toshiba.co.jp (8.9.3+3.2W/3.7W)
	id IAA23197; Tue, 10 May 2005 08:36:03 +0900
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Subject: RE: Failed assertion in the MegaRAID driver
X-MimeOLE: Produced By Microsoft Exchange V6.5.7226.0
Date: Tue, 10 May 2005 08:34:58 +0900
Message-ID: <BF571719A4041A478005EF3F08EA6DF0F6EA74@pcsmail03.pcs.pc.ome.toshiba.co.jp>
Thread-Topic: Failed assertion in the MegaRAID driver
Thread-Index: AcVU7CaxEzv5DOwUQBm+W+5HSIoDIgAAvTbw
From: "Tomita, Haruo" <haruo.tomita@toshiba.co.jp>
To: "Tyler" <pml@dtbb.net>
Cc: "Tomita, Haruo" <haruo.tomita@toshiba.co.jp>

Hi Tyler,

> >Assertion failure in journal_commit_transaction() at=20
> fs/jbd/commit.c:138:
> >"journal->j_running_transaction !=3D NULL"

This issue is not MegaRAID driver's bug.=20
It does because of race of ext3fs( journal).=20
Please use RHEL4 UP1 beta.=20
--
Haruo



--------------080705050201020401090406--
