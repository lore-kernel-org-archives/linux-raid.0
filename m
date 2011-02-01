From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@keldix.com>
Subject: Re: What's the typical RAID10 setup?
Date: Tue, 1 Feb 2011 21:16:46 +0100
Message-ID: <20110201201646.GA26268@www2.open-std.org>
References: <AANLkTimxCkxkg6xuz8FgFf0=u4KY=0M=6+afnxLzT+Tu@mail.gmail.com> <AANLkTi=+rPzaNTKAjB=QUEGsbUcwfN8uijm96DoY_4FA@mail.gmail.com> <AANLkTinM6FkJtxL8dNpoy-haGqNsZVfLDwmvZcshTEYQ@mail.gmail.com> <AANLkTi=kUGc8bjisn69BEEkZr6kcHUyfKnVZzNtgaJf3@mail.gmail.com> <20110131225235.GA11775@www2.open-std.org> <ii8lcv$3jg$1@dough.gmane.org> <20110201160245.GA25659@www2.open-std.org> <AANLkTikUuJ5T8r0btFGzeb73BSW97kcsV5JDAjD9my+9@mail.gmail.com> <20110201175625.GA25953@www2.open-std.org> <AANLkTim_JD8g9Kcg8xrBSEQCRrD3K-sTQNjPPBg=2ckS@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <AANLkTim_JD8g9Kcg8xrBSEQCRrD3K-sTQNjPPBg=2ckS@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@keldix.com>, David Brown <david@westcontrol.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Feb 01, 2011 at 04:09:03PM -0200, Roberto Spadim wrote:
> ok, but you are wrong...
> > well, raid0 is for reading sequentially, about double as fast as raid1.
> > https://raid.wiki.kernel.org/index.php/Performance
> 
> it?s true for a mix of write/read (write is the time of slowest drive)
> 
> but if you just read, raid0 and raid1 have the same read time (depend
> on implementation, but can have the same speed)

For sequential reading, this is not true. For random reading and
writing I agree with you in theory, but benchmarks show that it is not
so, at least for Linux RAID, viz the above URL.

Have you got benchmarks to shed some light on this?

best regards
keld
