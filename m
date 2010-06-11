From: "Graham Mitchell" <gmitch@woodlea.com>
Subject: RE: RAID6 and crashes (reporting back re. --bitmap)
Date: Fri, 11 Jun 2010 08:29:44 -0400
Message-ID: <004201cb0961$c6dc86d0$54959470$@woodlea.com>
References: <4C1128C2.4020105@meetinghouse.net>	<20100611005743.43664e5b@natsu>	<4C11578B.8010202@meetinghouse.net>	<20100611034108.6a2cdbc4@natsu>	<4C1169CB.1030903@meetinghouse.net>	<20100611085112.5f33b06f@natsu>	<4C11BFB7.7050907@meetinghouse.net>	<20100611150811.3c3f03bb@notabene.brown>	<4C12199F.60108@xs4all.nl> <20100611175046.54b41aad@natsu>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100611175046.54b41aad@natsu>
Content-Language: en-us
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: 'Neil Brown' <neilb@suse.de>, 'Miles Fidelman' <mfidelman@meetinghouse.net>, 'Roman Mamedov' <roman@rm.pp.ru>, 'John Hendrikx' <hjohn@xs4all.nl>
List-Id: linux-raid.ids

> I stumbled in the same way initially, but then re-read more closely and
> noticed that Neil said to run it "on some component of the array", e.g.
> /dev/sdxN, not the array itself -- and that way it worked fine. However as
my
> array sees almost no write load at the moment, I have no useful results to
> report.
> 
> --
> With respect,
> Roman
[GM> ] 

Duh.... You are correct, here's the output from one of my disks

mdadm -X /dev/sdn1
        Filename : /dev/sdn1
           Magic : 6d746962
         Version : 4
            UUID : 1470c671:4236b155:67287625:899db153
          Events : 10584
  Events Cleared : 10584
           State : OK
       Chunksize : 128 MB
          Daemon : 5s flush period
      Write Mode : Normal
       Sync Size : 488383488 (465.76 GiB 500.10 GB)
          Bitmap : 3727 bits (chunks), 0 dirty (0.0%)


Like you, I've no load on it at the moment, but I do have a couple of GB to
copy onto it today, so I'll see if I can get some more figures.

I think I need some tea...:)


G

