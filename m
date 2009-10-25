From: Thomas Fjellstrom <tfjellstrom@shaw.ca>
Subject: Re: Is My Data DESTROYED?!
Date: Sun, 25 Oct 2009 10:58:52 -0600
Message-ID: <200910251058.52530.tfjellstrom@shaw.ca>
References: <627672.61054.qm@web38803.mail.mud.yahoo.com>
Reply-To: tfjellstrom@shaw.ca
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <627672.61054.qm@web38803.mail.mud.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: adfas asd <chimera_god@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun October 25 2009, you wrote:
> --- On Sun, 10/25/09, Leslie Rhorer <lrhorer@satx.rr.com> wrote:
> >     Half the files I have lost on my video
> > system were due to my
> > personal errors.  Absolutely none were due to drive
> > failures.  By a very
> > wide margin, the most common cause of data loss is human
> > error.  EVERY
> > SINGLE FILE THAT HAS EVER BEEN LOST SINCE THE FIRST DIGITAL
> > COMPUTER WAS
> > BUILT HAS BEEN DUE TO THERE NOT BEING A VALID BACKUP.
> 
> Remember:  I, am not you.  I am trying to tell you *my* actual experience.

Oh believe us, you will learn ;)

> >     Here is the e-mail sent by the daily
> > system backup:
> >     What's obscure about that?
> 
> Well, it doesn't say for dead-bolt sure that there has been a backup and
>  *full*incontravertible*successful*verify*.  If it does, it's not clear. 
>  And what does it take to set up this emailed report?  And what backup
>  system/script was used?
> 
> >  It's also a simple matter to run a
> > compare between the two systems.  One can compare
> > every single file, or for
> > brevity one can easily compare only the most recently
> > created files.
> 
> Yes yes, but how?

diff in binary mode? or maybe difftree, or a tool like it.

> > > I can imagine setting up a fancy-pants backup
> > > system then going about my life, and some quirk
> >
> > happens on the next update
> >
> > > which subtlely hoses my exotic backup system.  It
> >
> > is desirable to have
> >
> > > bolt-tight assurance of backed-up data.  (And
> >
> > please don't bore us with
> >
> > > 'nothing is for sure')
> >
> >     Subtlely?  Such a thing is no more
> > likely (less so, in fact) with
> > the backup system than with the main system.  And what
> > is with the
> > characterization "exotic"?  Your backup system should
> > be as plain vanilla as
> > a system gets.  Load Debian (or whatever) with mail
> > support, load the
> > packages for NUT, rsync and ssh, configure them, and you're
> > done.
> 
> Pfffff....
> I don't understand how NUT plays into this.

Don't tell me you don't have a UPS :o

> >  Create
> > the wakeup / backup script on the main system, and you're
> > on your way.
> 
> Wakeup script?  What sort of backup script?

My cron scripts call a little script I wrote to use wakeonlan to wake up any 
machine that might be asleep before trying to backup.

> I gather that very few have
>  ever set up a comprehensive remote NAS backup system like this.

Its hardly comprehensive, and I'm sure plenty of people have done similar 
things.

Heck, I do weekly full backups to DVDR atm, and will soon add an entire NAS 
backup array. In addition to the daily incremental.

> > > Also I've noticed rsync mentioned several times.
> >
> > This seems to have
> >
> > > facilities for incremental backups, but I've also read
> >
> > that it is non-
> >
> > > secure over networks and that we should use scp
> >
> > instead.
> >
> >     It's secure if you use ssh with
> > passphraseless keys as its transfer
> > mechanism.  Why are you worried about it if this is a
> > home LAN, though?  How
> > is someone gong to sniff your LAN, especially the link
> > between the two
> > hosts?
> 
> I am told that use of OpenSSH vastly limits the bandwidth of the
>  connection, due to encryption overhead.  Backups could cost more than 24
>  hours a day, and/or cut into CPU cycles needed for commercial-flagging. 
>  So I'm looking for secure alternatives.

It's plenty fast.

> And no I'm not too concerned with someone sniffing my LAN, but if practical
>  security can be had I always use it.  For example I set up reverse SSH
>  tunnels for MythTV, MySQL, and Squid.  No it's not mandatory, and it is
>  difficult, but it is best-practice.
> 
> > Unnecessary security
> > notwithstanding, however, ssh with passphraseless keys is a
> > great way to
> > manage the remote system, so I suggest implementing it
> > anyway.
> 
> Naturally I do, with the built-in security of NX. (nomachine.com)
> 
> >     Sure.  Lots of them.  I can't
> > think of any more straightforward than
> > rsync, though.
> 
> Lots?  OK, I am asking for alternatives.
> 

The only one I found I like is rsnapshot. It happens to use rsync under the 
hood. lets me setup hourly, daily, weekly, and monthly incrementals, and every 
week I run a custom script that creates one or more ISOs out of the latest 
daily incremental backup (rsnapshot stores each incremental as a full tree 
using hard links, so it LOOKS like a full backup, but is still just a partial 
backup).

> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
Thomas Fjellstrom
tfjellstrom@shaw.ca
