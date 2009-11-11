From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Bitmap did not survive reboot
Date: Tue, 10 Nov 2009 21:46:20 -0600
Message-ID: <20091111034629287.IYTI6968@cdptpa-omta02.mail.rr.com>
References: <20091111033418841.IRLD6968@cdptpa-omta02.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091111033418841.IRLD6968@cdptpa-omta02.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> The mdadm-raid script starts up the
> RAID process, and the mdadm script runs the monitor.  It seems to me the
> only link which is really correct is the rcS.d/S25mdadm.  At the very
> least
> I would think both the S99mdadm_monitor links should point to init.d/mdadm
> (which, after all is the script which starts the monitor) and that
> rc2.d/S25mdadm-raid would point to init.d/mdadm, just as the
> rcS.d/S25mdadm-raid link does.

	'Sorry, I meant to say, "rc2.d/S25mdadm-raid would point to
init.d/mdadm-raid, just as the rcS.d/S25mdadm-raid link does."  The naming
convention here is definitely confusing.

