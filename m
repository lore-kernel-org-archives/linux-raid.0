From: Krzysztof Adamski <k@adamski.org>
Subject: Re: potentially lost largeish raid5 array..
Date: Mon, 26 Sep 2011 19:28:15 -0400
Message-ID: <1317079695.27455.1.camel@oxygen.netxsys.com>
References: <201109221950.36910.tfjellstrom@shaw.ca>
	 <201109231022.59437.tfjellstrom@shaw.ca>
	 <4E7D152C.9080704@hardwarefreak.com>
	 <201109231811.08061.tfjellstrom@shaw.ca>
	 <4E7DCA66.4000705@hardwarefreak.com> <j5ksf5$oam$1@dough.gmane.org>
	 <4E7E079C.4020802@hardwarefreak.com> <j5n921$9oj$1@dough.gmane.org>
	 <4E7F3D24.5050300@hardwarefreak.com> <j5ngnt$ms1$1@dough.gmane.org>
	 <4E7FC042.7040109@hardwarefreak.com> <j5plld$fa1$1@dough.gmane.org>
	 <4E80D815.9080005@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E80D815.9080005@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 2011-09-26 at 14:52 -0500, Stan Hoeppner wrote:
> Coincidentally, recent versions of mkfs.xfs will read the mdadm
> config 
> and build the filesystem correctly, automatically, on top of striped
> md 
> raid arrays.

If I have LVM on top of RAID6, will mkfs.xfs read the mdadm config?

