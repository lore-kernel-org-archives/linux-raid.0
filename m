From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: recovering after a /dev/sda failure on raid1
Date: Mon, 5 Aug 2002 22:15:54 +1000 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15694.27770.60339.958313@notabene.cse.unsw.edu.au>
References: <20020801144922.GA5284@apartia.org>
	<15690.63749.164322.929689@notabene.cse.unsw.edu.au>
	<20020805092641.GA577@apartia.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Louis-David Mitterrand on Monday August 5
To: Louis-David Mitterrand <vindex@apartia.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday August 5, vindex@apartia.org wrote:
> 
> FWIW the disk that is malfunctioning is a 3-month-old Fujitsu 15k 36G
> (MAM3367MP) which is an expensive server-grade disk. The reason I
> selected Fujitsu was because of reported quality problems on IBM disks
> and Fujitsu's good reputation on SCSI (their IDE line is bad however).
> I am looking for informed opinions on these disks and recommendations
> for future purchases. What are the most reliable SCSI disks out there?
> 
> It must be: fast, affordable, reliable, (select any two ;-)

Somehow, I wish you hadn't said that.....

I just recently commissioned a fileserver with 14 Fujitsu MAM3367MC drives.
I wander what the difference between P and C is...

Previously we have used Seagates which have seemed quite reliable.
The only real problems that we have had is with the IBM IDE DeathStars
(oops, I meant DeskStars.  Naughty keyboard).

As far as SCSI drives, I have no significant experiences of
unreliability, and I hope to keep it that way.

NeilBrown
