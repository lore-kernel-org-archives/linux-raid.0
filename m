From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Backup Server RAID Array Event Notification
Date: Fri, 10 Jun 2011 12:32:00 -0500
Message-ID: <EA.17.20202.21552FD4@cdptpa-omtalb.mail.rr.com>
References: <34.8F.15242.4FE61FD4@cdptpa-omtalb.mail.rr.com>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <34.8F.15242.4FE61FD4@cdptpa-omtalb.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'NeilBrown' <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> > "mdadm --monitor" does not monitor RAID0 or Linear arrays.  There is
> > nothing
> > to see.  Nothing can fail, they don't rebuilt, they are really just AID,
> > not
> > RAID.

	I've been thinking about this.  It's true they are just AID, but
they most certainly can fail.  If the array truly disappears, perhaps
because a drive fails, I certainly should be notified of it.

> 	That would make sense if I had started the monitor deamon and it had
> sent the e-mail, but the monitor has been running for nearly two days,
> since
> the system was rebooted.  Why send the message nearly a day after the
> deamon
> is started, and why send it more than once (for each array)?
> 
> 	By the same token, why did it wait nearly 8 hours and then again
> more than a day and a half after the array was created to send the
> messages,
> instead of immediately after it was created?
> 
> 	This suggests I am going to be treated to a pair of spurious e-mails
> every day or so telling me the device has disappeared, when it is
> perfectly
> good.  After a few months of that, what happens when one of the devices
> really does disappear?  We all know what happens to the system that cries,
> "Wolf!" all the time.

	Yeah, it looks like it's going to send this message out once a day
for both arrays.  Mdadm sent out another pair of e-mails at 07:44 this
morning. Is no one else seeing this with RAID0 arrays?  Is there some way I
can stop it without impacting any real notifications?  I could intercept the
message in the script run by mdadm to send the e-mail, but if I do, I fear I
might also incorrectly trash a real error message.  I don't suppose
"Wrong-Level" would ever appear in a valid notification for a properly
configured system, would it?  If not, I suppose I could grep for
"Wrong-Level" in the e-mail packet and trash it if the text is found.

