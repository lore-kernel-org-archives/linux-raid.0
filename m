From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: Benchmarks: Linux Kernel RAID vs a Hardware RAID setup
Date: Wed, 16 Jul 2008 06:17:56 +0200
Message-ID: <20080716041756.GA7148@rap.rap.dk>
References: <1216130769.5633.318.camel@sam.localdomain> <487CC660.9030004@ziu.info> <487D09E7.1010805@sauce.co.nz> <Pine.LNX.4.64.0807151831070.32734@filesrv1.baby-dragons.com> <487D6168.6020308@sauce.co.nz> <Pine.LNX.4.64.0807151851110.32734@filesrv1.baby-dragons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0807151851110.32734@filesrv1.baby-dragons.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Cc: Richard Scobie <richard@sauce.co.nz>, linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Jul 15, 2008 at 06:52:59PM -0800, Mr. James W. Laferriere wrote:
> 	Hello Richard ,
> 
> On Wed, 16 Jul 2008, Richard Scobie wrote:
> >Mr. James W. Laferriere wrote:
> >>    At what level (2.6.26) does one set readahead ?
> >>    I've searched 'mount' ,  'mdadm' ,  'Documentation/md.txt' .  Where 
> >>else should I look ?  Obviously I am missing something .
> >
> >Hi Jim,
> >
> >/sbin/blockdev --setra 65536 /dev/md5 gets it done here.
> >
> >Regards,
> >Richard
> 
> 	This does not bode well for my memory ,  It's already in my 
> optimizations shell script for startup .  I thought it looked very familiar 
> , But the usual places didn't bring it up .

There is a note on the wiki for preformance

Best regards
keld
