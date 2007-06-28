From: Ian Dall <ian@beware.dropbear.id.au>
Subject: Re: raid=noautodetect is apparently ignored?
Date: Thu, 28 Jun 2007 23:06:33 +0930
Message-ID: <1183037793.3462.14.camel@sibyl.beware.dropbear.id.au>
References: <1_07062612032611867@cichlid.com>
	 <200706271548.l5RFmn5x026702@cichlid.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200706271548.l5RFmn5x026702@cichlid.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 2007-06-27 at 08:48 -0700, Andrew Burgess wrote:
> >>> Odd....
> >>>  Maybe you have an initrd which is loading md as a module, then
> >>>  running "raidautorun" or similar?
> ..
> >I suspect that the last comment is the clue, after pivotroot I bet it 
> >runs another init, not from the boot/initrd images, but from the init.d 
> >in the root filesystem.

You are absolutely correct. On Fedora core5, in rc.sysinit

        echo "raidautorun /dev/md0" | nash --quiet
        if [ -f /etc/mdadm.conf ]; then
            /sbin/mdadm -A -s
        fi
        

But my original observation was correct. The noautodetect was/is being
ignored because (whenever) there is an initrd. FC5 doesn't support raid
root partitions (mkinitrd doesn't put the right stuff in initrd), but
FC7 tries to. I have upgraded and things are mostly correct. Albeit, FC7
doesn't support my nested raid configuration and so it took some coaxing
to get the the upgrade done and a hack to coax mkinitrd into doing the
right thing.

Putting mdadm.conf on a floppy disk plus a little intervention with a
virtual console early in the upgrade process worked wonders.

> One quick way to test this is to boot with "init=/bin/sh"
> This lets all the initrd stuff run but nothing from the
> root filesystem.

Neat idea. I'll try and remember that for the future.

-- 
Ian Dall <ian@beware.dropbear.id.au>
