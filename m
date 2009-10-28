From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: md software raid
Date: Wed, 28 Oct 2009 01:37:18 -0500
Message-ID: <20091028063725728.UYEG9287@cdptpa-omta02.mail.rr.com>
References: <20091028035046.GA19955@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091028035046.GA19955@infradead.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> > > Why not use xfs_repair -n?
> >
> > 	I guess the short answer is, "I didn't know it would make a
> > difference".  I take it, then, xfs_repair uses a completely different
> method
> > of scanning for errors than xfs_check, one whihcdoes not require so much
> > memory?  I find that a bit surprising.
> 
> xfs_repair is a separate program that is actually mainainted.  xfs_check
> is deprecated and we'll eventually remove it after porting one
> remaining checking pass over to xfs_repair (currently xfs_repair can't
> check the freespace btree but only fully rebuild them when in repair
> mode)

	OK, great!  Query: my swap space of 10G was nowhere nearly enough to
cover the useage by xfs_check.  Will it be sufficient for xfs_repair with
the -n option?

