From: Michael Frotscher <infomails@tronserver.dyndns.org>
Subject: Adding spare to running array?
Date: Mon, 27 Jun 2005 15:12:30 +0200
Message-ID: <200506271512.30327.infomails@tronserver.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I experienced what probably many of you experienced before me: one disk in my 
RAID-1-array died, I got a new one and reconstructed the array. Everything 
went fine. However, there was warranty on the dead drive and I eventually got 
it back, now having one spare drive.
Is there a way to integrate that drive as a hot spare so the array will not 
fall into degraded mode even if another drive fails?

I mean, I could write a config-file which contains this array with a spare and 
do a "raidhotadd --configfile=", but will that work and leave my data 
untouched?

Sincerely,
-- 
Dipl.-Chem. Michael Frotscher
Institute of Inorganic and Applied Chemistry
University of Hamburg, Germany 
