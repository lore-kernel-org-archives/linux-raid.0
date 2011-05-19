From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Best way to create RAID-6 for swap partition - existing one failed
Date: Thu, 19 May 2011 03:17:37 -0500
Message-ID: <4DD4D221.5080605@hardwarefreak.com>
References: <136111.99834.qm@web65105.mail.ac2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <136111.99834.qm@web65105.mail.ac2.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Gavin Flower <gavinflower@yahoo.com>
Cc: linux-raid@vger.kernel.org, neilb@suse.de, mb@gem.win.co.nz
List-Id: linux-raid.ids

On 5/18/2011 11:05 PM, Gavin Flower wrote:

> I looked at some Google results (see below), and have decided to revert to using a partition.  As it is rapidly getting into more complications than I have time to pursue.  

Linux can do that, from time to time. :) :(

> This is far from the '60 second change' you promised :-)

I said you could deactivate your swap partition and make+activate a swap
file in less than 60 seconds, which is true.  I never mentioned anything
about it working with suspend/resume.  You're the fool who hibernates a
machine with a software RAID array for Pete's sake. ;)  Why are you
suspending such a machine, out of curiosity?  Surely it's not a laptop.
 Does it really save that much on the power bill?

A little more research shows this does work for many distros, not so
well for some others.  To make it work one must install uswsusp and
configure it.  This is what allows the kernel to suspend to a swap file
instead of a partition.

-- 
Stan
