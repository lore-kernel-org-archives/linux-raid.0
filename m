From: "Haofeng Kou" <haofengk@ptu.promise.com>
Subject: Tasklet, TaskQ and Int
Date: Wed, 24 Jul 2002 20:55:52 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <F6A3AFC9BCD92E48B79C14E4AAAEA20F45A51D@nonamea.ptu.promise.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
content-class: urn:content-classes:message
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I meet some problems in my RAID system developing.
As we know , Linux Kernel schedule methods:
1> Task Queues: <1>Scheduler queue; <2>Timer queue; <3>Immediate queue
2> Tasklet
3> Kernel timer


I have questions about the "Tasklet",  "Scheduler queue" and the
Interrupt:
For "Tasklet" and "Scheduler queue" tasks, do they have the priority,
which one is more higher and how does the kernel deal with this?
For example that if the Interrupt happen during the "Scheduler queue"
task, then Interrupt finish and schedule another "Tasklet". At this
time, I want the "Tasklet" can execute before this "Scheduler queue"
task, is it possible? How to handle it?


Thanks,
haofeng

