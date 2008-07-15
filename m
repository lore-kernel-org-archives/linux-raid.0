From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: How to avoid complete rebuild of RAID 6 array (6/8 active devices)
Date: Tue, 15 Jul 2008 16:24:50 +0200
Message-ID: <20080715142450.GA21485@rap.rap.dk>
References: <41931C59-9A91-47A6-A81C-EC14001DA95B@gmail.com> <20080625161357.GH23944@skl-net.de> <18532.50062.63173.620773@notabene.brown> <48680586.609@tmr.com> <g5fam0$8oe$1@ger.gmane.org> <487B7B74.3010903@dgreaves.com> <20080714225816.GS4314@kiste.smurf.noris.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080714225816.GS4314@kiste.smurf.noris.de>
Sender: linux-raid-owner@vger.kernel.org
To: Matthias Urlichs <smurf@smurf.noris.de>
Cc: David Greaves <david@dgreaves.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Jul 15, 2008 at 12:58:16AM +0200, Matthias Urlichs wrote:
> Hi,
> 
> However, even if they do in fact continue to deteriorate, the ability to
> re-map the offending areas and continue gives me an order of magnitude
> more time to deal with the problem.
> 
> In fact, as I said, there may be problems lurking on other disks which I
> just haven't found yet (how often do you read all 5TB of your data?),
> which means that a feature like this is the difference between being
> able to recover and certain data loss, RAID-6 nonwithstanding.

One idea about this - One could read and write the disks perodically,
say once a month. In this way single bit errors that could have evolved
on the disks coule be repaired, as the CRC saves the one bit error, and 
gets it corrected when writing. For a raid - if an error occurs, then
the sound data could be used, and if the error persists after a rewrite
on the bad disk, that data should then be remapped to a sound area on
the drive. Maybe people already have implemented this. SMART data could
also be consulted. 

I thought of badblocks -n to do this, but also raid check could be a
place to do it. When writing ons should of cause take care that nobody
else is writing the same data.  

best regards
keld
