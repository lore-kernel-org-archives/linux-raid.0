From: Neil Brown <neilb@suse.de>
Subject: Re: mdadm break / restore soft mirror
Date: Thu, 13 Dec 2007 15:16:08 +1100
Message-ID: <18272.45576.359862.395170@notabene.brown>
References: <05ED21952E28E94E8352836547A6BA37042318B3@achmsx001.hsa.co.uk>
	<18272.34965.638276.892803@notabene.brown>
	<e03b90ae0712122000m439069y8ccad65c59cf4de9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Jeff Breidenbach on Wednesday December 12
Sender: linux-raid-owner@vger.kernel.org
To: Jeff Breidenbach <jeff@jab.org>
Cc: Brett Maton <Brett.Maton@simplyhealth.co.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday December 12, jeff@jab.org wrote:
> 
> >If you can be certain that the device that you break out of the mirror
> >is never altered, then you could add an internal bitmap while the
> >array is split and the rebuild will go much faster.
> 
> Is this also a viable speedup for the "kep rotating backup drives through
> the array" strategy? If so, how much speedup are we talking about? Assume
> the array changes by 1% before a backup drive gets rotated in again.
> 

Not really...

The bitmap only records areas of the array that have changed since one
particular moment in time.  For rotating backs you would really want
several moments in time.
Whenever the array is non-degraded, the bitmap forgets any old state.

What you could do is set the number of devices in the array to 3 so
they it always appears to be degraded, then rotate your backup drives
through the array.  The number of dirty bits in the bitmap will
steadily grow and so resyncs will take longer.  Once it crosses some
threshold you set the array back to having 2 devices to that it looks
non-degraded and clean the bitmap.  Then each device will need a full
resync after which you will get away with partial resyncs for a while.

Not ideal, but it might work.

If 1% changes each time, then you will initially get a 100 fold
speedup, dropping away after that.

NeilBrown
