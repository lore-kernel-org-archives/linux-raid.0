From: adfas asd <chimera_god@yahoo.com>
Subject: Re: Is My Data DESTROYED?!
Date: Fri, 23 Oct 2009 16:25:52 -0700 (PDT)
Message-ID: <885316.78847.qm@web38805.mail.mud.yahoo.com>
References: <4b85f6ec7a52d1a124696941b382c2b0.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4b85f6ec7a52d1a124696941b382c2b0.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--- On Fri, 10/23/09, NeilBrown <neilb@suse.de> wrote:
> Clearly md0 is degraded - one device is missing.
> You need to find out why.  Then if you trust the
> missing device to
> keep working, add it back in (mdadm --add ...)
> 
> dmesg or /var/log/something might have hints as to what the
> error
> was that caused md to reject the device.

Thanks Neil, this is the first constructive advice all day.

Klipper isn't working for some reason, so I can't post the exact error, but dmesg and /var/log/messages say md0 has an unknown partition table (this time for ext2), just like with the prior problem on md2 (with jfs).




      
