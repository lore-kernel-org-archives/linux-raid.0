From: Nat Makarevitch <nat@makarevitch.org>
Subject: Re: 2x6 or 3x4 raid10 arrays ?
Date: Thu, 28 Feb 2008 22:36:22 +0000 (UTC)
Message-ID: <loom.20080228T223023-79@post.gmane.org>
References: <1204195554.16924.16.camel@franck-gusty>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Franck Routier <franck.routier <at> axege.com> writes:

> database (postgresql) server.

AFAIK if the average size of an I/O operation as long as the corresponding
variance are low... go for a single RAID10,f2 with a stripe size slightly
superior to this average. This way you will have most requests mobilizing only a
single spindle and all your spindles acting in parallel. If this average size
varies upon tables one may create a RAID (with the adequate stripe size) per
database partition.

-- 
http://www.makarevitch.org/rant/raid/


