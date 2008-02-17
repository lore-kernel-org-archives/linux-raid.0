From: Mark Hahn <hahn@mcmaster.ca>
Subject: Re: RAID5 to RAID6 reshape?
Date: Sun, 17 Feb 2008 17:40:12 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0802171727250.27728@coffee.psychology.mcmaster.ca>
References: <aebf5d970802161958x17a9da92r25663703dc0df05f@mail.gmail.com>
 <20080217143122.36413814@szpak>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080217143122.36413814@szpak>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>> I'm also interested in hearing people's opinions about LVM / EVMS.
>
> With LVM it will be possible for you to have several raid5 and raid6:
> eg: 5 HHDs (raid6), 5HDDs (raid6) and 4 HDDs (raid5). Here you would
> have 14 HDDs and five of them being extra - for safety/redundancy
> purposes.

that's a very high price to pay.

> partition on top of them. Without LVM you will end up with raid6 on
> 14 HDDs thus having only 2 drives used for redundancy. Quite risky
> IMHO.

your risk model is quite strange - 5/14 redundancy means that either 
you expect a LOT of failures, or you put a huge premium on availability.
the latter is odd because normally, HA people go for replication of 
more components, not just controllers (ie, whole servers).

> It is quite often that a *whole* IO controller dies and takes all 4

you appear to be using very flakey IO controllers.  are you specifically
talking about very cheap ones, or in hostile environments?

> drives with it. So when you connect your drives, always make sure
> that you are totally safe if any of your IO conrollers dies (taking

IO controllers are not a common failure mode, in my experience.
when it happens, it usually indicates an environmental problem
(heat, bad power, bad hotplug, etc).

> Question to other people here - what is the maximum partition size
> that ext3 can handle, am I correct it 4 TB ?

8 TB.  people who want to push this are probably using ext4 already.

> And to go above 4 TB we need to use ext4dev, right?

or patches (which have been around and even in some production use 
for a long while.)
