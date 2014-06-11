From: Bart Kus <me@bartk.us>
Subject: md-raid paranoia mode?
Date: Tue, 10 Jun 2014 23:48:46 -0700
Message-ID: <5397FBCE.3060009@bartk.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

As far as I understand, md-raid relies on the underlying devices to 
inform it of IO errors before it'll seek redundant/parity data to 
fulfill the read request.  I have, however, seen certain hard drives 
report successful reads while returning garbage data.

Is it possible to set md-raid into a paranoid mode, in which it reads 
all available data and confirms integrity?  Here's how it would work:

RAID6: read data + parity 1 + parity 2.  If 1 of the 3 mismatches, 
correct it, and write corrected data to the corrupt source.  Log the 
event.  If all 3 disagree, alert user somehow.
RAID5: read data + parity.  If they mismatch, alert user somehow.
RAID1: read data 1 + data 2.  If they mismatch, alert user somehow.

You can see this is mostly useful for RAID6 mode, where there is a 
chance at automated recovery.  However, it can also be used to prevent 
silent data corruption in the other modes, by making it not silent.

--Bart

