From: Louis-David Mitterrand <vindex@apartia.org>
Subject: Re: recovering after a /dev/sda failure on raid1
Date: Mon, 5 Aug 2002 14:36:55 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020805143655.A541@apartia.org>
References: <20020801144922.GA5284@apartia.org> <15690.63749.164322.929689@notabene.cse.unsw.edu.au> <20020805092641.GA577@apartia.org> <15694.27770.60339.958313@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <15694.27770.60339.958313@notabene.cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Aug 05, 2002 at 10:15:54PM +1000, Neil Brown wrote:
> On Monday August 5, vindex@apartia.org wrote:
> > 
> > FWIW the disk that is malfunctioning is a 3-month-old Fujitsu 15k 36G
> > (MAM3367MP) which is an expensive server-grade disk. The reason I
> > selected Fujitsu was because of reported quality problems on IBM disks
> > and Fujitsu's good reputation on SCSI (their IDE line is bad however).
> > I am looking for informed opinions on these disks and recommendations
> > for future purchases. What are the most reliable SCSI disks out there?
> > 
> > It must be: fast, affordable, reliable, (select any two ;-)
> 
> Somehow, I wish you hadn't said that.....

Sorry, but I thoroughly checked the disk after taking it off the server
and a lot of sectors are damaged, reiserfsck quits with a "can't read",
and the spindle makes bad noises.

> I just recently commissioned a fileserver with 14 Fujitsu MAM3367MC drives.
> I wander what the difference between P and C is...

It must be for 68 or 80 pin (ours is a 68).

> Previously we have used Seagates which have seemed quite reliable.
> The only real problems that we have had is with the IBM IDE DeathStars
> (oops, I meant DeskStars.  Naughty keyboard).

Had a sorry experience with these as well, a 75 G.

-- 
ldm@apartia.org 
