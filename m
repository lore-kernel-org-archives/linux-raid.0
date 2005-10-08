From: "Allen Martin" <AMartin@nvidia.com>
Subject: RE: Anybody know about nforce4 SATA II hot swapping + linux raid?
Date: Sat, 8 Oct 2005 12:16:59 -0700
Message-ID: <DBFABB80F7FD3143A911F9E6CFD477B00B41CA30@hqemmail02.nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
Sender: linux-raid-owner@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>, Andrew Walrond <andrew@walrond.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

>   One more thing to note is that nVidia cannot supply information
> regarding SATA part (I think network part too) of its chipset to open
> source community.  So, it is possible that not everything goes
smoothly
> with nf4 hotplug support even after other pieces come together
eventually.

The sata_nv libata driver has had full support for hotplug for a while.
When the rest of libata supports hotplug nForce4 SATA hotplug should
just work.

-Allen
