From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Backup Server RAID Array Event Notification
Date: Thu, 9 Jun 2011 20:10:11 -0500
Message-ID: <34.8F.15242.4FE61FD4@cdptpa-omtalb.mail.rr.com>
References: <20110610071441.796e5f78@notabene.brown>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110610071441.796e5f78@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: 'NeilBrown' <neilb@suse.de>
Cc: 'Roman Mamedov' <rm@romanrm.ru>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of NeilBrown
> Sent: Thursday, June 09, 2011 4:15 PM
> To: lrhorer@satx.rr.com
> Cc: 'Roman Mamedov'; linux-raid@vger.kernel.org
> Subject: Re: Backup Server RAID Array Event Notification
> 
> On Thu, 9 Jun 2011 14:01:34 -0500 "Leslie Rhorer" <lrhorer@satx.rr.com>
> wrote:
> 
> > > -----Original Message-----
> > > From: Roman Mamedov [mailto:rm@romanrm.ru]
> > > Sent: Thursday, June 09, 2011 1:47 PM
> > > To: lrhorer@satx.rr.com
> > > Cc: linux-raid@vger.kernel.org
> > > Subject: Re: Backup Server RAID Array Event Notification
> > >
> > > On Thu, 9 Jun 2011 13:35:59 -0500
> > > "Leslie Rhorer" <lrhorer@satx.rr.com> wrote:
> > >
> > > >
> > > > 	After I created a pair of two member RAID1 arrays and then
> added
> > > > them as members to a RAID6 array, I am now getting messages similar
> to
> > > the
> > > > following, complaining of "Wrong-level" issues.  When I check the
> RAID6
> > > > array, however, it is clean and both RAID1 members are still there.
> > > When I
> > > > check both RAID1 arrays, they show clean with no events.  I am
> running a
> > > > compare between all the data on this machine and its mirror (this is
> a
> > > > backup machine).  So far everything looks good.  What does this
> imply?
> > > Is
> > > > there something about which I should be worried?
> > >
> > > You said RAID1 twice, and your mdadm --detail doesn't agree with you
> and
> > > says
> > > "raid0" twice. Maybe you mistakenly used RAID1 instead of RAID0
> somewhere
> > > else as well, and the WrongLevel message is trying to tell you that?
> >
> > 	No, that was just a typo.  (OK, three typos) I meant "RAID0".  The
> > RAID0 members are all 1T drives.  The RAID6 array is made of 1.5T
> members.
> > In order to use the 1T drives on the RAID6 array, I have to combine them
> > into 2T arrays, which then can be used as members of the RAID6 array.
> If
> > md10 and md11 were RAID1 arrays, they would only be 1T in extent, and
> could
> > not be members of md0.
> >
> 
> "mdadm --monitor" does not monitor RAID0 or Linear arrays.  There is
> nothing
> to see.  Nothing can fail, they don't rebuilt, they are really just AID,
> not
> RAID.

	Well, OK.  So why does it report anything at all?
> 
> So if it thinks that it was asked to monitor a RAID0 it pretends that it
> has
> disappeared with reason "Wrong Level".
> So if you explicitly ask it to monitor a RAID0, it won't and it will tell
> you
> why.

	That would make sense if I had started the monitor deamon and it had
sent the e-mail, but the monitor has been running for nearly two days, since
the system was rebooted.  Why send the message nearly a day after the deamon
is started, and why send it more than once (for each array)?

	By the same token, why did it wait nearly 8 hours and then again
more than a day and a half after the array was created to send the messages,
instead of immediately after it was created?

	This suggests I am going to be treated to a pair of spurious e-mails
every day or so telling me the device has disappeared, when it is perfectly
good.  After a few months of that, what happens when one of the devices
really does disappear?  We all know what happens to the system that cries,
"Wolf!" all the time.

> If you only implicitly ask with e.g. "mdadm --monitor --scan" with a RAID0
> listing in mdadm.conf it probably shouldn't give the message as it might
> be confusing... but it does.

	I'm not sure I follow.

> Or maybe the message is just confusing and I should change it.
> 
> Or something.

	Well that's definite.  :-)

