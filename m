From: Neil Brown <neilb@suse.de>
Subject: Re: Online resize
Date: Tue, 29 Apr 2008 11:00:13 +1000
Message-ID: <18454.29469.343413.701176@notabene.brown>
References: <200803111119.56015.wayne@flashmedia.co.za>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Wayne Gemmell on Tuesday March 11
Sender: linux-raid-owner@vger.kernel.org
To: wayne@flashmedia.co.za
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday March 11, wayne@flashmedia.co.za wrote:
> Hi all
> 
> I'd like to do an online resize for my RAID5 drives now that I've upgraded 
> them to 500GB drives. Now I'm a bit stuck. I assume the steps would be the 
> following.

What exactly do you mean by "now that I've upgraded them to 500GB
drives".
Don't tell my you got new 500GB drives, created little partitions on
them to match the old drives, and added those to the array.  That is
the wrong way around.

md is quite happy having using some partitions much larger than
others.
So if you have an array with (say) 4 200GB drives and want to replace
them all with 500GB drives, you should make 500GB partitions on those
drives (assuming that you really want to use partitions) and then
one at a time, fail a working drive and add a new drive, and wait for
recovery to complete.

Once that is done you still have a working array of the same size as
before but all the devices (and all the partitions) are larger.
Then just
  mdadm --grow /dev/mdX --size=max

and the array will resync the new space and be larger for you.  Then
you can resize the filesystem.

NeilBrown
