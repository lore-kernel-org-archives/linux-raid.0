From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: feature re-quest for "re-write"
Date: Mon, 24 Feb 2014 10:11:33 +0800
Message-ID: <530AAA55.2080508@fnarfbargle.com>
References: <alpine.DEB.2.02.1402211903030.15054@uplift.swm.pp.se> <530AA09B.3090708@fnarfbargle.com> <530AA460.602@eyal.emu.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <530AA460.602@eyal.emu.id.au>
Sender: linux-raid-owner@vger.kernel.org
To: Eyal Lebedinsky <eyal@eyal.emu.id.au>, list linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 24/02/14 09:46, Eyal Lebedinsky wrote:
> In my case (see earlier thread "raid check does not..." the pending
> sector is early
> in the device, in sector 261696 of a 4TB component (whole space in one
> partition of
> each component). So yes, inside the data area.
>
> I still have it reported in my daily logwatch, any idea what to try?
>

Yes, can you run a dd of the md device from well before to well after 
the theoretical position of the error?

If the dd passes cleanly, it indicates the bad block is a parity block 
rather than a data block. That hopefully will help narrow down the scope 
of the search.

Brad

