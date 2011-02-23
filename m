From: NeilBrown <neilb@suse.de>
Subject: Re: Single-drive RAID0
Date: Wed, 23 Feb 2011 13:20:56 +1100
Message-ID: <20110223132056.4098ec5f@notabene.brown>
References: <BE2BFE91933D1B4089447C644860408067197930@irsmsx503.ger.corp.intel.com>
	<20110209134557.4e607451@notabene.brown>
	<BE2BFE91933D1B4089447C644860408068C4429D@irsmsx503.ger.corp.intel.com>
	<20110214131149.7f0655a3@notabene.brown>
	<BE2BFE91933D1B4089447C644860408068FB2C6E@irsmsx503.ger.corp.intel.com>
	<20110215110141.30d28302@notabene.brown>
	<BE2BFE91933D1B4089447C644860408068FB347B@irsmsx503.ger.corp.intel.com>
	<20110216114234.0311d27b@notabene.brown>
	<BE2BFE91933D1B4089447C644860408069028F47@irsmsx503.ger.corp.intel.com>
	<20110221131519.1039f37c@notabene.brown>
	<BE2BFE91933D1B4089447C64486040806908FC52@irsmsx503.ger.corp.intel.com>
	<20110222115011.282804d9@notabene.brown>
	<4D63E766.1000104@computer.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D63E766.1000104@computer.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jan Ceuleers <jan.ceuleers@computer.org>
Cc: "Wojcik, Krzysztof" <krzysztof.wojcik@intel.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, 22 Feb 2011 17:42:14 +0100 Jan Ceuleers <jan.ceuleers@computer.org>
wrote:

> On 22/02/11 01:50, NeilBrown wrote:
> > With the patch, the rescan is only performed when needed and so there
> > are no races.
> 
> Neil,
> 
> If I've properly understood your commit message you are reducing the 
> frequency of the rescans, but they can still occur. I submit that this 
> merely reduces the probability but does not remove the possibility of 
> races with udev.
> 
> If my interpretation is correct, then is this something that should be 
> fixed (to remove the possibility of races altogether), or merely documented?
> 
> Thanks, Jan

Thanks for reviewing the code!!

The patch should reduce the frequency of rescans to just those times when it
is actually needed.
i.e. when the array data first becomes available, and when it stops being
available.
So it will only happen as a direct result of an administrative action.

Previously it could happen at arbitrary times based on open /close/unlink
patterns.

So it isn't really "reducing the frequency" so much as "making it happen only
at well defined times, not arbitrary times".

So this does remove any possibility of races.

Thanks,
NeilBrown

