From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 009 of 11] md: Support stripe/offset mode in raid10
Date: Wed, 3 May 2006 10:05:53 +1000
Message-ID: <17495.62433.136481.543828@cse.unsw.edu.au>
References: <20060501152229.18367.patches@notabene>
	<1060501053054.23009@suse.de>
	<200605021938.45254.a1426z@gawab.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Al Boldi on Tuesday May 2
Sender: linux-raid-owner@vger.kernel.org
To: Al Boldi <a1426z@gawab.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>
List-Id: linux-raid.ids

On Tuesday May 2, a1426z@gawab.com wrote:
> NeilBrown wrote:
> > The "industry standard" DDF format allows for a stripe/offset layout
> > where data is duplicated on different stripes. e.g.
> >
> >   A  B  C  D	
> >   D  A  B  C	
> >   E  F  G  H	
> >   H  E  F  G	
> >
> > (columns are drives, rows are stripes, LETTERS are chunks of data).
> 
> Presumably, this is the case for --layout=f2 ?

Almost.  mdadm doesn't support this layout yet.  
'f2' is a similar layout, but the offset stripes are a lot further
down the drives.
It will possibly be called 'o2' or 'offset2'.

> If so, would --layout=f4 result in a 4-mirror/striped array?

o4 on a 4 drive array would be 

   A  B  C  D
   D  A  B  C
   C  D  A  B
   B  C  D  A
   E  F  G  H
   ....

> 
> Also, would it be possible to have a staged write-back mechanism across 
> multiple stripes?

What exactly would that mean?  And what would be the advantage?

NeilBrown
