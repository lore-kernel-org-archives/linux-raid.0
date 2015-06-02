From: keld@keldix.com
Subject: Re: Raid 10 far 2 layout clarification.
Date: Tue, 2 Jun 2015 19:16:27 +0200
Message-ID: <20150602171627.GA23072@www5.open-std.org>
References: <BLU436-SMTP2133418C1B434E36DB60B7198700@phx.gbl> <BLU436-SMTP109DF1509BE353AA10DD09E98700@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <BLU436-SMTP109DF1509BE353AA10DD09E98700@phx.gbl>
Sender: linux-raid-owner@vger.kernel.org
To: "Wilson, Jonathan" <piercing_male@hotmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Nov 26, 2014 at 10:26:47PM +0000, Wilson, Jonathan wrote:
> On Wed, 2014-11-26 at 18:30 +0000, Wilson, Jonathan wrote:
> > I just wanted to double check something before I return a failing SSD.
> > 
> > I set up a 2 partition raid 10 in far 2 mode... from what I understood
> > it allows a mirror and stripe to exist on a 2 drive set up, so that it
> > gets the benefits of stripe with the redundancy of mirror.
> 
> I should clarify, two partitions on two different SSD's not the same
> SSD :-/   /sda4 and /sdb4
> 
> > 
> > I just wanted to double check this was correct and if so confirm that I
> > can fail and remove one of the drives.
> > 
> > Obvioulsy I will have to drop one of the drives anyway/somehow but if it
> > wont hold up/keep running after failing one drive then I will have to
> > deal with it in another way, probably a quick clone onto a spare disk as
> > a stop gap measure until I get the replacement, as this array is my OS
> > disk.

Yes, you can safely remove one of the SSDs.

For SSDs where access time is very small, there is not a big win with striping,
wwhich it is one of the features of the raid10 far layout. Similarily
the penalties of moving address for reads or writes are also very small.

Best regards
Keld
