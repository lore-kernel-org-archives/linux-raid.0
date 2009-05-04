From: "NeilBrown" <neilb@suse.de>
Subject: Re: 32bit variables on >2T arrays
Date: Mon, 4 May 2009 17:01:20 +1000 (EST)
Message-ID: <48a370bae432f6e8bffc48121f9f6f2e.squirrel@neil.brown.name>
References: <20090503141300.GA30773@darkside.22.kls.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090503141300.GA30773@darkside.22.kls.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, May 4, 2009 12:13 am, Mario 'BitKoenig' Holbe wrote:
> Hello again :)
>
> there seems to be another (minor) 32bit-issue...
>
> md7 : active raid10 sdh1[5] sdg1[3] sdf1[1] sdc1[0] sde1[4] sdd1[2]
>       4395406848 blocks 512K chunks 2 near-copies [6/6] [UUUUUU]
>       [>....................]  check =  0.6% (28034560/4395406848)
> finish=4.7min speed=254624K/sec
>       bitmap: 0/131 pages [0KB], 16384KB chunk
>
> the time-to-finish calculation seems to be quite optimistic :)

Thanks.

I've just posted as series of patches which includes a fix for
this as well as the other issues you identified.

Thanks for helping to improve md!

NeilBrown

