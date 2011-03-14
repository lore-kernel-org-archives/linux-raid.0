From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: high throughput storage server?
Date: Mon, 14 Mar 2011 07:27:00 -0500
Message-ID: <4D7E0994.3020303@hardwarefreak.com>
References: <AANLkTik5_Zx98rSbmpgUtG82qtFObANtCcbnn-a7MXcp@mail.gmail.com> <AANLkTimOjQDjoDMLSd1Z88GhOXoumtaQP4TyE=VpQmvQ@mail.gmail.com> <20110215044434.GA9186@septictank.raw-sewage.fake> <4D6AC288.20101@wildgooses.com> <AANLkTinjPJJrUYrA=fxcau02Q+4Z67YVsJhcGxeTpAAW@mail.gmail.com> <4D6DC585.90304@gmail.com> <AANLkTi=yWhnqY_RTd8GH+fvEQfHfQ6TpWxnzpx-Fv=aj@mail.gmail.com> <AANLkTimB2hv8aP01JdQyOJehtkX2j=G5HtgVi6eNjmLx@mail.gmail.com> <AANLkTin=0PN+ovNY=rLu21-VRiy2Ffzrf69_fWsS54iN@mail.gmail.com> <20110313201000.GA14090@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110313201000.GA14090@infradead.org>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Roberto Spadim <roberto@spadim.com.br>, Drew <drew.kay@gmail.com>, Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Christoph Hellwig put forth on 3/13/2011 3:10 PM:
> Btw, XFS has been used for >10GB/s throughput systems for about the last
> 5 years.  The big issues is getting hardware that can reliably sustain
> it - if you have that using it with Linux and XFS is not an problem at

I already noted this far back in the thread Christoph, but it is worth
repeating.  And it carries more weight when you, a Linux Kernel dev,
state this, than when I do.  So thanks for adding your input. :)

> all.  Note that with NUMA system you also have to thing about your
> intereconnect bandwith as a limiting factor for buffered I/O, not just
> the storage subsystem.

Is this only an issue with multi-chassis cabled NUMA systems such as
Altix 4000/UV and the (discontinued) IBM x86 NUMA systems (x440/445)
with their relatively low direct node-node bandwidth, or is this also of
concern with single chassis systems with relatively much higher
node-node bandwidth, such as the AMD Opteron systems, specifically the
newer G34, which have node-node bandwidth of 19.2GB/s bidirectional?

-- 
Stan
