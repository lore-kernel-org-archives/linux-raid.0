From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: striping and mirroring with only two disks
Date: Mon, 2 Feb 2004 15:58:27 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16413.55539.501199.360377@notabene.cse.unsw.edu.au>
References: <20040131195302.GA18341@rap.rap.dk>
	<6.0.1.1.2.20040131152717.03fe1f28@a.cs.okstate.edu>
	<20040131235556.GB19891@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Keld  =?ISO-8859-1?Q?=20J=F8rn?= Simonsen on Sunday February 1
To: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Cc: Nathan Lewis <nathapl@cs.okstate.edu>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday February 1, keld@dkuug.dk wrote:
> 
> Why has nobody thought of it before? All descriptions I have seen of
> RAID0+1 says that it needs 4 disks.

Just because it hasn't been implemented doesn't mean it hasn't been
thought of....

I started work on a "raid10" personality a while back, which could do
what you describe, or could stripe/mirror across 3 drives and other
combination.

It feel by the wayside as some things often do.

NeilBrown
