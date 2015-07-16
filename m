From: "John Stoffel" <john@stoffel.org>
Subject: Re: [PATCH V4 00/13] MD: a caching layer for raid5/6
Date: Thu, 16 Jul 2015 11:07:34 -0400
Message-ID: <21927.51382.8600.700720@quad.stoffel.home>
References: <20150710040847.GA1408097@devbig257.prn2.facebook.com>
	<20150710143656.4ee7e647@noble>
	<20150715004455.GA1024035@devbig257.prn2.facebook.com>
	<20150715121234.22803890@noble>
	<20150715031615.GA1292235@devbig257.prn2.facebook.com>
	<20150715140641.3c61cf78@noble>
	<20150715194927.GA3502691@devbig257.prn2.facebook.com>
	<20150716091653.7b970b32@noble>
	<20150716000739.GA4041321@devbig257.prn2.facebook.com>
	<20150716112217.3e2e685f@noble>
	<20150716041305.GA283306@devbig257.prn2.facebook.com>
	<20150716160711.08c37fc1@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150716160711.08c37fc1@noble>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Shaohua Li <shli@fb.com>, linux-raid@vger.kernel.org, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com, Kernel-team@fb.com
List-Id: linux-raid.ids


So.... how will wrapping of sequence numbers be handled in the cache
metadata on disk?  They can't grow for ever...

John
