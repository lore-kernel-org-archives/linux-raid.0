From: Brassow Jonathan <jbrassow@redhat.com>
Subject: Re: [PATCH 1 of 3] MD RAID10: Prep for DM RAID10 device replacement capability
Date: Wed, 5 Sep 2012 09:53:04 -0500
Message-ID: <F22CD0E2-88C0-4132-9EF1-B6561B8B5D2B@redhat.com>
References: <1345832315.25206.16.camel@f16> <20120905120357.7e7dd316@notabene.brown>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120905120357.7e7dd316@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, Jonathan Brassow <jbrassow@redhat.com>
List-Id: linux-raid.ids


On Sep 4, 2012, at 9:03 PM, NeilBrown wrote:

> While reviewing I noticed:
> 
> 			if (value > rs->md.raid_disks) {
> 				rs->ti->error = "Invalid rebuild index given";
> 				return -EINVAL;
> 			}
> 
> (in the 'rebuild' handling).  That should be  'value >= rs->md.raid_disks'
> shouldn't it?
> If you agree, please send a patch.

Yes.  Thank-you for catching that.  Patch coming shortly.

 brassow

