From: Brad Campbell <brad@wasp.net.au>
Subject: Rebuild after catastrophic event?
Date: Sat, 08 Jan 2005 19:08:44 +0400
Message-ID: <41DFF77C.8070108@wasp.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: RAID Linux <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

G'day all,

With 2.4 kernels I recall that md would resync an array after a catastrophic event (like a power 
failure or kernel oops/panic). 2.6 does not seem to do that and just merrily fires up the array and 
continues on its way. Is there a reason for the change in behaviour?

I'm wondering if I should force a resync with mdadm after such an event?

I know it used to resync, and the server at work (running 2.4.26) certainly does on next powerup.

The only other change is I recall I used to have md autodetect the arrays on startup, and now I use 
mdadm to start them, but that should not matter. (should it?)

Regards,
Brad (who came home to find a paniced box and thus must ask the question)
