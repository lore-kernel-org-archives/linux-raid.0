From: "Daniel L. Miller" <dmiller@amfes.com>
Subject: [Fwd: [Bug 157981] Re: udev not using mdadm incremental]
Date: Thu, 24 Jul 2008 16:56:27 -0700
Message-ID: <488916AB.9030401@amfes.com>
Reply-To: dmiller@amfes.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070703060506000204060008"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------070703060506000204060008
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Just sharing this with the group...this came up when I reported (quite a 
while back!) that Ubuntu didn't bring up a degraded array automatically, 
and there was surprise expressed that udev wasn't using incremental mode.

-- 
Daniel

--------------070703060506000204060008
Content-Type: message/rfc822;
 name="[Bug 157981] Re: udev not using mdadm incremental.eml"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="[Bug 157981] Re: udev not using mdadm incremental.eml"

Return-Path: <bounces@canonical.com>
X-Original-To: dmiller@amfes.com
Delivered-To: dmiller@amfes.com
Received: from adelie.canonical.com (bubba.amfeslan.local [192.168.0.72])
	by mail.amfes.com (Postfix) with ESMTP id 4354911A5E7
	for <dmiller@amfes.com>; Thu, 24 Jul 2008 16:18:41 -0700 (PDT)
Received: from adelie.canonical.com ([91.189.90.139] helo=adelie.canonical.com)
	by mail.amfes.com; 24 Jul 2008 16:18:40 -0700
Received: from forster.canonical.com ([91.189.90.190])
	by adelie.canonical.com with esmtp (Exim 4.60 #1 (Debian))
	id 1KM9dg-00012R-MA
	for <dmiller@amfes.com>; Thu, 24 Jul 2008 23:50:24 +0100
Received: from localhost ([127.0.0.1] helo=forster.canonical.com)
	by forster.canonical.com with esmtp (Exim 4.69 #1 (Debian))
	id 1KM9dg-0008PA-GF
	for <dmiller@amfes.com>; Thu, 24 Jul 2008 23:50:24 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: ceg <c.gatzemeier@tu-bs.de>
To: dmiller@amfes.com
Reply-To: Bug 157981 <157981@bugs.launchpad.net>
References: <20071028081737.2594.73540.malonedeb@potassium.ubuntu.com>
Sender: bounces@canonical.com
Date: Thu, 24 Jul 2008 22:41:57 -0000
Message-Id: <20080724224157.11514.56502.malone@gangotri.canonical.com>
Subject: [Bug 157981] Re: udev not using mdadm incremental
X-Launchpad-Bug: distribution=ubuntu; sourcepackage=mdadm; component=main;
	status=New; importance=Undecided; assignee=None;
X-Launchpad-Bug-Private: no
X-Launchpad-Bug-Security-Vulnerability: no
X-Launchpad-Message-Rationale: Subscriber
Errors-To: bounces@canonical.com
Precedence: bulk
X-Generated-By: Launchpad (canonical.com)
X-Assp-Delay: delayed for 27m 38s; 24 Jul 2008 16:18:41 -0700
X-Assp-Message/IP-Score: 25 (Message-ID not valid: '<20080724224157.11514.56502.malone@gangotri.canonical.com>')
X-Assp-Message-Score: -20 (91.189.90 in griplist < 0,1)
X-Assp-Message-Score: 10 (Foreign Country GB - Canonical)
X-Assp-Received-SPF: none ip=91.189.90.139 mailfrom=bounces@canonical.com
	helo=adelie.canonical.com
X-Assp-Message/IP-Score: 5 (SPF none)
X-Assp-Envelope-From: bounces@canonical.com
X-Assp-Intended-For: dmiller@amfes.com


--incremental is available in hardy (8.04)

Some info on howto enable it is available on:
https://wiki.ubuntu.com/BootDegradedRaid

-- =

udev not using mdadm incremental
https://bugs.launchpad.net/bugs/157981
You received this bug notification because you are a direct subscriber
of the bug.

--------------070703060506000204060008--
