From: Neil Brown <neilb@suse.de>
Subject: Re: single RAID slower than aggregate multi-RAID?
Date: Mon, 18 Aug 2008 21:54:45 +1000
Message-ID: <18601.25349.670500.530839@notabene.brown>
References: <alpine.DEB.1.10.0808151607560.5400@kurp.hut.fi>
	<18597.64737.508658.390657@notabene.brown>
	<alpine.DEB.1.10.0808181339010.365@kurp.hut.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Jan Wagner on Monday August 18
Sender: linux-raid-owner@vger.kernel.org
To: Jan Wagner <jwagner@kurp.hut.fi>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday August 18, jwagner@kurp.hut.fi wrote:
> Hello Neil and all,
> 
> first off thanks for your interest.
> 
> On Sat, 16 Aug 2008, Neil Brown wrote:
> > You should only need about 12Meg of dirty memory to keep your RAID0
> > busy, and I doubt that is even 1% of your memory.
> 
> Strange. With the 12disk raid we get as much as 200MB dirty and throughput 
> is slow. With the 4*3disk raid's we see just around 12MB and throughput 
> is good. We have 4GB RAM.

The differences in Dirty and Writeback numbers are interesting.  I'm
not sure what they signify yet.


in:
> 
> http://www.metsahovi.fi/~jwagner/10g-tests/pmp/linux-raid-1.txt
> 

you appear to be doing the write tests to the three small arrays in
series, one after the other.
You need to do them in parallel to find the aggregate bandwidth of the
system.
i.e.  run

sudo /usr/bin/time dd if=/dev/zero of=/dev/md0 bs=1024k count=48000 & 
sudo /usr/bin/time dd if=/dev/zero of=/dev/md1 bs=1024k count=48000 &
sudo /usr/bin/time dd if=/dev/zero of=/dev/md2 bs=1024k count=48000 &
 
all at once in the background.  What does that produce?

NeilBrown
