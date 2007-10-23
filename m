From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Time to  deprecate old RAID formats?
Date: Tue, 23 Oct 2007 19:18:14 -0400
Message-ID: <471E8136.6070202@tmr.com>
References: <18200.49267.763509.924873@stoffel.org>	<Pine.LNX.4.64.0710191109000.27246@p34.internal.lan>	<18200.53593.687483.120827@stoffel.org>	<1192810534.1666.68.camel@firewall.xsintricity.com>	<471A0C02.4030407@msgid.tls.msk.ru> <18202.5687.672431.295590@stoffel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18202.5687.672431.295590@stoffel.org>
Sender: linux-raid-owner@vger.kernel.org
To: John Stoffel <john@stoffel.org>
Cc: Michael Tokarev <mjt@tls.msk.ru>, Doug Ledford <dledford@redhat.com>, Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

John Stoffel wrote:
>>>>>> "Michael" == Michael Tokarev <mjt@tls.msk.ru> writes:
>>>>>>             
>
> Michael> Doug Ledford wrote:
> Michael> []
>   
>>> 1.0, 1.1, and 1.2 are the same format, just in different positions on
>>> the disk.  Of the three, the 1.1 format is the safest to use since it
>>> won't allow you to accidentally have some sort of metadata between the
>>> beginning of the disk and the raid superblock (such as an lvm2
>>> superblock), and hence whenever the raid array isn't up, you won't be
>>> able to accidentally mount the lvm2 volumes, filesystem, etc.  (In worse
>>> case situations, I've seen lvm2 find a superblock on one RAID1 array
>>> member when the RAID1 array was down, the system came up, you used the
>>> system, the two copies of the raid array were made drastically
>>> inconsistent, then at the next reboot, the situation that prevented the
>>> RAID1 from starting was resolved, and it never know it failed to start
>>> last time, and the two inconsistent members we put back into a clean
>>> array).  So, deprecating any of these is not really helpful.  And you
>>> need to keep the old 0.90 format around for back compatibility with
>>> thousands of existing raid arrays.
>>>       
>
> Michael> Well, I strongly, completely disagree.  You described a
> Michael> real-world situation, and that's unfortunate, BUT: for at
> Michael> least raid1, there ARE cases, pretty valid ones, when one
> Michael> NEEDS to mount the filesystem without bringing up raid.
> Michael> Raid1 allows that.
>
> Please describe one such case please.  There have certainly been hacks
> of various RAID systems on other OSes such as Solaris where the VxVM
> and/or Solstice DiskSuite allowed you to encapsulate an existing
> partition into a RAID array.  
>
> But in my experience (and I'm a professional sysadm... :-) it's not
> really all that useful, and can lead to problems liks those described
> by Doug.  
>
> If you are going to mirror an existing filesystem, then by definition
> you have a second disk or partition available for the purpose.  So you
> would merely setup the new RAID1, in degraded mode, using the new
> partition as the base.  Then you copy the data over to the new RAID1
> device, change your boot setup, and reboot.
>
> Once that is done, you can then add the original partition into the
> RAID1 array.  
>
> As Doug says, and I agree strongly, you DO NOT want to have the
> possibility of confusion and data loss, especially on bootup.  And
> this leads to the heart of my initial post on this matter, that the
> confusion of having four different variations of RAID superblocks is
> bad.  We should deprecate them down to just two, the old 0.90 format,
> and the new 1.x format at the start of the RAID volume.
>   

Perhaps I am misreading you here, when you say "depreciate them down" do 
you mean the Adrian Bunk method of putting in a printk scolding the 
administrator, and then remove the feature a version later, or did you 
mean "depreciate all but two" which clearly doesn't suggest removing the 
capability at all?

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

