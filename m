From: "David M. Strang" <dstrang@shellpower.net>
Subject: Re: Drive fails & raid6 array is not self rebuild .
Date: Fri, 9 Sep 2005 07:37:31 -0400
Message-ID: <005a01c5b532$dd500b90$c700a8c0@NCNF5131FTH>
References: <60F5F1E2B94AD4119F0B00B0D0215FFF01A69F99@bsc.tt.umist.ac.uk><Pine.LNX.4.63.0509081247060.29776@filesrv1.baby-dragons.com><17184.43156.113155.811612@cse.unsw.edu.au><Pine.LNX.4.63.0509081525380.30261@filesrv1.baby-dragons.com><17184.56377.773388.978710@cse.unsw.edu.au><Pine.LNX.4.63.0509082000030.31748@filesrv1.baby-dragons.com> <17185.15446.481054.508746@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>, "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Cc: linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

NeilBrown wrote:
> Hmm.. obviously hot-add isn't enough to trigger the rebuild in that
> kernel.

I can attest to this; as I workaround I've been using:

mdadm --readonly /dev/mdX
mdadm --readwrite /dev/mdX

That will trigger a rebuild.


-- David
