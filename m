From: Nix <nix@esperi.org.uk>
Subject: Re: Recovery of software RAID5 using FC6 rescue?
Date: Wed, 09 May 2007 20:50:44 +0100
Message-ID: <87odktydwr.fsf@hades.wkstn.nix>
References: <Pine.LNX.4.64.0705080821350.16228@p34.internal.lan>
	<17984.29974.116526.922404@notabene.brown>
	<7EF2C690-263B-4437-BCE2-42762484CB5B@dartmouth.edu>
	<4640D7E0.9010102@msgid.tls.msk.ru> <87vef2wlw3.fsf@hades.wkstn.nix>
	<4641B1DA.7030607@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4641B1DA.7030607@msgid.tls.msk.ru> (Michael Tokarev's message of "Wed, 09 May 2007 15:34:50 +0400")
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: "Mark A. O'Neil" <mark.a.oneil@Dartmouth.EDU>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 9 May 2007, Michael Tokarev spake thusly:
> Nix wrote:
>> On 8 May 2007, Michael Tokarev told this:
>>> BTW, for such recovery purposes, I use initrd (initramfs really, but
>>> does not matter) with a normal (but tiny) set of commands inside,
>>> thanks to busybox.  So everything can be done without any help from
>>> external "recovery CD".  Very handy at times, especially since all
>>> the network drivers are here on the initramfs too, so I can even
>>> start a netcat server while in initramfs, and perform recovery from
>>> remote system... ;)
>> 
>> What you should probably do is drop into the shell that's being used to
>> run init if mount fails (or, more generally, if after mount runs it
>
> That's exactly what my initscript does ;)

I thought so. I was really talking to Mark, I suppose.

> chk() {
>   while ! "$@"; do
>     warn "the following command failed:"
>     warn "$*"
>     p="** Continue(Ignore)/Shell/Retry (C/s/r)? "

Wow. Feature-rich :)) I may reused this rather nifty stuff.

>> hasn't ended up mounting anything: there's no need to rely on mount's
>> success/failure status). [...]
>
> Well, so far exitcode has been reliable.

I guess I was being paranoid because I'm using busybox and at various
times the exitcodes of its internal commands have been... unimplemented
or unreliable.

-- 
`In the future, company names will be a 32-character hex string.'
  --- Bruce Schneier on the shortage of company names
