From: "Dragon" <Sunghost@gmx.de>
Subject: (unknown)
Date: Sat, 18 Jun 2011 22:39:54 +0200
Message-ID: <20110618203954.129920@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: philip@turmel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Monitor your background reshape with "cat /proc/mdstat".

When the reshape is complete, the extra disk will be marked "spare".

Then you can use "mdadm --remove".
-->after a view days the reshape was done and i take the disk out of the raid -> many thx for that

> at this point i think i take the disk out of the raid, because i need the space of
the disk.

Understood, but you are living on the edge.  You have no backup, and only one drive
of redundancy.  If one of your drives does fail, the odds of losing the whole array
while replacing it is significant.  Your Samsung drives claim a non-recoverable read
error rate of 1 per 1x10^15 bits.  Your eleven data disks contain 1.32x10^14 bits,
all of which must be read during rebuild.  That means a _13%_ chance of total
failure while replacing a failed drive.

I hope your 16T of data is not terribly important to you, or is otherwise replaceable.
--> nice calculation, where do you have the data from?
--> most of it is important, i will look for a better solution

> I need another advise of you. While the computer is actualy build with 13 disk and
i will become more data in the next month and the limit of power supply
connecotors is reached i am looking forward to another solution. one possibility
is to build up a better computer with more sata and sas connectors and add further
raid-controller-cards. an other idea is to build a kind of cluster or dfs with two
and later 3,4... computer. i read something about gluster.org. do you have a tip
for me or experience in this?

Unfortunately, no.  Although I skirt the edges in my engineering work, I'm primarily
an end-user.  Both personal and work projects have relatively modest needs.  From
the engineering side, I do recommend you spend extra on power supplies & UPS.

Phil
--> and than, ext4 max size is actually 16TB, what should i do?
--> for an end-user you have many knowledge about swraid ;)
sunny
-- 
NEU: FreePhone - kostenlos mobil telefonieren!			
Jetzt informieren: http://www.gmx.net/de/go/freephone
