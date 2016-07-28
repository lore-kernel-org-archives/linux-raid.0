From: Phil Turmel <philip@turmel.org>
Subject: Re: SOLVED [was Re: GPT corruption on Primary Header, backup OK,
 fixing primary nuked array -- help?]
Date: Thu, 28 Jul 2016 17:25:07 -0400
Message-ID: <f160baa9-e360-bd4a-f0e4-b760d669f5f2@turmel.org>
References: <5796B46B.6060905@suddenlinkmail.com>
 <413b1150-ca38-1907-ea5d-b68ad2f75710@websitemanagers.com.au>
 <5796F4E0.9070206@suddenlinkmail.com> <57971D3C.8040602@suddenlinkmail.com>
 <ff6872cd-98eb-aad2-a71a-7af52050ff30@websitemanagers.com.au>
 <5797C415.8010206@suddenlinkmail.com>
 <CAJCQCtSkE+-C5U9OEm0-zazLW2KHCMUqduDTA=UHsMxmf4DVrQ@mail.gmail.com>
 <5797E869.8080403@suddenlinkmail.com>
 <CAJCQCtQpGVf2Tj13o57T4=raF=czYr-V99tEDSkJ-_buk7JtTg@mail.gmail.com>
 <57985F10.4070706@suddenlinkmail.com>
 <ac25abf7-b97e-1db4-d227-2ee57a02ed90@youngman.org.uk>
 <57993F58.1050704@suddenlinkmail.com>
 <0d00162b-6726-924a-a84d-016871563d09@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <0d00162b-6726-924a-a84d-016871563d09@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Anthony Youngman <antlists@youngman.org.uk>, "David C. Rankin" <drankinatty@suddenlinkmail.com>, mdraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 07/28/2016 08:53 AM, Anthony Youngman wrote:
> I'll just say I don't think the past 16 years is a good guide at all ...
> (but I will add I'm doing exactly the same as you - two 3TB desktop
> drives in a mirror :-).
> 
> The timeout problem seems to be relatively recent. MOST 1TB or less
> drives don't seem to have an issue. It's bigger drives that will bite you.

This is not a recent issue.  I was first bitten by this in the summer of
2011 when upgrading some Seagate drives from 1T to 2T:

http://marc.info/?l=linux-raid&m=133761065622164&w=2

Prior to this, the problem existed in the sense that SCTERC wasn't
commonly disabled on powerup for desktop drives.  More recent desktop
drives don't support it at all.

Run "smartctl -l scterc /dev/sdX" on your drives shortly after power-up.
 You should see a short time setting like this:

> SCT Error Recovery Control:
>            Read:     70 (7.0 seconds)
>           Write:     70 (7.0 seconds

If you see anything else, you will need boot time scripting or udev
scripts that will either enable the above, or reset the drive's kernel
timeout.  If you have this problem and fail to script the corrections,
your array will eventually go BOOM, even though your drives aren't
actually failed.

Phil
