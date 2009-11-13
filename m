From: Neil Brown <neilb@suse.de>
Subject: Re: Help - Urgent!!!
Date: Fri, 13 Nov 2009 17:08:47 +1100
Message-ID: <19196.63471.532066.743149@notabene.brown>
References: <200911122253.01626.lrhorer@satx.rr.com>
	<19196.60011.858158.550391@notabene.brown>
	<19196.60094.69339.36550@notabene.brown>
	<200911122314.13426.lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from lrhorer@satx.rr.com on Thursday November 12
Sender: linux-raid-owner@vger.kernel.org
To: "lrhorer@satx.rr.com" <lrhorer@satx.rr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday November 12, lrhorer@satx.rr.com wrote:
> On Thursday 12 November 2009 11:12:30 pm you wrote:
> > On Friday November 13, neilb@suse.de wrote:
> > > 1/ show us what the result of --examine was.
> > > 2/ add -vvv to the --assemble and report the result of that.
> >
> >   3/ report the output of "mdadm -X /dev/list-of-devices"
> 
> 
> 
> RAID-Server:/etc/cron.d# mdadm --examine /dev/sd[a-j]
> /dev/sda:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : 5ff10d73:a096195f:7a646bba:a68986ca
>            Name : RAID-Server:0  (local to host RAID-Server)

Strangely this line is unique.  Every other device has:
>            Name : 'RAID-Server':0

Where do those "'"s come from???

What exactly is listed in mdadm.conf for /dev/md0??


Other than that everything looks OK.  The array hasn't been marked as
having a bitmap, but the bitmap seems to have been created correctly,
but not activated yet.

And you didn't provide the output of
   mdadm --assemble -vvv ....

That really should explain what is happening.

NeilBrown
