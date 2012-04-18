From: Phil Turmel <philip@turmel.org>
Subject: Re: software raid and ERC
Date: Tue, 17 Apr 2012 22:08:33 -0400
Message-ID: <4F8E2221.8090604@turmel.org>
References: <CAAevFRRuGc6x4hJax-kM8ncW9=873aRnjN-WWkoheYD7r6jimA@mail.gmail.com> <CAAevFRQw97xTgpct9ML_SWAyw-Zc=9fuioigVBpg7HpZ89kQxg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAAevFRQw97xTgpct9ML_SWAyw-Zc=9fuioigVBpg7HpZ89kQxg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "." <desire@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 04/17/2012 10:05 AM, . wrote:
> I'm trying to decide what disks to use for a software raid array that
> will host mirrors of open source stuff.  So this array will run 24/7
> and resiliency to disk failures is needed, but service levels can be
> similar to a home file server.  ie, it's ok if one of the disks goes
> into a deep recovery cycle for a few minutes once a month and I can't
> host the stuff - people will just retry the download.  Backups aren't
> really important either, as I can just mirror all the content again
> (even if it takes weeks to do so).
> 
> Due to budget reasons, "enterprise" disks are out. What I've read
> strongly recommends the ERC / TLER / CCTL feature for raid
> applications - even including software raid.  But is ERC really
> required in my scenario?
> 
> The Wikipedia article at
> http://en.wikipedia.org/wiki/Error_recovery_control#Software_Raid on
> ERC seems to suggest that mdadm will not error out the drive no matter
> how long the recovery takes.  Instead, the SCSI disk layer is the
> limiting factor, as a lengthy recovery cycle could lead to a scsi
> command timeout, ignoring the drive reset command, and leading to the
> disk being marked offline.  If this is indeed the case, I am tempted
> to just set the scsi timeout value to 5 minutes (or whatever the
> maximum period that deep recovery can take).  Are there other similar
> timeouts or gotchas in other layers?  Eg, in LVM, FS code, etc?

I've been burned by this very phenomenon on a set of Seagate drives
that I thought had SCTERC, but didn't (their predecessors did).

I wasn't aware that the driver timeouts were configurable.  Pointers?

> In another post
> (http://marc.info/?l=linux-raid&m=130964222812107&w=2), Drew said:
>> TLER just shortens the firmware's error recovery from something like
>> 60 seconds down to 4 seconds. It's mainly useful in hardware RAID but
>> I can see it being useful with mdraid in the enterprise where you
>> can't afford to wait for the drive to do it's own recovery attempts.
> 
> In my use case, I really don't mind if the server freezes for a while.
> 
> Please advise if there are other considerations for ERC, use of
> consumer-grade disks, or "enterprise" disks.  Thanks!

Be aware that SCTERC must be set on any drive power cycle--it's not a
persistent setting on desktop drives.

> P.S. I would buy ERC if I could, but the right hard disk models do not
> seem to be available locally.  My preference is for the Hitachi 7k3000
> series, but it seems to be out of stock with possibly months of delay.
>  So what's left are the consumer 2TB models with ERC feature -
> possibly just the Hitachi 2TB or Samsung Spinpoint F4 2TB.  I'd
> appreciate any other suggestions too.

The 7k3000 family is my preference at the moment.  Fortunately I don't
have an immediate need.
