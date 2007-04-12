From: "Williams, Dan J" <dan.j.williams@intel.com>
Subject: RE: [PATCH RFC 3/4] md: writeback caching policy for raid5 [experimental]
Date: Wed, 11 Apr 2007 17:08:39 -0700
Message-ID: <0C7297FA1D2D244A9C7F6959C0BF1E5201AE23CF@azsmsx413.amr.corp.intel.com>
References: <Pine.LNX.4.64.0704111837410.5557@coffee.psychology.mcmaster.ca>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <Pine.LNX.4.64.0704111837410.5557@coffee.psychology.mcmaster.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Hahn <hahn@mcmaster.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> From: Mark Hahn [mailto:hahn@mcmaster.ca]
> 
> > In its current implementation write-back mode acknowledges writes
before
> > they have reached non-volatile media.
> 
> which is basically normal for unix, no?
I am referring to when bi_end_io is called on the bio submitted to MD.
Normally it is not called until after the bi_end_io event for the bio
submitted to the backing disk.

> 
> are you planning to support barriers?  (which are the block system's
way
> of supporting filesystem atomicity).
Not as a part of these performance experiments.  But, I have wondered
what the underlying issues are behind raid5 not supporting barriers.
Currently in raid5.c:make_request:

	if (unlikely(bio_barrier(bi))) {
		bio_endio(bi, bi->bi_size, -EOPNOTSUPP);
		return 0;
	}

--
Dan
