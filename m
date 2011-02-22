From: Jan Ceuleers <jan.ceuleers@computer.org>
Subject: Re: Single-drive RAID0
Date: Tue, 22 Feb 2011 17:42:14 +0100
Message-ID: <4D63E766.1000104@computer.org>
References: <BE2BFE91933D1B4089447C644860408067197930@irsmsx503.ger.corp.intel.com>	<20110209134557.4e607451@notabene.brown>	<BE2BFE91933D1B4089447C644860408068C4429D@irsmsx503.ger.corp.intel.com>	<20110214131149.7f0655a3@notabene.brown>	<BE2BFE91933D1B4089447C644860408068FB2C6E@irsmsx503.ger.corp.intel.com>	<20110215110141.30d28302@notabene.brown>	<BE2BFE91933D1B4089447C644860408068FB347B@irsmsx503.ger.corp.intel.com>	<20110216114234.0311d27b@notabene.brown>	<BE2BFE91933D1B4089447C644860408069028F47@irsmsx503.ger.corp.intel.com>	<20110221131519.1039f37c@notabene.brown>	<BE2BFE91933D1B4089447C64486040806908FC52@irsmsx503.ger.corp.intel.com> <20110222115011.282804d9@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110222115011.282804d9@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "Wojcik, Krzysztof" <krzysztof.wojcik@intel.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 22/02/11 01:50, NeilBrown wrote:
> With the patch, the rescan is only performed when needed and so there
> are no races.

Neil,

If I've properly understood your commit message you are reducing the 
frequency of the rescans, but they can still occur. I submit that this 
merely reduces the probability but does not remove the possibility of 
races with udev.

If my interpretation is correct, then is this something that should be 
fixed (to remove the possibility of races altogether), or merely documented?

Thanks, Jan
