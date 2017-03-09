From: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>
Subject: Re: Auto replace disk
Date: Thu, 9 Mar 2017 10:07:56 +0100
Message-ID: <CAJH6TXgVcQa3-B=7ZJmC7Ft14Q1kn0aJmiL1P4YM47aZJzKfgA@mail.gmail.com>
References: <CAJH6TXgyOEE5A8TZVZy-db+tPD1QeHtnXXO3B-1vmKe4cAt6xA@mail.gmail.com>
 <58C04AC9.9070801@youngman.org.uk> <CAJH6TXjjjnQ3_OJ87Gv8Spsd=7BZ7RGrfCJ0kqeRXTQN_1Q3KQ@mail.gmail.com>
 <87713f17-e078-5d90-07b4-fc1dbb963496@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87713f17-e078-5d90-07b4-fc1dbb963496@fnarfbargle.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <lists2009@fnarfbargle.com>
Cc: Wols Lists <antlists@youngman.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2017-03-09 2:31 GMT+01:00 Brad Campbell <lists2009@fnarfbargle.com>:
> In general a good number of "help me my RAID is dead" requests that hit this
> list are due to not performing routine array or drive scrubs. So one drive
> dies, and one of the others has a previously unknown bad sector. When you
> put the new drive in, during the rebuild the bad sector is hit and the whole
> array comes tumbling down.
>
> Doing a proactive replacement reduces the possibility of this occurring.
> Having said that, if your disk is dead then there's no other option anyway.
> Regular array scrubs go a long way to mitigating this risk, but it does
> happen frequently enough that you need to be warned against it.

OK I misunderstood
You are right, scrubs are needed (and at least on debian, are
scheduled automatically) and I'm scrubbing my d
arrays monthly (don't know if it's enough) in addition to weekly smart long test

I was referring to just removing a disks
I thought that removing a disk was a bad idea and that MD wasn't able
to support that properly bringing the whole raid down

Also, I always use 3way mirrors or raid6.
I never use a single redundancy raid.
