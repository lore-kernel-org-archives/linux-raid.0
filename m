From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: Raid5 Read Perf drop in 2.6.27
Date: Thu, 10 Sep 2009 19:55:47 -0400
Message-ID: <87f94c370909101655g13d50541ma1e93c8c2893e1b8@mail.gmail.com>
References: <f5d1f90a0909091554u6d40b402ga7e9f58cabf21b57@mail.gmail.com>
	 <70ed7c3e0909091652m60b0ea9cp7000db919a639c35@mail.gmail.com>
	 <f5d1f90a0909091817g667d211djcf767714740102d@mail.gmail.com>
	 <70ed7c3e0909091827i745e2e38u6f8e246a0c9a49f@mail.gmail.com>
	 <f5d1f90a0909091845t744ce5cerdf00fd656ff21c09@mail.gmail.com>
	 <20090910172219.GB420@rap.rap.dk>
	 <f5d1f90a0909101457w7662e17ax790e179c9b11150c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <f5d1f90a0909101457w7662e17ax790e179c9b11150c@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux Raid Study <linuxraid.study@gmail.com>
Cc: =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@dkuug.dk>, "Majed B." <majedb@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2009/9/10 Linux Raid Study <linuxraid.study@gmail.com>:
> Hello:
>
> According to Wiki at http://linux-raid.osdl.org/index.php/Performance,
> disabling NCQ helps in improving perf....I thought enabling
> command-queuing helps is perf improvement. Can someone pls elaborate
> how disabling NCQ helps....
>
> I have 3 seagate HDDs (7200RPM) and 2 WD VelcoiRaptor (10k RPM) and
> disabling NCQ doesn't help in performance....
>
> thanks!

First, you are familiar with what NCQ is, right?

http://en.wikipedia.org/wiki/Native_Command_Queuing

So, the linux kernel has extremely good elevator sorting algorithms of its own.

So if the data is sent to the drive in the optimum order to reduce
disk seeks, any additional sorting the disk does can result in
unneeded overhead.

So it comes down to the disks sorting characteristics.  If they are
top-end and thus better than the kernel does, then NCQ helps.  If
low-end and thus worse than the kernel does, then it hurts.

Or so I understand it.

Greg
