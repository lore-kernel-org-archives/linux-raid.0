From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: ANNOUNCE: mdadm 4.0 - A tool for managing md Soft RAID under Linux
Date: Mon, 9 Jan 2017 20:11:57 -0500
Message-ID: <1cd97490-e650-d98b-466a-095292dc5b98@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "Brown, Neil" <neilb@suse.com>
List-Id: linux-raid.ids

I am pleased to announce the availability of
   mdadm version 4.0

It is available at the usual places:
   http://www.kernel.org/pub/linux/utils/raid/mdadm/
and via git at
   git://git.kernel.org/pub/scm/utils/mdadm/mdadm.git
   http://git.kernel.org/cgit/utils/mdadm/

The update in major version number primarily indicates this is a
release by it's new maintainer. In addition it contains a large number
of fixes in particular for IMSM RAID and clustered RAID support.  In
addition this release includes support for IMSM 4k sector drives,
failfast and better documentation for journaled RAID.

This is my first release of mdadm. Please thank Neil Brown for his
previous work as maintainer and blame me for all the bugs I caused
since taking over.

Jes Sorensen, 2017-01-09
