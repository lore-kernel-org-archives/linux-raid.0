From: "Henry, Andrew" <andrew.henry@logica.com>
Subject: RE: linux disk access when idle
Date: Fri, 21 Aug 2009 08:42:09 +0200
Message-ID: <3ECBDC05781B3D48ABD520A01ABF2F9B2E9A6F9E25@SE-EX008.groupinfra.com>
References: <20090820163522.GA29215@sewage>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090820163522.GA29215@sewage>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Matt Garman <matthew.garman@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I had a similar issue, as I wanted to take full advantage of parking heads but they kept coming alive again.  I was putting them to sleep with hdparm.

I gave up at the end, but thought I had read that it was likely syslog or other internals that were polling the disc too frequently.  Sorry Im a bit vague on the details.

If this was the case (I didn't really investigate) then I thought, stuff it, because I wanted syslog to keep doing it's thing.

--andrew

