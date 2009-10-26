From: Thomas Fjellstrom <tfjellstrom@shaw.ca>
Subject: Re: Is My Data DESTROYED?!
Date: Mon, 26 Oct 2009 12:21:23 -0600
Message-ID: <200910261221.23711.tfjellstrom@shaw.ca>
References: <755966.28481.qm@web38802.mail.mud.yahoo.com>
Reply-To: tfjellstrom@shaw.ca
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <755966.28481.qm@web38802.mail.mud.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: adfas asd <chimera_god@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon October 26 2009, adfas asd wrote:
> You know, I was worried that my main HTPC would be overloaded, with Myth
>  commercial flagging, transcoding, and storage server operations like ssh
>  encryption and checksumming.
> 
> But clearly storage server operations should be carried out by the storage
>  server.  This'll be a little qbox-f mini-ITX system in the garage in case
>  of fire or theft.  So I could iSCSI the HTPC's RAID0 volume to the storage
>  server, hopefully through an SSH tunnel, and the storage server could
>  merrily do the rsync, checksumming, and whatever operations, while the
>  HTPC does its proper jobs.  When not in use the storage server would
>  sleep.  Sure, the storage server will be just an Atom or Geode, but as
>  long as its operations don't take more than 24 hours it's OK.

Issue there, you can not mount a regular filesystem twice. Which is what this 
plan would entail. It'd be better if you just used rsync's native ssh support 
to log in and copy entire directory trees of data.

The initial copy will take a while, but rsync will only copy files that are 
new, or have changed by default, so subsequent rsync runs won't take very long 
over GbE at all.

on your backup box, you can just run:
rsync -a user@mythtvbox:/mnt/raid0 /mnt/backup

which tells rsync to copy all files under 'mythtvbox's /mnt/raid0 dir 
recursively to /mnt/backup keeping all metadata including access times and 
what not. (-a means archive, this way it will know when files have changed on 
the remote mythtv box)

hth.

> --- On Mon, 10/26/09, adfas asd <chimera_god@yahoo.com> wrote:
> > Thanks Doug, this was very
> > helpful.  I had seen the checksum option, but sometimes
> > something doesn't register as useful unless there is
> > independent confirmation.
> >
> > And understand that I am not 'shooting down' anything to be
> > obstinate;  I am testing and probing for the -best-
> > solution and systems, and hoping something good pops
> > out.  Some of the sensitive will take offense, but I
> > suggest that all benefit when we get substantive responses
> > such as yours.
> >
> > I had tried afio and cpio in the past, but frankly could
> > not figure it out to use.  Seems like a good
> > concept.  Maybe it's been made more accessible by now,
> > or maybe I'm not as dumb.  BTW, I am a real estate
> > developer, not a coder.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
Thomas Fjellstrom
tfjellstrom@shaw.ca
