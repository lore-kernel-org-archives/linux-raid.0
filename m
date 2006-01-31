From: Luca Berra <bluca@comedia.it>
Subject: Re: 2.6.15: mdrun, udev -- who creates nodes?
Date: Tue, 31 Jan 2006 22:44:13 +0100
Message-ID: <20060131214413.GF4335@percy.comedia.it>
References: <43DCA9CA.5020505@bl.com> <20060129123532.GA6158@wonderland.linux.it> <43DCD614.20705@pobox.com> <20060130204231.GP19465@austin.ibm.com> <20060130204743.GA13902@wonderland.linux.it> <dro3ue$ntb$1@sea.gmane.org> <20060131192643.GU19465@austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20060131192643.GU19465@austin.ibm.com>
Sender: linux-raid-owner@vger.kernel.org
To: linas <linas@austin.ibm.com>
Cc: Jason Lunz <lunz@falooley.org>, neilb@suse.de, linux-hotplug-devel@lists.sourceforge.net, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Jan 31, 2006 at 01:26:43PM -0600, linas wrote:
>On Tue, Jan 31, 2006 at 04:40:46PM +0000, Jason Lunz was heard to remark:
>> md@Linux.IT said:
>> >> -- kernel scans /dev/hda1, looking for md superblock
>> >> -- kernel assembles devices according to info found in the superblocks
>> >> -- udev creates /dev/md0, etc.=20
>> > The problem is that some users and distributions build the drivers as
>> > modules and/or disable in-kernel auto-assembly.
>> 
>> Not only that, the raid developers themselves consider autoassembly
>> deprecated.
>> 
>> http://article.gmane.org/gmane.linux.kernel/373620
>
>Hmm. My knee-jerk, didn't-stop-to-think-about-it reaction is that 
>this is one of the finest features of linux raid, so why remove it?

please, no, not again:
this particular horse has been beaten to death many times before.

the in kernel auto assembly should be removed for good (read the
linux-raid list archive to understand why)

it should be replaced by auto assembly in user space (mdadm), which does
not suffer from the problems that in-kernel has. neither it does suffer
from a poor configuration file like the (unmaintained) raidtools had.
and is much more cleaner and maintainable.

L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
