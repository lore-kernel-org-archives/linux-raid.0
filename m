From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10 crashing repeatedly and hard)
Date: Mon, 3 Jan 2005 05:17:16 -0500
Message-ID: <200501031017.j03AHO912799@www.watkins-home.com>
References: <200501030916.j039Gqe23568@inv.it.uc3m.es>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200501030916.j039Gqe23568@inv.it.uc3m.es>
Sender: linux-raid-owner@vger.kernel.org
To: ptb@inv.it.uc3m.es, 'linux raid' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

See notes below with **.

Guy

-----Original Message-----
From: ptb@inv.it.uc3m.es [mailto:ptb@inv.it.uc3m.es] 
Sent: Monday, January 03, 2005 4:17 AM
To: Guy
Subject: Re: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10
crashing repeatedly and hard)

"Also sprach Guy:"
> "Well, you can make somewhere. You only require an 8MB (one cylinder)
> partition."
> 
> So, it is ok for your system to fail when this disk fails?

You lose the journal, that's all.  You can react with a simple tune2fs
-O ^journal or whatever is appropriate.  And a journal is ONLY there in
order to protect you against crashes of the SYSTEM (not the disk), so
what was the point of having the journal in the first place? 

** When you lose the journal, does the system continue without it?
** Or does it require user intervention?

> I don't want system failures when a disk fails,

"don't use a journal then" seems to be the easy answer for you, but
probably "put it on an ultrasafe medium like gold-plated persistent ram"
works better!
**RAM will be lost if you crash or lose power.

Your scenario seems to be that you have the disks of your mirror on the
ame physical system.  That's funamentally dangerous.  They're both
subject to damage when the system blows up.  I don't.  I have an array
node (where the journal is kept), and a local mirror component and a
remote mirror component.

That system is doubled, and each half of the double hosts the others
remote mirror component. Each half fails over to the other.
** So, you have 2 systems, 1 fails and the "system" switches to the other.
** I am not going for a 5 nines system.
** I just don't want any down time if a disk fails.
** A disk failing is the most common failure a system can have (IMO).
** In a computer room with about 20 Unix systems, in 1 year I have seen 10
or so disk failures and no other failures.
** Are your 2 systems in the same state?
** They should be at least 50 miles apart (at a minimum).
** Otherwise if your data center blows up, your system is down!
** In my case, this is so rare, it is not an issue.
** Just use off-site tape backups.
** My computer room is for development and testing, no customer access.
** If the data center is gone, the workers have nowhere to work anyway (in
my case).
** Some of our customers do have failover systems 50+ miles apart.

> so mirror (or RAID5)
> everything required to keep your system running.
> 
> "And there is a risk of silent corruption on all raid systems - that is
> well known."
> I question this....

Why!
** You lost me here.  I did not make the above statement.  But, in the case
of RAID5, I believe it can occur.  Your system crashes while a RAID5 stripe
is being written, but the stripe is not completely written.  During the
re-sync, the parity will be adjusted, but it may be more current than 1 or
more of the other disks.  But this would be similar to what would happen to
a non-RAID disk (some data not written).
** Also with RAID1 or RAID5, if corruption does occur without a crash or
re-boot, then a disk fails, the corrupt data will be copied to the
replacement disk.  With RAID1 a 50% risk of copying the corruption, and 50%
risk of correcting the corruption.  With RAID5, risk % depends on the number
of disks in the array.

> I bet a non-mirror disk has similar risk as a RAID1.  But with a RAID1,
you

The corruption risk is doubled for a 2-way mirror, and there is a 50%
chance of it not being detected at all even if you try and check for it,
because you may be reading from the wrong mirror at the time you pass
over the imperfection in the check.
** After a crash, md will re-sync the array.
** But during the re-sync, md could be checking for differences and
reporting them.
** It won't help correct anything, but it could explain why you may be
having problems with your data.
** Since md re-syncs after a crash, I don't think the risk is double.

Isn't that simply the most naive calculation? So why would you make
your bet?
** I don't understand this.

And then of course you don't generally check at all, ever.
** True, But I would like md to report when a mirror is wrong.
** Or a RAID5 parity is wrong.

But whether you check or not, corruptions simply have only a 50% chancce
of being seen (you look on the wrong mirror when you look), and a 200%
chance of occuring (twice as much real estate) wrt normal rate.
** Since md re-syncs after a crash, I don't think the risk is double.
** Also, I don't think most corruption would be detectable (ignoring a RAID
problem).
** It depends to the type of data.
** Example: Your MP3 collection would go undetected until someone listened
to the corrupt file. 

In contrast, on a single disk they have a 100% chance of detection (if
you look!) and a 100% chance of occuring, wrt normal rate.
** Are you talking about the disk drive detecting the error?
** If so, are you referring to a read error or what?
** Please explain the nature of the detectable error.

> know when a difference occurs, if you want.

How?
** Compare the 2 halves or the RAID1, or check the parity of RAID5.
Peter

** Guy

