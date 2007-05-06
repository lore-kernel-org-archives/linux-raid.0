From: Mark Hahn <hahn@mcmaster.ca>
Subject: Re: Speed variation depending on disk position (was: Linux SW RAID:
 HW Raid Controller/JBOD vs. Multiple PCI-e Cards?)
Date: Sun, 6 May 2007 11:29:45 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0705061121280.30950@coffee.psychology.mcmaster.ca>
References: <Pine.LNX.4.64.0705051228300.12744@p34.internal.lan>
 <20070505205456.GA17112@tuatara.stupidest.org> <463CF908.6000602@rabbit.us>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <463CF908.6000602@rabbit.us>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Rabbitson <rabbit@rabbit.us>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> very same question. Is the behavior you are describing above
> manufacturer dependent or it is pretty much dictated by the general
> design of modern drives?

the latter.  the industry keyword is "Zone Bit Recording", which 
simply tries to record data as densely as possible - determined 
by linear spacing along a track.  the only real question is how wide
the recording zone is: higher-end disks (usually scsi/fc and higher RPM)
emphasize low seek times, and thus narrow recording zones.  that means
that they have relatively small difference between fast/outer and slow
tracks.  mass-market disks optimize for density, so have a wide zone 
which therefore has more decrease in bandwidth.

> I have an array of 4 Maxtor sata drives, and
> raw read performance at the end of the disk is 38mb/s compared to 62mb/s
> at the beginning.

that's pretty typical.

regards, mark hahn.
