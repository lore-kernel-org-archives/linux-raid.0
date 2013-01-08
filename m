From: Ross Boylan <ross@biostat.ucsf.edu>
Subject: Re: How do I tell which disk failed?
Date: Tue, 08 Jan 2013 15:13:08 -0800
Message-ID: <1357686788.3484.58.camel@markov.biostat.ucsf.edu>
References: <1357610701.16366.13.camel@corn.betterworld.us>
	 <50EBAC5D.8080000@hardwarefreak.com>
	 <1357628351.16366.86.camel@corn.betterworld.us>
	 <02B6762C-3755-4CE3-9AB1-A48D3384CACB@colorremedies.com>
	 <1357631996.16366.139.camel@corn.betterworld.us>
	 <3D8A55DE-C4A8-4639-A662-CD3FF228230F@colorremedies.com>
	 <1357682055.3484.34.camel@markov.biostat.ucsf.edu>
	 <44902B51-EBD5-4D22-BC70-5D60F307CC08@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <44902B51-EBD5-4D22-BC70-5D60F307CC08@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: ross@biostat.ucsf.edu, "linux-raid@vger.kernel.org Raid" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, 2013-01-08 at 15:38 -0700, Chris Murphy wrote:
> On Jan 8, 2013, at 2:54 PM, Ross Boylan <ross@biostat.ucsf.edu> wrote:
> > 
> > I manually specified the current layout of the bigger disks (sdb and c);
> > at least some of the time I specified the exact sector. I picked 34
> > because that seems to be the traditional offset for the first partition
> > (and the one my tool generated when I gave it sizes in grosser units
> > than sectors or told it to start at 0).
> 
> Today 34 is both old and incorrect, so you need to redo the layout.
> 
> > Apparently some disks do a logical to physical remap that includes an
> > offset as well as a change in the sector size.  Should I check for that,
> > or should I just assume that I should start my partitions on sectors
> > that are multiples of 8?
> 
> I know of no disks that change the sector size. It's always 512 logical, 4096 physical for reds. There are supposed to be native 4Kn drives between now and soon, but they aren't switchable between 512e and 4Kn. As for the offset, that still won't work because it'll change the position of your partition map so you'd have to start over anyway, even if it were available, which I don't think it is on a red.
> 
I didn't mean that the disk changed its sector size dynamically, just
that, e.g., it might have physical sectors of 4k but report that it has
(logical) sectors of 512.

I'm not sure what you mean by the offset working.  I'm referring to the
fact that for some drives when you ask for logical sector n you actually
get physical sector n+1, n-2, or something like that.  This implies that
aligning on the logical sectors (meaning the ones the drive reports out)
might misalign on the physical ones.
> So you just need to use a more recent partition tool and repartition the disks correctly.
Correctly = start at multiples of 8?
> 
> 
> 
> 
> 
> > 
> > You also asked what I meant by chatter in the logs about sdb.  Here are
> > some entries from shortly before the system locked up:
> > Jan  6 03:45:24 markov smartd[5368]: Device: /dev/sda, SMART Usage Attribute: 190 Airflow_Temperature_Cel changed from 64 to 65
> > Jan  6 03:45:24 markov smartd[5368]: Device: /dev/sda, SMART Usage Attribute: 194 Temperature_Celsius changed from 36 to 35
> > Jan  6 03:45:25 markov smartd[5368]: Device: /dev/sdb, SMART Usage Attribute: 194 Temperature_Celsius changed from 108 to 109
> 
> smartmontools 5.38 is old, and this red drive isn't in its database, so the data may be interpreted incorrectly. 108 C is very hot. But I wouldn't totally discount it when the drives are all busy on a resync, if you get wildly different Raw_Values for this attribute between sdb and sdc since they're the same drive model.
> 
That report was from before the system crash, when it was probably doing
very little, although disk intensive maintenance such as backups or
indexing the mail spool might have been happening.

I thought 108 was the scaled smart score, which is between 0 and 255
with higher being better.  The raw value of 45 seemed more plausible as
an actual temperature, though I guess there's no guarantee of that.

sdb and sdc have similar numbers for Temperature_Celsius.

On the logs and sign of disk failure, it's quite possible I don't know
what I'm looking for.  Given their size and the fact that the drive
failure seems clear, I think I'll  spare you all the gory details.

Ross


