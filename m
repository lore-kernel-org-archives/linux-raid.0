From: Janek Kozicki <janek_listy@wp.pl>
Subject: Re: RAID5 to RAID6 reshape?
Date: Mon, 18 Feb 2008 00:54:50 +0100
Message-ID: <20080218005450.6b4bc0b3@szpak>
References: <aebf5d970802161958x17a9da92r25663703dc0df05f@mail.gmail.com>
	<20080217143122.36413814@szpak>
	<Pine.LNX.4.64.0802171727250.27728@coffee.psychology.mcmaster.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0802171727250.27728@coffee.psychology.mcmaster.ca>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mark Hahn said:     (by the date of Sun, 17 Feb 2008 17:40:12 -0500 (EST))

> >> I'm also interested in hearing people's opinions about LVM / EVMS.
> >
> > With LVM it will be possible for you to have several raid5 and raid6:
> > eg: 5 HHDs (raid6), 5HDDs (raid6) and 4 HDDs (raid5). Here you would
> > have 14 HDDs and five of them being extra - for safety/redundancy
> > purposes.
> 
> that's a very high price to pay.
> 
> > partition on top of them. Without LVM you will end up with raid6 on
> > 14 HDDs thus having only 2 drives used for redundancy. Quite risky
> > IMHO.
> 
> your risk model is quite strange - 5/14 redundancy means that either 

yeah, sorry. I went too far.

I didn't have IO controller failure so far. But I've read about one
on this list, and that all data was lost.

You're right, better to duplicate a server with backup copy, so it is
independent of the original one.

-- 
Janek Kozicki                                                         |
