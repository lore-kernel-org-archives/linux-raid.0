From: Daniel Pittman <daniel@rimspace.net>
Subject: Re: /boot RAID1
Date: Wed, 31 Mar 2004 13:42:37 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <87zn9xy95e.fsf@enki.rimspace.net>
References: <1080700439.10119.10.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 31 Mar 2004, Ninti Systems wrote:
> I've set up everything to switch my fresh Slackware 9.1 install on
> /dev/hda over to RAID1 devices set up on /dev/hda (currently
> 'missing') and /dev/hdc.
> 
> Before I switch, I need to check one thing which isn't clear to me
> from the Software RAID HowTo:
> 
> I currently have a separate partition (/dev/hda1) for /boot. Can this
> partition also be switched over to RAID1 (on /dev/md1) or must the
> /boot partition always be on a non-RAID device?

It can be RAID1, yes, with some limits.  Specifically, it can be RAID1
because each disk in a RAID1 looks like a stand-alone disk if your
bootloader is unaware of the "RAID" nature of it.

So, old versions of lilo, and grub, can boot off the component of the
RAID1 just fine.  RAID5, though, would stump them.

Modern versions of lilo have some in-built support for RAID1, I hear,
though I have not used that support myself.

       Daniel

-- 
Let the credulous and the vulgar continue to believe that all mental woes can
be cured by a daily application of old Greek myths to their private parts.
        -- Vladimir Nabokov

