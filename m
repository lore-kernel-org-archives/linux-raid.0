From: marc@fox2k.net
Subject: mdadm devices building in the wrong order
Date: Mon, 22 Oct 2007 19:44:37 -0500 (CDT)
Message-ID: <47710.64.230.0.49.1193100277.squirrel@fox2k.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I am having a rather urgent and annoying problem and I would appreciate
some input from anyone who has come across this.  I have not been able to
find a solution as of yet.  My issue deals with nested raid using mdadm,
and it seems that upon a reboot mdadm is attempting to assemble the larger
array before the smaller component array is created, and thus it is
failing.

I have a degraded raid 5 array md1 whch is composed of hda1 and md0.  Upon
a reboot, mdadm attempts to build md1 before md0 is built. It fails, so
md1 is not build and I need to assemble it manually.

Is there a solution for this?

Thanks you for your time,

Marc

p.s. I would like to also take a second to express my gratitude to Neil
Brown  for the mdadm utility.  I have found it very useful and it has made
working with raid in linux very enjoyable and straight-forward!
