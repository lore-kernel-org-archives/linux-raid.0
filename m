From: "Potthoff, Kay" <Kay.Potthoff@force.de>
Subject: RE: Q: Priority of md_thread()
Date: Thu, 23 May 2002 10:31:04 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <9CFB9DA5261CD611A29B00508B789048654303@ex-deu-munich02.force.de>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-raid-owner@vger.kernel.org>
To: =?iso-8859-1?Q?=27Jakob_=D8stergaard=27?= <jakob@unthought.net>
Cc: "Linux RAID Mailing List (E-mail)" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

First of all, thanks for your reply! I feel relieved!

> 
> Remember the -20 is only for the CPU scheduler, and the 
> md_thread is not CPU
> bound (unless you have ISA controllers, or *very* special 
> disks).  What I am
> trying to say is, I doubt much would change if the nice level 
> was changed to
> 20 instead...

Me too, I'm not sure what influences such a change would have. If I
understood you correct, does that mean that setting the nice level to -20 is
necessary to avoid trouble on multi-processor platforms? If so, can the
problem be solved binding md_thread to one CPU during its livetime? I don't
know if Linux is offering such a feature, but as I remember once Solaris
supported that.

> 
> I think your problem is that something (and probably as you 
> state, md_thread)
> is causing fluctuations in the ping replies, causing your 
> other nodes to take
> an action which they shouldn't take based on a ping 
> fluctuation (that could
> just as easily be caused by a packet loss or some other 
> random event in the
> whole computer-network-computer system).
> 

That is right. I have an High-Availability framework that realizes an
active-standby model on two nodes. That means only one owns the RAID at a
time the other node is standby and does not access the disks while it is
standby. Only in case of a node failure of the active node the HA-framework
decides to move the ownership of the RAID to the standby node. This
detection mechanism is realized using keep alive pings through two seperate
heartbeat ethernet connections exclusively between the nodes.

> 
> Please let me know if I completely misunderstood the situation   :)

Don't be anxious, you didn't ;-)

Regards, Kay
