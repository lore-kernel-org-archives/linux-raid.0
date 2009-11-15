From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Bitmap did not survive reboot
Date: Sun, 15 Nov 2009 13:27:50 -0600
Message-ID: <20091115192753283.LMEA5263@cdptpa-omta04.mail.rr.com>
References: <4AFFDF93.9010303@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AFFDF93.9010303@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'Doug Ledford' <dledford@redhat.com>
Cc: 'Linux RAID Mailing List' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> This allows comparison of not just the final throughput but also the
> various activities.  Regardless though, 109 average versus 92 average is
> a very telling story.  That's an 18% performance difference and amounts
> to a *HUGE* factor.

	Well, not so much.  Remember, there is only 1 link for ingress /
egress on these machines - a single Gig-E link.  Getting much over 90 MBps
would be a challenge.  Really the only process running on this machine is an
rsync daemon which runs at 04:00 every morning, and I really don't care if
the rsync takes an extra 10 minutes or some such.  Of course, in the event
of having to copy the entire data set to a failed array, any extra
performance would be welcome, but I'm really not concerned about it.  Now if
this were one of my commercial production servers, it would be a different
matter, but this is for my house, and it is only a backup unit.  That
doesn't mean I am going to revert to the smaller bitmap chunk, though.

