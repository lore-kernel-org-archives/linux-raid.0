From: adfas asd <chimera_god@yahoo.com>
Subject: Re: Is My Data DESTROYED?!
Date: Tue, 27 Oct 2009 07:32:52 -0700 (PDT)
Message-ID: <812581.75103.qm@web38808.mail.mud.yahoo.com>
References: <200910261221.23711.tfjellstrom@shaw.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200910261221.23711.tfjellstrom@shaw.ca>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks.  But what I have in mind is serving the HTPC's array (with videos)to the storage server via iSCSI.  Hopefully the array can be mounted on the HTPS and still be served to the remote storage server by iSCSI?

--- On Mon, 10/26/09, Thomas Fjellstrom <tfjellstrom@shaw.ca> wrote:
> On Mon October 26 2009, adfas asd
> wrote:
> > You know, I was worried that my main HTPC would be
> overloaded, with Myth
> >  commercial flagging, transcoding, and storage
> server operations like ssh
> >  encryption and checksumming.
> > 
> > But clearly storage server operations should be
> carried out by the storage
> >  server.  This'll be a little qbox-f
> mini-ITX system in the garage in case
> >  of fire or theft.  So I could iSCSI the
> HTPC's RAID0 volume to the storage
> >  server, hopefully through an SSH tunnel, and the
> storage server could
> >  merrily do the rsync, checksumming, and whatever
> operations, while the
> >  HTPC does its proper jobs.  When not in use
> the storage server would
> >  sleep.  Sure, the storage server will be
> just an Atom or Geode, but as
> >  long as its operations don't take more than 24
> hours it's OK.
> 
> Issue there, you can not mount a regular filesystem twice.
> Which is what this 
> plan would entail. It'd be better if you just used rsync's
> native ssh support 
> to log in and copy entire directory trees of data.
> 
> The initial copy will take a while, but rsync will only
> copy files that are 
> new, or have changed by default, so subsequent rsync runs
> won't take very long 
> over GbE at all.
> 
> on your backup box, you can just run:
> rsync -a user@mythtvbox:/mnt/raid0 /mnt/backup
> 
> which tells rsync to copy all files under 'mythtvbox's
> /mnt/raid0 dir 
> recursively to /mnt/backup keeping all metadata including
> access times and 
> what not. (-a means archive, this way it will know when
> files have changed on 
> the remote mythtv box)



      
