From: Neil Brown <neilb@suse.de>
Subject: Re: RAID Problem
Date: Wed, 17 Mar 2010 11:09:43 +1100
Message-ID: <20100317110943.793c8e7b@notabene.brown>
References: <Gophermail.2.0.1003161832390.28616@vs-a.tc.umn.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Gophermail.2.0.1003161832390.28616@vs-a.tc.umn.edu>
Sender: linux-raid-owner@vger.kernel.org
To: colli419@umn.edu
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 16 Mar 2010 18:32:39 -0500
colli419@umn.edu wrote:

> Hello, I am having problems with my RAID as follows:
> 
> I installed the drives in an old computer and created the RAID and it 
> worked great. When I tried to install the same RAID set in a new computer I 
> could get it to mount manually with some messing around but couldn't get it 
> to mount automatically as in the old machine. I was wondering if zeroing 
> the superblocks and trying to re-create the RAID would be a good idea. The 
> data that is stored on the drives should otherwise be intact because I had 
> it running just fine the other day. Any help at all would be most 
> appreciated.
> 

You haven't provides a lot of concrete information, like error messages
during boot or "mdadm -E" output of devices or even kernel/mdadm versions, so
I can only guess, but my guess would be that you can fix it by assembling
the array with "--update=homehost"

i.e.
   mdadm --assemble /dev/mdwhatever  \
   --update=homehost /dev/device1 /dev/device2 ....

NeilBrown

