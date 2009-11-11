From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: [ANNOUNCE] mdadm-3.1 has been withdrawn
Date: Tue, 10 Nov 2009 19:26:53 -0800
Message-ID: <4877c76c0911101926p3cf3b488qef95cfe43792e7ac@mail.gmail.com>
References: <19187.50708.551325.297625@notabene.brown>
	 <4AF829B2.5090001@redhat.com> <4AF836F8.5040903@panix.com>
	 <cccedfc60911090742x5ac85a5axcf93d5cb9f6f6539@mail.gmail.com>
	 <alpine.DEB.1.10.0911091749320.22728@uplift.swm.pp.se>
	 <4AF8847D.8030303@redhat.com>
	 <alpine.DEB.1.10.0911100920510.22728@uplift.swm.pp.se>
	 <cccedfc60911100622l3bf9c01do5aaf92a64ad4ecd9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cccedfc60911100622l3bf9c01do5aaf92a64ad4ecd9@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon Nelson <jnelson-linux-raid@jamponi.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

There is nothing preventing someone from first creating a protective
partition, similar to the MBR record used by GPT.  Then they would be
able to use the 4k offset 1.2 label on the device if they absolutely
wanted.  However a normal MBR with partition and 1.1 label would use
less disk space and be more compatible with other tools.  Similar
logic applies for GPT labeled drives, and any drive large enough to
require GPT should not miss the ~16 kilobytes required at each end of
the drive.
