From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: [RFCI] How best to partition MD/raid devices in 2.6
Date: Fri, 14 Nov 2003 16:32:48 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16308.26880.297498.100662@notabene.cse.unsw.edu.au>
References: <16308.18387.142415.469027@notabene.cse.unsw.edu.au>
	<20031114050934.GI24159@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from viro@parcelfarce.linux.theplanet.co.uk on Friday November 14
To: viro@parcelfarce.linux.theplanet.co.uk
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday November 14, viro@parcelfarce.linux.theplanet.co.uk wrote:
> 

Thanks for the comments.

> (3) is absolutely trivial - will take 10--30 lines in md.c.

Yes.  I've actually started working on that (clear some stuff up first
so it become even more trivial).  I was feeling uncomfortable about
the non-uniform interpretation of minor numbers.  I know the block
layer can handle it.  I'm wondering what I should expect of users
though :-)

NeilBrown
