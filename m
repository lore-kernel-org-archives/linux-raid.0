From: Daniel Reurich <daniel@centurion.net.nz>
Subject: smartchecks of raid members
Date: Tue, 22 Dec 2009 10:00:50 +1300
Message-ID: <1261429250.7944.2249.camel@ezra>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

Is it safe and can it easily be done to put a raid1 member volume into
"write mostly && write behind" mode temporarily while doing a SMART full
disk check on that disk?

I believe this may help with the smart check as it stops the
interruptions caused by reads from the disk, and the writes will be
delayed and hopefully committed in larger chunks less often.  I also
this will allow the server to perform better by not blocking until the
writes on the disk being checked return.

Is the only risk the delay between a write being completed as far as the
process is concerned and the write being committed to the disk being
smart checked?

Daniel Reurich



