From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: RAID5 Shrinking array-size nearly killed the system
Date: Sat, 12 Mar 2011 06:56:36 +0100 (CET)
Message-ID: <alpine.DEB.1.10.1103120655370.7942@uplift.swm.pp.se>
References: <AANLkTimrq904HRZfx6RpPrVNd0EJ5AkUZtytY7TqcFYv@mail.gmail.com> <AANLkTikQ5_xm3+JKP8pR=oYO5xi6Qk1=VrSsiBkgtB6q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTikQ5_xm3+JKP8pR=oYO5xi6Qk1=VrSsiBkgtB6q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Rory Jaffe <rsjaffe@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 11 Mar 2011, Rory Jaffe wrote:

> 3. Is there something I did that caused the crash?

Mdadm has no concept of filesystem, it works on the block device.

From your text you give no indication that you shrunk the filesystem 
before shrinking the block device. Did you?

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
