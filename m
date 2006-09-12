From: Roland Dreier <rdreier@cisco.com>
Subject: Re: [PATCH 08/19] dmaengine: enable multiple clients and operations
Date: Mon, 11 Sep 2006 17:52:47 -0700
Message-ID: <adairjt3nz4.fsf@cisco.com>
References: <1158015632.4241.31.camel@dwillia2-linux.ch.intel.com>
	<20060911231817.4737.49381.stgit@dwillia2-linux.ch.intel.com>
	<4505F4D0.7010901@garzik.org>
	<e9c3a7c20609111714h1b88f8cbid99c567d7f3e997c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e9c3a7c20609111714h1b88f8cbid99c567d7f3e997c@mail.gmail.com> (Dan Williams's message of "Mon, 11 Sep 2006 17:14:44 -0700")
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jeff Garzik <jeff@garzik.org>, neilb@suse.de, linux-raid@vger.kernel.org, akpm@osdl.org, linux-kernel@vger.kernel.org, christopher.leech@intel.com
List-Id: linux-raid.ids

    Jeff> Are we really going to add a set of hooks for each DMA
    Jeff> engine whizbang feature?

    Dan> What's the alternative?  But, also see patch 9 "dmaengine:
    Dan> reduce backend address permutations" it relieves some of this
    Dan> pain.

I guess you can pass an opcode into a common "start operation" function.

With all the memcpy / xor / crypto / etc. hardware out there already,
we definitely have to get this interface right.

 - R.
