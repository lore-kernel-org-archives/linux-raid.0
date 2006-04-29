From: "Molle Bestefich" <molle.bestefich@gmail.com>
Subject: Re: md: Change ENOTSUPP to EOPNOTSUPP
Date: Sat, 29 Apr 2006 15:50:28 +0200
Message-ID: <62b0912f0604290650v6fa0759flace16041c26fa003@mail.gmail.com>
References: <20060428124313.29510.patches@notabene>
	 <1060428025144.30770@suse.de>
	 <62b0912f0604280634x7df2a8a5m9022826876446cb6@mail.gmail.com>
	 <44524765.6070703@emc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <44524765.6070703@emc.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Ric Wheeler <ric@emc.com>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Ric Wheeler wrote:
> You are absolutely right - if you do not have a validated, working
> barrier for your low level devices (or a high end, battery backed array
> or JBOD), you should disable the write cache on your RAIDed partitions
> and on your normal file systems ;-)
>
> There is working support for SCSI (or libata S-ATA) barrier operations
> in mainline, but they conflict with queue enable targets which ends up
> leaving queuing on and disabling the barriers.

Thank you very much for the information!

How can I check that I have a validated, working barrier with my
particular kernel version etc.?
(Do I just assume that since it's not SCSI, it doesn't work?)

I find it, hmm... stupefying?  horrendous?  completely brain dead?  I
don't know..  that noone warns users about this.  I bet there's a
million people out there, happily using MD (probably installed and
initialized it with Fedora Core / anaconda) and thinking their data is
safe, while in fact it is anything but.  Damn, this is not a good
situation..

(Any suggestions for a good place to fix this?  Better really really
really late than never...)
