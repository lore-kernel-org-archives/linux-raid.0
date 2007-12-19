From: Neil Brown <neilb@suse.de>
Subject: Re: raid5 resizing
Date: Wed, 19 Dec 2007 22:59:41 +1100
Message-ID: <18281.1965.40403.734289@notabene.brown>
References: <20071219111713.GF29538@zip.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from CaT on Wednesday December 19
Sender: linux-raid-owner@vger.kernel.org
To: CaT <cat@zip.com.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday December 19, cat@zip.com.au wrote:
> Hi,
> 
> I'm thinking of slowly replacing disks in my raid5 array with bigger
> disks and then resize the array to fill up the new disks. Is this
> possible? Basically I would like to go from:
> 
> 3 x 500gig RAID5 to 3 x 1tb RAID5, thereby going from 1tb to 2tb of
> storage.
> 
> It seems like it should be, but... :)

Yes.

mdadm --grow /dev/mdX --size=max

NeilBrown
