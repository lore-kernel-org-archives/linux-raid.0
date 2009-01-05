From: "NeilBrown" <neilb@suse.de>
Subject: Re: Need urgent help in fixing raid5 array
Date: Tue, 6 Jan 2009 09:53:43 +1100 (EST)
Message-ID: <879ae2ec7c5524fd9fa9841245772ab6.squirrel@neil.brown.name>
References: <451872.61166.qm@web30802.mail.mud.yahoo.com>
    <alpine.DEB.1.10.0901011039110.9903@p34.internal.lan>
    <467705.96388.qm@web30807.mail.mud.yahoo.com>
    <alpine.DEB.1.10.0901011328380.17888@p34.internal.lan>
    <344038.60917.qm@web30808.mail.mud.yahoo.com>
    <18786.34165.639790.37753@notabene.brown>
    <546794.45786.qm@web30802.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <546794.45786.qm@web30802.mail.mud.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Myers <mikesm559@yahoo.com>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org, john lists <john4lists@gmail.com>
List-Id: linux-raid.ids

On Tue, January 6, 2009 9:22 am, Mike Myers wrote:
> Thanks!  I see what you are doing here.  So since none of these commands
> actually change the underlying data, if I get the order right. the array
> will come up and the LVM superblock will be visible, and then I can try
> and bring the filesystem online?  If I get the order wrong, I can just try
> it again with another combination.  Do I have that right?

Exactly, yes.

>
> I should probably print out all the existing metadata and save it since
> the data will be wiped out by the create.

Certainly a good idea.

>
> How could the drives get the bad metadata on them>  I've played with
> software raid for about 4 years and have seen seen something this strange.

I really cannot think how they could get the particular bad metadata that
they did.  "mdadm --add" will change the metadata, but only to make the
device appear to be a spare, which isn't the case here.
"mdadm --assemble --force" can re-write the metadata, but again I cannot
imagine it making the particular change that has been made.  Maybe there
is a bug in there somewhere.

NeilBrown

