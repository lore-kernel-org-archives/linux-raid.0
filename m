From: Christoph Hellwig <hch@infradead.org>
Subject: Re: high throughput storage server?
Date: Mon, 14 Mar 2011 08:47:33 -0400
Message-ID: <20110314124733.GA31377@infradead.org>
References: <AANLkTimOjQDjoDMLSd1Z88GhOXoumtaQP4TyE=VpQmvQ@mail.gmail.com>
 <20110215044434.GA9186@septictank.raw-sewage.fake>
 <4D6AC288.20101@wildgooses.com>
 <AANLkTinjPJJrUYrA=fxcau02Q+4Z67YVsJhcGxeTpAAW@mail.gmail.com>
 <4D6DC585.90304@gmail.com>
 <AANLkTi=yWhnqY_RTd8GH+fvEQfHfQ6TpWxnzpx-Fv=aj@mail.gmail.com>
 <AANLkTimB2hv8aP01JdQyOJehtkX2j=G5HtgVi6eNjmLx@mail.gmail.com>
 <AANLkTin=0PN+ovNY=rLu21-VRiy2Ffzrf69_fWsS54iN@mail.gmail.com>
 <20110313201000.GA14090@infradead.org>
 <4D7E0994.3020303@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4D7E0994.3020303@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: Christoph Hellwig <hch@infradead.org>, Roberto Spadim <roberto@spadim.com.br>, Drew <drew.kay@gmail.com>, Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Mar 14, 2011 at 07:27:00AM -0500, Stan Hoeppner wrote:
> Is this only an issue with multi-chassis cabled NUMA systems such as
> Altix 4000/UV and the (discontinued) IBM x86 NUMA systems (x440/445)
> with their relatively low direct node-node bandwidth, or is this also of
> concern with single chassis systems with relatively much higher
> node-node bandwidth, such as the AMD Opteron systems, specifically the
> newer G34, which have node-node bandwidth of 19.2GB/s bidirectional?

Just do your math.  Buffered I/O will do two memory copies - a
copy_to_user into the pagecache and DMA from the pagecache to the device
(yes, that's also a copy as far as the memory subsystem is concerned,
even if it is access from the device).

So to get 10GB/s throughput you spends 20GB/s on memcpys for the actual
data alone.  Add to that other system activity and metadata.  Wether you
hit the interconnect or not depends on your memory configuration, I/O
attachment, and process locality.  If you have all memory that the
process uses and all I/O on one node you won't hit the interconnect at
all, but depending on memory placement and storage attachment you might
hit it twice:

 - userspace memory on node A to pagecache on node B to device on node
   C (or A again for that matter).

In short you need to review your configuration pretty carefully.  With
direct I/O it's a lot easier as you save a copy.
