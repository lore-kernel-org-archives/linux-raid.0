From: NeilBrown <neilb@suse.de>
Subject: Re: Q: imsm rapid recovery volume
Date: Wed, 7 Sep 2011 16:27:00 +1000
Message-ID: <20110907162700.76a9afe4@notabene.brown>
References: <20110314105626.GA19922@maude.comedia.it>
	<AANLkTinzwY7CgOE2gjBUsBgKT0MTREgeYZXFDLf3BPEz@mail.gmail.com>
	<D010E79907AF0D4E90B603DE907837D5048844B742@azsmsx504.amr.corp.intel.com>
	<20110314191803.GA24188@maude.comedia.it>
	<D010E79907AF0D4E90B603DE907837D5048844BCED@azsmsx504.amr.corp.intel.com>
	<20110907060206.GB10582@maude.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110907060206.GB10582@maude.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: Luca Berra <bluca@comedia.it>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, 7 Sep 2011 08:02:06 +0200 Luca Berra <bluca@comedia.it> wrote:

> On Mon, Mar 14, 2011 at 05:27:14PM -0700, Jiang, Dave wrote:
> >Linux IMSM does not support Rapid Recovery. That is a Windows IMSM feature.
> 
> Sorry for necromancy.
> 
> Is there any plan to implement this feature in mdadm,
> or any reason not to?

The core functionality is available for native md via bitmaps are re-add.
But you have to manage it yourself.

I know of know plans to add any support for this functionality with IMSM
metadata - the current focus seems to be getting the bugs out of OnLine
Capacity Expansion.

NeilBrown


> 
> Thanks in advance and regards,
> L.
> 

