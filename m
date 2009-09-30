From: Eric Ramsey <tomoyodaidoji@gmail.com>
Subject: Re: Slow network speeds between Linux RAID box and Windows PC
Date: Tue, 29 Sep 2009 23:44:04 -0600
Message-ID: <a52e82340909292244ob242e91p4b68be00af9edd3f@mail.gmail.com>
References: <3513de790909292020k79f6b83blf62e73aeb91d4681@mail.gmail.com>
	 <3513de790909292022hbff20ben3d758602f12970c1@mail.gmail.com>
	 <200909292340.12519.tfjellstrom@shaw.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200909292340.12519.tfjellstrom@shaw.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Dylan Distasio <interzone@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> I had rather sucky GbE stats till I tweaked a bunch of linux network settings.
> Things like the default buffer sizes and what not. Boosted the quite low
> 30MB/s I was getting to over 90MB/s. Look up some guides to tweak each os's
> network settings, and you should beable to speed things up.
>
> --
> Thomas Fjellstrom
> tfjellstrom@shaw.ca

Also,
Due to the design of the cifs protocol you will only see a max of
60MB/s a second or so for individual transfers. if you do multiple
files at once you should be able to max out around 90MB/s
