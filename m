From: Nils-Henner Krueger <nhk@netuse.de>
Subject: raid on shared storage
Date: Fri, 18 Mar 2005 14:52:02 +0100
Message-ID: <423ADD02.4020008@netuse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm going to run some kind of cluster using shared
fiber channel disks with linux sw raid on top.

Is it possible to start a raid device on more than one
machine? Is there any write access for example to the
superblock structure when or after starting a raid
device that might crash with a second instance doing
the same?

I'm not talking about mounting file systems in parallel
(btw, how do I detect that a filesystem is already
mounted at a different node, does reiserfs indicate that
somehow?) but simply about starting the md.

Thanks!

nils-henner
