From: Sean Harris <sean@backblaze.com>
Subject: Re: Converting a .90 raid superblock to version 1.0 and whether--size parameter is needed
Date: Wed, 18 Mar 2015 17:58:05 -0700
Message-ID: <DDB9AAD7-E69F-4D82-9A4D-2200E1D4C81D@backblaze.com>
References: <21CFD7CC-7A05-4298-BD77-E1287B9F78D5@backblaze.com> <149825A6-89BC-4804-915B-5241EEB15300@backblaze.com> <20150318121054.066b963b@notabene.brown>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2070.6\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150318121054.066b963b@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks Neil,
I'd like to try this but I'm having trouble installing it on Debian 5 (lenny).

When I try to make install, it complains:

***** Parent of /run/mdadm does not exist.  Maybe set different RUN_DIR=
*****  e.g. make RUN_DIR=/dev/.mdadm
***** or set CHECK_RUN_DIR=0
make: *** [check_rundir] Error 1

cat /etc/debian_version 
5.0.10

The default run directory apparently is not there ie: /run/mdadm
That directory exists on Debian 7 but not Debian 5.

I admittedly do not know what to set that variable to on Lenny. Can you point me to what to look for?

Thanks,

Sean


> On Mar 17, 2015, at 6:10 PM, NeilBrown <neilb@suse.de> wrote:
> 
> mdadm --assemble /dev/md10 --update=metadata ...list.of.devices..

