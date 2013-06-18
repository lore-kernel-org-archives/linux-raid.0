From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Mdadm server eating drives
Date: Tue, 18 Jun 2013 06:13:42 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1306180609260.4696@uplift.swm.pp.se>
References: <CAPSPcXizHpTnqfAGz7LDc3z+DSJUnOb7ukUdhbuFG6mJgs4=Bg@mail.gmail.com> <51B896A2.9090105@websitemanagers.com.au> <CAPSPcXihHrAi2TB9Fuxb1qOGMc_WzwGoXAA7nHdwe2knkO0LkQ@mail.gmail.com> <CAPSPcXib4YZ9Ah-jLvL_kPwpKHLxaGT0rNaDL4XQcFm=RtjcAQ@mail.gmail.com>
 <CAPSPcXhn8WKcZMVWhSDBVkRyqwo5XCyDc55f2sgr6davVsN5XA@mail.gmail.com> <51BA7B28.9030808@turmel.org> <CAPSPcXgMxOF-C2Szu_nf4ZLDC8p+yJFOtvLPu7xy1DTW9VAHjg@mail.gmail.com> <CAPSPcXh8C87whdXdzWgh97qiwLNZOjSB2OD_nxKCfmRL2GZ=Jg@mail.gmail.com>
 <CAPSPcXgVEEAB1UZ1R73zTRgC=VxQ8fhOwR+EJd_7bCW6D2h0fg@mail.gmail.com> <51BB8A67.5000605@turmel.org> <51BB8B86.9050803@turmel.org> <CAPSPcXi-SZjGusAtL4dj4cNNvovRcNR-uFAwAt7-9G8YRmGHkw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPSPcXi-SZjGusAtL4dj4cNNvovRcNR-uFAwAt7-9G8YRmGHkw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Barrett Lewis <barrett.lewis.mitsi@gmail.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, 17 Jun 2013, Barrett Lewis wrote:

> I did notice that before rsync found one of the differences (corrupt 
> files) it started spitting out those same "failed command: READ FPDMA 
> QUEUED status: { DRDY ERR } error: { UNC }" errors as before but this 
> time it did not fail the drive.  I take this to mean there is still some 
> physical problems with the drive, but with the new timeout settings it 
> is not unnecessarily failing the drive out of the array.  So if I 
> overwrite the corrupted files with the backups, (or write any new data 
> to the array really), will it avoid those problem areas on the platter?

What should have happened here is that when md received the read error it 
should have read parity and recalculculated what should have been on those 
read error sectors and written to them, and the drive should have either 
succeeded in writing the new information, or written them to another place 
(reallocation).

If your system is now working well, it might make sense to issue a 
"repair" to the array and let it run through completely:

echo repair > /sys/block/md0/md/sync_action

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
