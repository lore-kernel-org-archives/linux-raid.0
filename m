From: Christoph Hellwig <hch@infradead.org>
Subject: Re: high throughput storage server?
Date: Sun, 13 Mar 2011 16:10:00 -0400
Message-ID: <20110313201000.GA14090@infradead.org>
References: <AANLkTik5_Zx98rSbmpgUtG82qtFObANtCcbnn-a7MXcp@mail.gmail.com>
 <AANLkTimOjQDjoDMLSd1Z88GhOXoumtaQP4TyE=VpQmvQ@mail.gmail.com>
 <20110215044434.GA9186@septictank.raw-sewage.fake>
 <4D6AC288.20101@wildgooses.com>
 <AANLkTinjPJJrUYrA=fxcau02Q+4Z67YVsJhcGxeTpAAW@mail.gmail.com>
 <4D6DC585.90304@gmail.com>
 <AANLkTi=yWhnqY_RTd8GH+fvEQfHfQ6TpWxnzpx-Fv=aj@mail.gmail.com>
 <AANLkTimB2hv8aP01JdQyOJehtkX2j=G5HtgVi6eNjmLx@mail.gmail.com>
 <AANLkTin=0PN+ovNY=rLu21-VRiy2Ffzrf69_fWsS54iN@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <AANLkTin=0PN+ovNY=rLu21-VRiy2Ffzrf69_fWsS54iN@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: Drew <drew.kay@gmail.com>, Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Btw, XFS has been used for >10GB/s throughput systems for about the last
5 years.  The big issues is getting hardware that can reliably sustain
it - if you have that using it with Linux and XFS is not an problem at
all.  Note that with NUMA system you also have to thing about your
intereconnect bandwith as a limiting factor for buffered I/O, not just
the storage subsystem.

