From: <Foster_Brian@emc.com>
Subject: RE: linux disk access when idle
Date: Fri, 21 Aug 2009 12:35:19 -0400
Message-ID: <D27CA15508148C428A25104ADEFAAC8104529F5F@CORPUSMX50C.corp.emc.com>
References: <3ECBDC05781B3D48ABD520A01ABF2F9B2E9A6F9E25@SE-EX008.groupinfra.com> <371021.65217.qm@web51309.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <371021.65217.qm@web51309.mail.re2.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon@eHardcastle.com, matthew.garman@gmail.com, linux-raid@vger.kernel.org, andrew.henry@logica.com
List-Id: linux-raid.ids

> There is some for of flag you can apply to see write requests and the
> application that is doing them.......?
> 

You might find this useful:

echo 1 > /proc/sys/vm/block_dump

Then watch your syslog files...

Brian
