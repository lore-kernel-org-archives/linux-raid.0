From: Christian Melki <christian.melki@axis.com>
Subject: Drive failure - block transfer possible?
Date: Fri, 14 Feb 2003 15:40:59 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030214144059.GA22990@aldur2.axis.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hilfe! ( help )

I own two maxtor 5400rpm 120G drives where
one of them had an electronics failure..
So all of the data is still there and intact,
but i can't put together my raid0 array
any more.. The data on it is somewhat valuable.
If there is a slim possibility to resuce it,
i would very much like to do so.
The drive just went "clickety-click" in a matter
of seconds with no previous warnings of failure..
methinks its a "cold" soldering-joint somewhere
that finally gave up on me...
I do constantly monitor the drives with smart..
( although that is no excuse for keeping the data
in raid0.. beeing a poor student is.. )
The drive in question isn't manufactured any
more so i can't get hold of a spare and do
a transfer ( dd ) with the drive electronics
that is currently still working.
And I dare not send it off to maxtor for repair,
its a 3 yr warranty.. Since they might just
replace the drive and send me a new one.. rendering
my attempts for rescue null and void..
So my question is.. how do the software-raid
in linux react to a transfer of data to a
completely new drive of a different brand..
( if it fits sizewise. )? Will it puke on me
or are there any other tricks that i can use?
Any help is greatly appreciated.

Best regards.
/Christian
Sweden.

