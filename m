From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Raid 5 to 6 is it do-able/safe?
Date: Tue, 29 Dec 2009 13:08:28 +0100 (CET)
Message-ID: <alpine.DEB.1.10.0912291308010.27231@uplift.swm.pp.se>
References: <305721.15040.qm@web51302.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <305721.15040.qm@web51302.mail.re2.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon@eHardcastle.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 29 Dec 2009, Jon Hardcastle wrote:

> I run gentoo with kernel 2.6.22-gentoo-r8
>
> to convert my 6 drive +1 spare raid 5 to a 7 drive raid 6?

No, you need at least kernel 2.6.32 to migrate from raid5 to raid6.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
