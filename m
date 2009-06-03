From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Awful RAID5 random read performance
Date: Tue, 2 Jun 2009 20:57:33 -0500
Message-ID: <20090603015741021.NMNW26412@cdptpa-omta03.mail.rr.com>
References: <87tz30qiyn.fsf@frosties.localdomain>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87tz30qiyn.fsf@frosties.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: 'Goswin von Brederlow' <goswin-v-b@web.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> > That's an average.  For a random seek to exceed that, it's going to have
> to
> > span many cylinders.  Give the container size of a modern cylinder,
> that's a
> > pretty big jump.  Single applications will tend to have their data
> lumped
> > somewhat together on the drive.
> 
> Only at the start, which is usualy when people benchmark. But after a
> while filesystem fragment. Files get distributed all over the disk,
> files themself get spread out as they grow. And suddenly an FS that
> was fine  month ago is too slow.

There can be a lot of application dependent variation, of course, but even
with a fragmented disk, many applications still tend to wind up with their
files clustered together on the disk.  If the application writes each file
once and never updates it, creating many more files as time goes by, then
indeed the database will grow ever more scattered.  Random access files, of
course, may wind up scattered all over the drive, even if there is only one
file use by the app.  If the application tends to update the majority of its
files on a regular basis, however, then the file updates tend to fall in
little pools across the disk, rather than being scattered in a perfectly
random fashion.  One's mileage will definitely vary.

