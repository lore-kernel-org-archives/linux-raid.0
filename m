From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: feature suggestion to handle read errors during re-sync of raid5
Date: Mon, 01 Feb 2010 16:15:37 +0100
Message-ID: <87r5p556na.fsf@frosties.localdomain>
References: <alpine.DEB.1.10.1001301331560.15329@uplift.swm.pp.se>
	<4B6471A1.2070407@texsoft.it> <4B6482BD.6090102@anonymous.org.uk>
	<alpine.DEB.1.10.1001302228540.15329@uplift.swm.pp.se>
	<4B65AD05.5050000@anonymous.org.uk>
	<alpine.DEB.1.10.1001311854530.15329@uplift.swm.pp.se>
	<4B662ED1.3060003@gmail.com>
	<alpine.DEB.1.10.1002010814080.31777@uplift.swm.pp.se>
	<E15146CE216E4737A20C4EC59D414720@m5>
	<alpine.DEB.1.10.1002011440550.31777@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.1002011440550.31777@uplift.swm.pp.se> (Mikael
	Abrahamsson's message of "Mon, 1 Feb 2010 14:42:26 +0100 (CET)")
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Mikael Abrahamsson <swmike@swm.pp.se> writes:

> On Mon, 1 Feb 2010, Guy Watkins wrote:
>
>> I have always read that drives remap on failed write.
>> But have not read anything new in 2+ years.
>
> Yes, failed write is one thing, I agree that this happens. The
> question was if there is going to be re-map if there is a read that
> "was hard to do because it took several attemps before it succeeded".
>
> My experience is that it doesn't.

Why should it remap? The drive should frist rewrite the pattern to
refresh the bits and only when that fails a remap is required.

It is true that drives do not remap on FAILED reads but that means reads
so broken the ECC can not repair them. Simple bit errors that ECC can
repair the OS never sees. So maybe you just never had a rewrite of a bit
error give a write error?

MfG
        Goswin
