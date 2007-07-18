From: Neil Brown <neilb@suse.de>
Subject: Re: Raid array is not automatically detected.
Date: Thu, 19 Jul 2007 09:09:39 +1000
Message-ID: <18078.40371.650807.535202@notabene.brown>
References: <4697E231.3070906@hp.com>
	<4698D4FC.2060100@tmr.com>
	<Pine.LNX.4.64.0707140952440.31528@p34.internal.lan>
	<469B7E75.3030907@hp.com>
	<469B8D05.1080003@dgreaves.com>
	<469E2626.30204@hp.com>
	<469E35ED.3040500@dgreaves.com>
	<469E6267.9000107@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Bill Davidsen on Wednesday July 18
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: David Greaves <david@dgreaves.com>, Bryan Christ <bryan.christ@hp.com>, Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday July 18, davidsen@tmr.com wrote:
> David Greaves wrote:
> >
> > See where it says 'component' ? :)
> >
> > I wish mdadm --detail and --examine were just aliases and the output 
> > varied according to whether you looked at a component (eg /dev/sda1) 
> > or an md device (/dev/md0)
> >
> > I get that wrong *all* the time...
> 
> Neil, if you will take that as a suggestion, you can take this as a 
> second. While I have learned to use the correct option most of the time, 
> this is a case where the software can make an unambiguous decision to 
> avoid the human having to stop and think which option is appropriate.

The software cannot make an unambiguous decision. It is quite possible
for one md device to be a component of another md device.  In that
case, --examine and --detail are both very meaningful and very
different.

If you have trouble remembering the difference, train yourself to use
--query instead.

I am willing to consider suggestions for improving the error message
when -D or -E don't find what they expect.
I am willing to add aliases that might make it easier to remember the
difference (I confess that I chose 'detail' and 'examine' largely
because they start with 'd' and 'e', to go with assemble, build, and
create)
I am willing to make --query more useful if anyone has any
suggestions.
But I am not willing to make --detail and --examine behave
identically.

NeilBrown
