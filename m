From: Neil Brown <neilb@suse.de>
Subject: Re: Roadmap for md/raid ???
Date: Mon, 19 Jan 2009 11:54:00 +1100
Message-ID: <18803.53032.383350.741460@nbeee.brown>
References: <18763.7881.300921.177207@notabene.brown>
	<20081230191250.70701c5c@absurd>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Janek Kozicki on Tuesday December 30
Sender: linux-raid-owner@vger.kernel.org
To: Janek Kozicki <janek_listy@wp.pl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday December 30, janek_listy@wp.pl wrote:
> Neil Brown said:     (by the date of Fri, 19 Dec 2008 15:10:49 +1100)
> 
> > - raid5->raid6 conversion.
> >    This is also a fairly commonly asked for feature.
> 
> I can be one of the first ones to test that :)
> 

How brave do you feel?
If you clone a recent kernel then
  git pull git://neil.brown.name/md md-scratch

and compile that, you can convert a raid5 to a raid6.
Or maybe you will corrupt your data....
It worked OK for me, but I make no promises.

You cannot use mdadm.  You need to

  echo raid6 > /sys/block/mdX/md/level

The raid6 layout it uses is not the standard layout in that the
Q block is always stored on the last device rather than being
rotated around.
I plan to add support for restriping the array to get the standard
layout.  That will be a slow process and may not be worth the
effort in all cases.

There are issues with the code that make it not ready for
upstream yet.  But it is worth experimenting with if
anyone is interested...

NeilBrown
