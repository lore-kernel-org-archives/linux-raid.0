From: Peter Rabbitson <rabbit+list@rabbit.us>
Subject: Re: Suboptimal raid6 linear read speed
Date: Tue, 15 Jan 2013 23:56:33 +1100
Message-ID: <20130115125633.GB12184@rabbit.us>
References: <20130115123301.GA11948@rabbit.us>
 <alpine.DEB.2.00.1301151344500.12098@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1301151344500.12098@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Jan 15, 2013 at 01:45:18PM +0100, Mikael Abrahamsson wrote:
> On Tue, 15 Jan 2013, Peter Rabbitson wrote:
> 
> >Any ideas/suggestions welcome.
> 
> I'm interested in seeing "iostat -x 5" output from when you're doing
> sustained reading.
> 

The entire run "from quiet to quiet" of

echo 3 > /proc/sys/vm/drop_caches; sleep 3; dd if=/dev/md6 of=/dev/null bs=1M count=8192

http://paste.debian.net/224907/
