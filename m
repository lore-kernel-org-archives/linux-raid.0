From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] md: Add support for data integrity to MD
Date: Mon, 29 Sep 2008 10:51:54 -0400
Message-ID: <yq1ej33f1it.fsf@sermon.lab.mkp.net>
References: <yq1y71mmjvw.fsf@sermon.lab.mkp.net>
	<18649.43504.157272.351801@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18649.43504.157272.351801@notabene.brown> (Neil Brown's message of "Wed\, 24 Sep 2008 12\:46\:08 +1000")
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>>>> "Neil" == Neil Brown <neilb@suse.de> writes:

Neil> But what if we subsequently add a different device to that array
Neil> which uses a different protection format.  Would we be able to
Neil> tell the filesystem that integrity protection isn't available
Neil> any more?  Or can we detect if the filesystem is using integrity
Neil> protection, and reject the new device if it doesn't match?

Generally the filesystem will look at the block device's integrity
profile every time it prepares an I/O.  So if we add a subdevice and
detect a mismatch the mddev integrity profile should be removed.


Neil> In either case, some extra handling is needed in
Neil> bind_rdev_to_array.

This code has been sitting in my patch queue for several months
waiting for the core of the integrity stuff to go in.  So I'm a bit
fuzzy on the details.  I'll take a look...

-- 
Martin K. Petersen	Oracle Linux Engineering

