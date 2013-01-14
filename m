From: Thomas Fjellstrom <thomas@fjellstrom.ca>
Subject: Re: recommended way to add ssd cache to mdraid array
Date: Mon, 14 Jan 2013 15:00:49 -0700
Message-ID: <201301141500.49197.thomas@fjellstrom.ca>
References: <201212212357.19292.thomas@fjellstrom.ca> <9974543B-24D0-46E9-9852-09DE1C2F6D12@colorremedies.com> <50F3501B.30002@turmel.org>
Reply-To: thomas@fjellstrom.ca
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50F3501B.30002@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Chris Murphy <lists@colorremedies.com>, linux-raid Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun Jan 13, 2013, Phil Turmel wrote:
> On 01/13/2013 06:20 PM, Chris Murphy wrote:
[snip]
> >> One last point bears repeating:  MD is *not* a backup system,
> >> although some people leverage it's features for rotating off-site
> >> backup disks. Raid arrays are all about *uptime*.  They will not
> >> save you from accidental deletion or other operator errors.  They
> >> will not save you if your office burns down.  You need a separate
> >> backup system for critical files.
> > 
> > Yeah and that's why I'm sorta leery of this RAID 6 setup in the home.
> > I think that people are reading that the odds of an array failure
> > with RAID 5 are so high that they are better off adding one more
> > drive for dual-parity, and *still* not having a real backup and
> > restore plan. As if the RAID 6 is the faux-backup plan.
> > 
> > Some home NAS's, with BluRay vids, are so big that people just either
> > need to stop such behavior, or get a used LTO 2 or 3 drive for their
> > gargantuous backups.
> 
> Well, for me, such material on hard drives *are* the backups.  I use
> "par2" for big backup files, not MD raid.  I also skip backups for my
> Hi-Def MythTV recordings.  Just not valuable enough.

Yeah, I learned a while back to make proper backups. My very important files 
are backed up from each machine every day to a raid1, which is then synced up 
to a remote machine. Once the new array is up, the backups will have another 
location to copy to, as well as the not so important media files will have a 
backup (some 3TB drives and a few of the old 1TB drives in a linear concat 
'array'). I may add another remote backup location in the future, I just 
haven't decided who to go with.
 
> Phil
> --



-- 
Thomas Fjellstrom
thomas@fjellstrom.ca
