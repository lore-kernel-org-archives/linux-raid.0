From: Gordon Henderson <gordon@drogon.net>
Subject: Re: raid5: switching cache buffer size, 512 --> 4096
Date: Wed, 22 Mar 2006 13:15:36 +0000 (GMT)
Message-ID: <Pine.LNX.4.56.0603221313380.26251@lion.drogon.net>
References: <e3edb0fa0603220456m1fc5687fl5960226c093a1b2f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e3edb0fa0603220456m1fc5687fl5960226c093a1b2f@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shai <shaibn@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 22 Mar 2006, Shai wrote:

> Hi,
>
> I have two raid5 MDs: /dev/md0 and /dev/md1;
>
> I had broken md0 the other day and had to rebuild it.
> i've formated it as xfs and wanted to make md1 also xfs so I decided to
> move all the data from md1 to md0.
>
> while doing the cp of all that data, I'm getting lots of messages on
> the console screen which don't enable me to work on it ( i use telnet
> now ):
>
> > raid5: switching cache buffer size, 512 --> 4096
> > raid5: switching cache buffer size, 4096 --> 512
>
> Can someone help me resolve this?

Search the archives - I had this many moons ago. It's something to do with
xfs using a different block-size for the journal to the data, and I think
there are mount/mkfs options to remedy this, or the other solution is to
find the kprintf in the driver and comment it out...

(I stopped uing xfs, but not for other reasons. don't see it under ext3)

Gordon
