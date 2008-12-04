From: "peter.stevens" <Peter.Stevens@gtech.com>
Subject: Data integrity and RAID
Date: Thu, 4 Dec 2008 11:47:07 -0800 (PST)
Message-ID: <20841008.post@talk.nabble.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


I'm looking for a software solution to help replace my existing raid hardware
setup. The hardware mimics RAID-1 (in that it has 3 mirrors), except for the
fact that on read all 3 mirrors are compared and possibly error corrected
before data is returned. I don't neccessarily need a RAID-1 solution, it
just seems closer to what I already have and also that it also can recover
from 2 simulateous disk failures. 

So far I've played with a software RAID-1 array of USB flash drives. My
issue is that software RAID-1 does not check for or recover from data
corruption unless a read or write to disk actually fails. Integrity is a
major concern for me, I need to know that all data going to and from disk is
correct at all times.

All advice and comments are welcomed.
-- 
View this message in context: http://www.nabble.com/Data-integrity-and-RAID-tp20841008p20841008.html
Sent from the linux-raid mailing list archive at Nabble.com.

