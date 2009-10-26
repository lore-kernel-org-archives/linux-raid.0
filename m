From: adfas asd <chimera_god@yahoo.com>
Subject: Re: Is My Data DESTROYED?!
Date: Mon, 26 Oct 2009 05:22:03 -0700 (PDT)
Message-ID: <835545.17492.qm@web38807.mail.mud.yahoo.com>
References: <4AE4F36A.9070504@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AE4F36A.9070504@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks Doug, this was very helpful.  I had seen the checksum option, but sometimes something doesn't register as useful unless there is independent confirmation. 

And understand that I am not 'shooting down' anything to be obstinate;  I am testing and probing for the -best- solution and systems, and hoping something good pops out.  Some of the sensitive will take offense, but I suggest that all benefit when we get substantive responses such as yours.

I had tried afio and cpio in the past, but frankly could not figure it out to use.  Seems like a good concept.  Maybe it's been made more accessible by now, or maybe I'm not as dumb.  BTW, I am a real estate developer, not a coder.


--- On Sun, 10/25/09, Doug Ledford <dledford@redhat.com> wrote:
> That being said, you can in fact have what you want by
> simply telling
> rsync to use file MD5 sums to determine which files need
> synced from the
> master to the slave instead of file size/date data. 
> That's right, you
> can, by passing a simple flag to rsync, cause it to read
> each and every
> single file, generate an md5sum of the file, and use that
> to determine
> if the file needs backed up or if the file already on the
> backup machine
> is identical.  In other words, this mode of operation
> is *superior* to
> the raid solution your comparing it against.
> 
> But, this all raises a very simple point that I'm surprised
> someone else
> hasn't brought up yet.  If you had merely looked at
> the rsync man page,
> or even just the rsync help information on the command
> line, you would
> have seen this for yourself.  So, might I suggest that
> before you spend
> to much time trying to shoot down what is probably a very
> workable
> solution for you, that you actually *LOOK INTO* that
> solution instead of
> letting prejudice and ignorance drive your decision.
> 
> > And what does it take to set up this emailed report?
> 
> Run rsync in a cron job and *don't* redirect rsync's output
> to /dev/null
> and you will automatically get these emails (assuming that
> you already
> redirect emails to root to your own personal email
> account).
> 
> > And what backup system/script was used?
> 
> Rsync is it's own backup system when used as such, nothing
> else is
> needed.  You essentially create a cron job to run
> rsync, and your entire
> script consists of simply getting the rsync command fine
> tuned to your
> particular application.  Here's an example of an rsync
> cron job I use to
> mirror Fedora repos to my local server:
> 
> [root@firewall ~]# more /etc/cron.daily/sync_fedora
> #!/bin/bash
> #
> # Only used on rawhide
> 
> cd /srv/Fedora/rawhide
> [ -f .syncing ] && exit 0 || touch .syncing
> for arch in x86_64 i386 ppc; do
>     rsync -acq --delete
> rsync://fedora.secsup.org/fedora/linux/development/$arch/os/
> $arch
>     if [ $arch = "x86_64" ]; then
>         ln
> $arch/Packages/*.noarch.rpm i386/Packages >/dev/null
> 2>&1
>         ln
> $arch/Packages/*.noarch.rpm ppc/Packages >/dev/null
> 2>&1
>         ln
> $arch/Packages/*.i[356]86.rpm i386/Packages >/dev/null
> 2>&1
>     fi
> done
> rm .syncing
> 
> [root@firewall ~]#
> 
> Note that because I use the -q flag to rsync, I don't get
> nightly emails
> unless something goes wrong.
> 
> > 
> >>  It's also a simple matter to run a
> >> compare between the two systems.  One can
> compare
> >> every single file, or for
> >> brevity one can easily compare only the most
> recently
> >> created files.
> > 
> > Yes yes, but how?
> 
> RTFM please.
> 
> >>> Also I've noticed rsync mentioned several
> times. 
> >> This seems to have
> >>> facilities for incremental backups, but I've
> also read
> >> that it is non-
> >>> secure over networks and that we should use
> scp
> >> instead.
> >>
> >>     It's secure if you use ssh
> with
> >> passphraseless keys as its transfer
> >> mechanism.  Why are you worried about it if
> this is a
> >> home LAN, though?  How
> >> is someone gong to sniff your LAN, especially the
> link
> >> between the two
> >> hosts?
> > 
> > I am told that use of OpenSSH vastly limits the
> bandwidth of the connection, due to encryption
> overhead.  Backups could cost more than 24 hours a day,
> and/or cut into CPU cycles needed for
> commercial-flagging.  So I'm looking for secure
> alternatives.
> > 
> > And no I'm not too concerned with someone sniffing my
> LAN, but if practical security can be had I always use
> it.  For example I set up reverse SSH tunnels for
> MythTV, MySQL, and Squid.  No it's not mandatory, and
> it is difficult, but it is best-practice.
> 
> Might I suggest a little less "so I'm told" and a little
> more "so I
> tried this out and this is what I got...".  In this
> particular case, if
> you are worried about the poor authentication of rsync
> without ssh, but
> concerned with the overhead of encrypting all the data
> transferred, then
> why not just set up ssh so that it does encryptionless data
> transfer
> between these two machines?  Then you get the benefit
> of the improved
> authentication strength of ssh, but not the overhead of the
> encryption
> on the link.  But, in truth, as long as you aren't
> running an atom CPU
> or something like that, you should have more than enough
> CPU horsepower
> to encrypt a gigabit link's worth of data transfer. 
> And especially if
> you choose to use the md5sum comparisons in rsync, your
> machines will be
> far busier just reading the data from disk and doing
> md5sums of the
> entire array, so worrying about the CPU overhead of the
> encryption is
> kinda silly.
> 
> -- 
> Doug Ledford <dledford@redhat.com>
>               GPG KeyID:
> CFBFF194
>           http://people.redhat.com/dledford
> 
> Infiniband specific RPMs available at
>           http://people.redhat.com/dledford/Infiniband
> 
> 


      
