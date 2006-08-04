From: Neil Brown <neilb@suse.de>
Subject: Re: Raid5 hardware failure
Date: Fri, 4 Aug 2006 10:40:08 +1000
Message-ID: <17618.38760.550237.971988@cse.unsw.edu.au>
References: <20060803230201.GA1479@jnb.gelma.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Andrea Gelmini on Friday August 4
Sender: linux-raid-owner@vger.kernel.org
To: Andrea Gelmini <gelma@gelma.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday August 4, gelma@gelma.net wrote:
> 
> What can I do?
> a) force with some magic the assemble (maybe --assume-clean could
> help)?

Yes.  --assemble --force

NeilBrown

> b) wait for new disk and dd_rescue old /dev/hdg to new /dev/hdg and
> retry?
> c) recreate the raid (I'm scared...)?
> 
> Thanks a lot for your time,
> Andrea Gelmini 
