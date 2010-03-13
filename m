From: Joachim Otahal <Jou@gmx.net>
Subject: md devices: Suggestion for in place time and checksum within the
 RAID
Date: Sun, 14 Mar 2010 00:00:37 +0100
Message-ID: <4B9C1915.9080009@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Current Situation in RAID:
If a drive fails silently and is giving out wrong data instead of read 
errors there is no way to detect that corruption (no fun, I had that a 
few times already).
Even in RAID1 with three drives there is no "two over three" voting 
mechanism.

A workaround for that problem would be:
Adding one sector to each chunk to store the time (in nanoseconds 
resolution) + CRC or ECC value of the whole stripe, making it possible 
to see and handle such errors below the filesystem level.
Time in nanoseconds only to differ between those many writes that 
actually happen, it does not really matter how precise the time actually 
is, just every stripe update should have a different time value from the 
previous update.
It would be an easy way to know which chunks are actually the latest (or 
which contain correct data in case one out of three+ chunks has a wrong 
time upon reading). A random uniqe ID or counter could also do the job 
of the time value if anyone prefers, but I doubt since the collision 
possibility would be higher.
The use of CRC or ECC or whatever hash should be obvious, their 
existence would make it easy to detect drive degration, even in a RAID0 
or LINEAR.
Bad side: Adding this might break the on the fly raid expansion 
capabilities. A workaround might be using 8K(+ one sector) chunks by 
default upon creation or the need to specify the chunk size on creation 
(like 8k+1 sector) if future expansion capabilities are actually wanted 
with RAID0/4/5/6, but that is a different issue anyway.

Question:
Will RAID4/5/6 in the future use the parity upon read too? Currently it 
would not detect wrong data reads from the parity chunk, resulting in a 
disaster when it is actually needed.

Do those plans already exist and my post was completely useless?

Sorry that I cannot give patches, my last kernel patch + compile was 
2.2.26, since then I never compiled a kernel.

Joachim Otahal

