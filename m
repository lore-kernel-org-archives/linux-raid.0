From: Neil Brown <neilb@suse.de>
Subject: RE: DMRAID feature direction?
Date: Thu, 1 Mar 2007 09:38:40 +1100
Message-ID: <17894.1136.671425.475589@notabene.brown>
References: <e9c3a7c20702271454k12035400r8b33148169952b99@mail.gmail.com>
	<39B20DF628532344BC7A2692CB6AEE070100019B@orsmsx420.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Gaston, Jason D on Wednesday February 28
Sender: linux-raid-owner@vger.kernel.org
To: "Gaston, Jason D" <jason.d.gaston@intel.com>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday February 28, jason.d.gaston@intel.com wrote:
> Thanks for the archive link, very interesting discussions with EMD...
> 
> What was the final outcome with EMD?  Is it still a valid project?
> 
> We would like to start helping with RAID feature enhancements, but we
> need to maintain support vendor specific metadata.  What is the best way
> to approach this?  Pick up EMD again, add to DMRAID, add to MD RAID or
> something else?  We want to do the right thing by the community.  Can
> anyone point me in the right direction with where to begin?

I'm keen on making md/raid work with vendor-specific metadata.  I aim
to achieve that by making it possible to do all the metadata handling
in userspace, and then maybe support loadable modules in mdadm for
different specific metadata.

I've been aiming to get DDF supported, but things keep distracting me
:-(

I only vaguely remember the EMD effort.  My memory is that a pile of
code appeared that did a variety of useful things, but there were lots
of aspects that I wasn't comfortable with.  i.e. it needed a bit of
revision before it was suitable for mainline, but there was no
followup from the coders.

I would suggest that the "right thing by the community" is to present
some details on what specifically you want to achieve and start a
discussion on how best to achieve that.  Then see where things lead.

For raid1/4/5/6, I would strongly recommend starting with the md
code-base.  If it seems like a good idea to put a 'dm' interface on
top of that, then it could probably be arranged.  If more
functionality is needed internally, or better interfaces needed to
achieve particular ends, then that is certainly possible to.

NeilBrown
