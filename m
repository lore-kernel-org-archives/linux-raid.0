From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: combining two raid systems
Date: Fri, 14 Jan 2005 13:18:32 +1100
Message-ID: <16871.11256.955469.266210@cse.unsw.edu.au>
References: <200501132017.16910.maarten@ultratux.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from maarten on Thursday January 13
Sender: linux-raid-owner@vger.kernel.org
To: maarten <maarten@ultratux.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday January 13, maarten@ultratux.net wrote:
> 
> Hi,
> 
> I'm currently combing two servers into one, and I'm trying to figure out the 
> safest way to do that.
....
> 
> All md arrays are self-booting 0xFD partitions.
...
> 
> Now when I boot I get a lilo prompt, so I know the right disk is booted by the 
> BIOS.  When logged in, I see only the md devices from system two, and thus 
> the current md0 "/" drive is from system two.  Now what options do I have ?

This is exactly why I despise auto-detect (0xFD partitions). When it
works, it works well, but when it doesn't it causes real problems.

You seem to have solved a lot of your problems based on subsequent
emails, but the simplest approach would be to remove the 0xFD setting
on all partitions except those for the root filesystem. 
Once you have done that, you should be able to boot fine, though only
the root array will be assembled of course.

Then something  like
  mdadm -E -s -c partitions

will cause mdadm to find all your arrays and report information about
them.
(mdadm -Ds, as you were trying, only reports assembled arrays. You
want '-E' to find arrays make of devices that aren't currently
assembled).

Put this information into mdadm.conf and edit out the bits you don't
want leaving something like:

  DEVICES partitions
  ARRAY /dev/md1 UUID=....
  ARRAY /dev/md2 UUID=.....
  etc

i.e. each ARRAY entry only lists a device name and a UUID.
The output of "mdadm -Es.." will list some device names
twice. Naturally you will need to change this.

Then
   mdadm -As

will assemble the rest of your arrays.

You also wondered about "personality" numbers.
A "personality" corresponds to a module that handles 1 or more raid
levels.
Personality 3 handles raid1
Personality 4 handles raid5 and raid4

see include/linux/raid/md_k.h

NeilBrown
