From: SainTiss <saintiss@gmx.net>
Subject: mdadm hotadd sync order
Date: Tue, 10 May 2005 15:40:03 +0200
Message-ID: <20050510154003.574135b8@macinf5.ruca.ua.ac.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

how does mdadm determine which device to synchronize to which?

For example, I have two partitions A and B which I would like to be setup as a RAID-1 array.

suppose A contains the data I want to have, and B contains rubbish. Obviously, I want B to be synched to A, and not the other way round.

Suppose I do this:

mdadm --create /dev/md0 --level=1 --raid-devices=2 A B

Will B then automatically sync to A? I'm almost sure I just encountered a counterexample.

Or what would happen with the following?
mdadm --create /dev/md0 --level=1 --raid-devices=2 missing B
mdadm -a /dev/md0 A

will A then sync to B because it was added last, or B to A because A fills the "missing" spot, which was specified before B?

So the question is: What criteria does mdadm use to determine which device to synchronize to which?

Thanks in advance,

Hans
