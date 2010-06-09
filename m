From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: mdadm 3.1.x and bitmap chunk
Date: Wed, 9 Jun 2010 23:05:41 +0200
Message-ID: <20100609210541.GA12153@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi folks,

I just noticed that mdadm 3.1.x sets the default
bitmap chunk to 64MB.

Searching around, I found the reason should be
related with write performances, which seem to
be less compromised with large bitmap chunks.

I've no problem with that, but is it possible
to set the bitmap chunk to the minimum size,
without trying all the possible dimensions?

Thanks a lot in advance,

bye,

-- 

piergiorgio
