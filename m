From: Neil Brown <neilb@suse.de>
Subject: Re: Problem with Software RAID5
Date: Mon, 23 Oct 2006 14:35:34 +1000
Message-ID: <17724.18070.484291.660274@cse.unsw.edu.au>
References: <4535F660.90901@cgv.tugraz.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Lars Schimmer on Wednesday October 18
Sender: linux-raid-owner@vger.kernel.org
To: Lars Schimmer <l.schimmer@cgv.tugraz.at>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday October 18, l.schimmer@cgv.tugraz.at wrote:
> 
> Any hints? tips?
> 

If you crash and lose a drive at the same time you could have
undetectable data corruption.  If you are willing to accept that use
'--force'

  mdadm --assemble --force /dev/md0

Hopefully mdadm-2.6 will give a more useful error message here.

NeilBrown
