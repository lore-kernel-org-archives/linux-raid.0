From: <brian.foster@emc.com>
Subject: --assume-clean on raid5/6
Date: Thu, 5 Aug 2010 21:19:25 -0400
Message-ID: <D27CA15508148C428A25104ADEFAAC810661CD00@CORPUSMX50C.corp.emc.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

I've read in the list archives that use of --assume-clean on raid5
(raid6?) is not safe assuming the member drives are not sync, but it's
not clear to me as to why. I can see the content of an written raid5
array change if I fail a drive out of the array (created w/
--assume-clean), but data that I write prior to failing a drive remains
intact. Perhaps I'm missing something. Could somebody elaborate on the
danger/risk of using --assume-clean? Thanks in advance.

Brian
