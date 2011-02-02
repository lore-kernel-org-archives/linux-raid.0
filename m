From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: RAID 5 - One drive dropped while replacing another
Date: Wed, 2 Feb 2011 00:20:53 -0600
Message-ID: <01.C1.13137.7C7F84D4@cdptpa-omtalb.mail.rr.com>
References: <20110202043605.593f0c5c@natsu>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110202043605.593f0c5c@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: 'Roman Mamedov' <rm@romanrm.ru>, 'Bryan Wintermute' <bryanwintermute@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of Roman Mamedov
> Sent: Tuesday, February 01, 2011 5:36 PM
> To: Bryan Wintermute
> Cc: linux-raid@vger.kernel.org
> Subject: Re: RAID 5 - One drive dropped while replacing another
> 
> On Tue, 1 Feb 2011 15:27:50 -0800
> Bryan Wintermute <bryanwintermute@gmail.com> wrote:
> 
> > I have a RAID5 setup with 15 drives.
> 
> Looks like you got the problem you were so desperately asking for, with
> this
> crazy setup. :(
> 
> > Is there anything I can do to get around these bad sectors or force
> mdadm
> > to ignore them to at least complete the recovery?
> 
> I suppose the second failed drive is still mostly alive, just has some
> unreadable areas? If so, I suggest that you get another new clean drive,
> and
> while your mdadm array is stopped, copy whatever you can with e.g.
> dd_rescue
> from the semi-dead drive to this new one. Then remove the bad drive from
> the
> system, and start the array with the new drive instead of the bad one.

Before asking this, I would first ask, "How dead is the first dead drive?"
Using dd_rescue on the "dead" drives might recover more data.  Or not.  It
might be time to drag out the backups.

