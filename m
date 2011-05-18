From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Best way to create RAID-6 for swap partition - existing one failed
Date: Wed, 18 May 2011 18:01:21 -0500
Message-ID: <4DD44FC1.9020500@hardwarefreak.com>
References: <953428.5114.qm@web65107.mail.ac2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <953428.5114.qm@web65107.mail.ac2.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Gavin Flower <gavinflower@yahoo.com>
Cc: linux-raid@vger.kernel.org, neilb@suse.de, mb@gem.win.co.nz
List-Id: linux-raid.ids

On 5/18/2011 5:31 PM, Gavin Flower wrote:

> I took longer than I'm prepared to admit!  :-)
> 
> I'll take note, and either apply your idea next time it happens, or when I do a major O/S upgrade.

You seem to see this as a major system change, something not dare
implemented 'on the fly'.  It takes 60 seconds and you're done, with
zero downside, zero worries.

There are high security environments that deactivate and clear swap
files with dd at each logoff, as well as dropping all caches, then
reactivate the swap file.  Swap files are not fragile.

-- 
Stan
