From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Possible to rescue SW Raid5 with 2 missing Disks
Date: Wed, 20 Feb 2013 09:06:08 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1302200904440.32644@uplift.swm.pp.se>
References: <20130220074445.320160@gmx.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130220074445.320160@gmx.net>
Sender: linux-raid-owner@vger.kernel.org
To: Dragon <Sunghost@gmx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 20 Feb 2013, Dragon wrote:

> the tests on sdd and sdf runs over night and both are clean - has no errors. Therefore i think it was the mistake while moving both. Hope thats helps to get back to an good state of my raid.

You need to try to --create --assume-clean all orders of drives to try to 
find an order that will work for you (passes fsck). There are scripts 
posted about which should be searchable via the archives.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
