From: Chris Osicki <osk@admin.swisscom-mobile.ch>
Subject: Question: array locking, possible?
Date: Tue, 7 Feb 2006 18:55:17 +0100
Message-ID: <20060207185517.7bc96486@mwdsp001.swissptt.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hi

Is there any way to "lock" an active array?

To make clear what I'm after:

I have two machines forming a fail-over cluster connected over SAN to
two storage boxes which provide them with a "disk" each.
I created a RAID1 using those two "disks". 

Both cluster nodes see both disks but only one node, the active
one uses them by assembling the array.

During a fail-over I stop the array on the active node and assemble
it on the node becoming active. It works OK, or at least I haven't
seen any problems for quite a long time now.

The problem now is how to prevent somebody on the other host from
accidentally assembling the array. Because the result of doing so would
be something from strange to catastrophic ;-)

To rephrase my question, is there any way to make it visible to the
other host that the array is up an running on the this host?

Any comments, ideas?

Thanks for your time.

Regards,
Chris
