From: Paul Clements <paul.clements@steeleye.com>
Subject: Re: Logging-Loop when a drive in a raid1 fails.
Date: Tue, 14 Dec 2004 10:19:32 -0500
Message-ID: <41BF0484.8000903@steeleye.com>
References: <41BD2E02.8020100@geizhals.at> <41BDB049.6060201@steeleye.com> <41BEBE29.5090500@geizhals.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <41BEBE29.5090500@geizhals.at>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Renner <michael.renner@geizhals.at>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Michael Renner wrote:
> Paul Clements wrote:

>> I don't think you should be. md in 2.6 (as of 2.6.9 or so) is as 
>> stable as 2.4, at least according to our stress tests.

> Including semi-dead/dying drives? As I said, normal operation is rock 
> solid, it's just the edgy, hardly used stuff which tend(s|ed) to break.

Well, we stress test with nbd under raid1. nbd has the nice property 
that it gives I/O errors (read or write, depending on what's going on at 
the time) when its network connection is broken. So, in our tests we 
break and reconnect the nbd connection periodically, while doing heavy 
I/O and, of course, the resync activity of raid1 kicks in on top of that 
when the failed device is re-added to the array.

Both 2.4 and 2.6 md are rock solid under several days of this type of 
testing.

--
Paul
