From: Shai <shaibn@gmail.com>
Subject: raid5: switching cache buffer size, 512 --> 4096
Date: Wed, 22 Mar 2006 14:56:26 +0200
Message-ID: <e3edb0fa0603220456m1fc5687fl5960226c093a1b2f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I have two raid5 MDs: /dev/md0 and /dev/md1;

I had broken md0 the other day and had to rebuild it.
i've formated it as xfs and wanted to make md1 also xfs so I decided to
move all the data from md1 to md0.

while doing the cp of all that data, I'm getting lots of messages on
the console screen which don't enable me to work on it ( i use telnet
now ):

> raid5: switching cache buffer size, 512 --> 4096
> raid5: switching cache buffer size, 4096 --> 512

Can someone help me resolve this?

Thanks,
Shai
