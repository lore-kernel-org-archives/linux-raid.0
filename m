From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: feature re-quest for "re-write"
Date: Fri, 21 Feb 2014 19:09:00 +0100 (CET)
Message-ID: <alpine.DEB.2.02.1402211903030.15054@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hi,

we have "check", "repair", "replacement" and other operations on raid 
volumes.

I am not a programmer, but I was wondering how much work it would require 
to take current code and implement "rewrite", basically re-writing every 
block in the md raid level. Since "repair" and "check" doesn't seem to 
properly detect a few errors, wouldn't it make sense to try least 
existance / easiest implementation route to just re-write all data on the 
entire array? If reads fail, re-calculate from parity, if reads work, just 
write again.

The goal of this new mode would be to eradicate pending sectors by 
re-writing everything on the drive.

If this doesn't seem like a sensible approach, what would be a sensible 
approach to avoid having pending sectors keep being "pending" even after 
"check" and "repair"?

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
