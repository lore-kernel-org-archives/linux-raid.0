From: mjstumpf <mjstumpf@cotse.net>
Subject: Re: where to buy very very large cases
Date: Mon, 28 Jul 2003 11:16:39 -0400 (EDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <bWpzdHVtcGY=.4cd948dd5243da1b5289a26e6dc1ccfb@1059405399.cotse.net>
References: <bWpzdHVtcGY=.14a9e78b52177716d8df11d88fc1d02c@1059398282.cotse.net>
        <Pine.LNX.4.56.0307281024000.15708@router.windsormachine.com>
Reply-To: mjstumpf@pobox.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.56.0307281024000.15708@router.windsormachine.com>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Fascinating topic.  Building these, cheaply, is easy up to a point. 
Beyond that it gets interesting!

>> I need to expand an x86-based fileserver that's already stacked with
>> 11 drives.  Where have you folks found reasonably-priced very very
>> large ATX cases?  I need to go to 20 or so drives, but I'd like to
>> hear the upper limit you have all found..

Thanks, all, for comments.  I see every detail I forgot to include:  I'm
trying to do this on a budget (but not a college student budget) with ATA
drives.  I'm using a stack of promise ATA controllers with rounded ATA
cables (some of long lengths, 36") to get the job done.  It's been up and
running for the better part of 4 years now.

I currently have it in a 10 bay antec case; there are some opportunities
for home depot engineering + 3in2 + more fans + hours of wiring to pack
more drives in, maybe 5 or 6 more.  But, cooling will no doubt become
[more of] an issue and I figured it's more prudent to start from a very
physically large (double width) server case like I'd seen in the past. 
pricewatch seems to have them for $250-400, which I suppose I will have to
cough up.. one of these filled with 3in2 brackets might give me enough
room for growth ;-)

Has anyone seen the equivalent of more dense promise cards (more than 2
channels per card, but no extra bells & whistles like raid.. meaning,
cheap)?  I really prefer plain old software raid in linux, but I am
actually physically out of PCI slots (and heat issues, space issues, etc).

I wasn't even thinking of SCSI.  It's an interesting idea; there are
ata->scsi converters (tomshardware.com had a review, $70 at the time I
believe.. maybe cheaper now).  Essentially could create roll-your-own SCSI
enclosure.  Problem is, at an added cost of $70/drive, it may prove to not
be worthwhile.

Can't easily stagger IDE powerup, can you?  Already ran into that issue...

Because I'm a kernel hacker, I'd even been dreaming up ways have other
linux boxen stacked with drives, similarly, and have them smoothly
integrate into the big LVM.. but the methods are either unstable or
clumsy.  Suggestions accepted..

By the way, Gary Murakami has helped inspire me to do this.  Check out his
page if you've never seen it; great info.  
http://www.nobell.org/~gjm/linux/ide-raid/



