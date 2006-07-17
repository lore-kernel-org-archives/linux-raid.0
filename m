From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: [PATCH] enable auto=yes by default when using udev
Date: Mon, 17 Jul 2006 15:42:02 -0400
Message-ID: <44BBE80A.1080007@tmr.com>
References: <20060702224549.GD12733@percy.comedia.it> <17576.21342.685662.432117@cse.unsw.edu.au> <44AA42F6.8070307@tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <44AA42F6.8070307@tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Neil Brown <neilb@suse.de>, Luca Berra <bluca@comedia.it>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Michael Tokarev wrote:

>Neil Brown wrote:
>  
>
>>On Monday July 3, bluca@comedia.it wrote:
>>    
>>
>>>Hello,
>>>the following patch aims at solving an issue that is confusing a lot of
>>>users.
>>>when using udev, device files are created only when devices are
>>>registered with the kernel, and md devices are registered only when
>>>started.
>>>mdadm needs the device file _before_ starting the array.
>>>so when using udev you must add --auto=yes to the mdadm commandline or
>>>to the ARRAY line in mdadm.conf
>>>
>>>following patch makes auto=yes the default when using udev
>>>      
>>>
>>The principle I'm reasonably happy with, though you can now make this
>>the default with a line like
>>
>>  CREATE auto=yes
>>in mdadm.conf.
>>
>>However....
>>
>>    
>>
>>>+
>>>+	/* if we are using udev and auto is not set, mdadm will almost
>>>+	 * certainly fail, so we force it here.
>>>+	 */
>>>+	if (autof == 0 && access("/dev/.udevdb",F_OK) == 0)
>>>+		autof=2;
>>>+
>>>      
>>>
>>I'm worried that this test is not very robust.
>>On my Debian/unstable system running used, there is no
>> /dev/.udevdb
>>though there is a
>> /dev/.udev/db
>>
>>I guess I could test for both, but then udev might change
>>again.... I'd really like a more robust check.
>>    
>>
>
>Why to test for udev at all?  If the device does not exist, regardless
>if udev is running or not, it might be a good idea to try to create it.
>Because IT IS NEEDED, period.  Whenever the operation fails or not, and
>whenever we fail if it fails or not - it's another question, and I think
>that w/o explicit auto=yes, we may ignore create error and try to continue,
>and with auto=yes, we fail on create error.
>  
>
I have to agree here, I can't think of a case where creation of the 
device name would not be desirable, udev or no. But to be cautious, 
perhaps the default should be to create the device if the path starts 
with /dev/ or /tmp/ unless auto creation is explicitly off. I don't 
think udev or mount points come into the default decision at all, there 
are just too many options on naming.

>Note that /dev might be managed by some other tool as well, like mudev
>from busybox, or just a tiny shell /sbin/hotplug script.
>
>Note also that the whole root filesystem might be on tmpfs (like in
>initramfs), so /dev will not be a mountpoint.
>  
>
Agree with both points.

>Also, I think mdadm should stop creating strange temporary nodes somewhere
>as it does now.  If /dev/whatever exist, use it. If not, create it (unless,
>perhaps, auto=no is specified) directly with proper mknod("/dev/mdX"), but
>don't try to use some temporary names in /dev or elsewhere.
>  
>
True, but I don't see a case where this would be useful. And if it is, 
then add an auto=obscure_names option for the case where you really want 
that behaviour.

>In case of nfs-mounted read-only root filesystem, if someone will ever need
>to assemble raid arrays in that case.. well, he can either prepare proper
>/dev on the nfs server, or use tmpfs-based /dev, or just specify /tmp/mdXX
>instead of /dev/mdXX - whatever suits their needs better.
>
Because /dev and /tmp are well known special cases, I would default auto 
for them. In other cases explicit behavior could be specified.

Feel free to point out something bad which occurs by using this default 
behavior.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

