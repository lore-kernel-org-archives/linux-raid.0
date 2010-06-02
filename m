From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: RAID Configuration For New Home Server
Date: Wed, 2 Jun 2010 01:33:19 -0500
Message-ID: <C5.28.17309.03BF50C4@cdptpa-omtalb.mail.rr.com>
References: <AANLkTinjHWth9B79IimV3g-U9CNUu1tHRiyf6Ya-7Yys@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTinjHWth9B79IimV3g-U9CNUu1tHRiyf6Ya-7Yys@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'Simon Matthews' <simon.d.matthews@gmail.com>
Cc: 'Mdadm' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> On Tue, Jun 1, 2010 at 10:08 AM, Carlos Mennens <carloswill@gmail.com>
> wrote:
> > I built a new home server this weekend & am ready to load my O.S.
> > (Arch Linux) on it today. It has 4 x 320 GB Seagate Barracuda's
> > (SATA). I don't really have a specific function of this server at home
> > beyond holding my data reliably and decent read / write performance.
> > My question to you experts is what do you recommend I configure for
> > this particular configuration? Should I run RAID 5 or RAID 10? To
> > spare or not to spare? I really appreciate any best suggestions for
> > general over all function on this matter.
> 
> How about 2 drives in a RAID0 or LVM configuration and the other two
> in another machine and used for backups?

	If down time is not an issue, and he is comfortable living with a
single unprotected system in the event of a drive failure, that's not a bad
solution, at all, especially given the small size of his arrays.  If it were
me, I would invest in at least one more drive to make one of the arrays a
RAID5 and the other a RAID0 (or LVM).  That way, in the event of a drive
failure, he is still left with redundancy of one form or another.
Additionally, if he makes the primary array the RAID5 array, the no single
drive failure will take his server offline, and he can recover with no down
time.  If performance is more important than zero down time, then he could
make his backup the RAID5 array.  That way he doesn't have to worry so much
about a second drive failure while he is restoring data to his failed
primary array after it is repaired.  Indeed, a RAID5 array backed up by an
LVM volume is precisely what I ran before my primary server exceeded 4T of
data.

