From: Hendrik Visage <hvisage@envisage.co.za>
Subject: Re: striping and mirroring with only two disks
Date: Mon, 2 Feb 2004 10:46:20 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040202084619.GI6504@hvs.envisage.co.za>
References: <20040131195302.GA18341@rap.rap.dk> <6.0.1.1.2.20040131152717.03fe1f28@a.cs.okstate.edu> <20040131235556.GB19891@rap.rap.dk> <16413.55539.501199.360377@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <16413.55539.501199.360377@notabene.cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>, Nathan Lewis <nathapl@cs.okstate.edu>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Feb 02, 2004 at 03:58:27PM +1100, Neil Brown wrote:
> On Sunday February 1, keld@dkuug.dk wrote:
> 
> I started work on a "raid10" personality a while back, which could do
> what you describe, or could stripe/mirror across 3 drives and other
> combination.

Sounds like the RAID1E and RAID5E of some of the IBM ServeRAID controllers...

1E: Works across minimum of 3 drives, with the stripes written as:

Drive: 1 2 3
       a b c
       b c a
       d e f
       e f d

Ie. you still lose half the disk space, but will work over unequal
 number of wrives with still a single drive failure resilience and a full
 speed read.


5E: minimum 4drives, similar story just a tad different (No, I've mislaid
the documentation :()
