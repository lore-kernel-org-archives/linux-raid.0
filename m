From: Matthias Julius <matthias.julius@gmx.de>
Subject: Raid5 with 2 bad drives
Date: Tue, 22 Feb 2005 11:43:18 -0500
Message-ID: <u650k4kbd.fsf@julius-net.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I have a raid5 out of 4 drives where 2 drives failed and were
removed.  Since it happened during backup I would very much like to
reactivate the array to rescue as much data as there are intact.

When I try to assemble the array with mdadm it tells me that there are
not enough devices.  Is there a way to convince mdadm to use the
faulty drive to get a working array?

Matthias

