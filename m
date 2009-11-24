From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [patch 0/5] Journal guided resync and support
Date: Tue, 24 Nov 2009 12:43:19 +0100
Message-ID: <20091124114319.GA1397@ucw.cz>
References: <20091119212241.283629302@sun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ext4-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20091119212241.283629302@sun.com>
Sender: linux-ext4-owner@vger.kernel.org
To: scjody@sun.com
Cc: linux-ext4@vger.kernel.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Andreas Dilger <adilger@sun.com>
List-Id: linux-raid.ids

Hi!

> This is an updated implementation of journal guided resync, intended to be
> suitable for production systems.  This feature addresses the problem with RAID
> arrays that take too long to resync - similar to the existing MD write-intent
> bitmap feature, we resync only the stripes that were undergoing writes at the
> time of the crash.  Unlike write-intent bitmaps, our testing shows very little
> performance degredation as a result of the feature - around 3-5% vs around 30%
> for bitmaps.

Good. Now when fs know about raid and wise versa... perhaps it is time
to journal surrounding data on stripe so that power fails do not
destroy data on degraded raid5?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
