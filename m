From: <bmanning@sbschools.net>
Subject: RE: Raid-5 Reshape Gone Bad
Date: Mon, 2 Mar 2009 10:28:41 -0500
Message-ID: <24AAD26C88B9534093235DD9C02F4D1702AABB7D@exchangesrvr.sbschools.net>
References: <39656.69.54.28.143.1235961738.squirrel@webmail.luckyy.com> <3cc49e61d3c06311a24fd4a9ac1f4d00.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <3cc49e61d3c06311a24fd4a9ac1f4d00.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de
List-Id: linux-raid.ids

Neil,

Thanks for the tip.. It appears it might work.  I will try it tonight.

I had actually been working to recreate the situation in a vmware test
bed, which I did successfully recreate.  And it suffered the same
symptoms I had on the real hardware. When I tried your stripe_cache
setting, it immediately began the process in my vm.

(and you were right, the newest mdadm any of the resue cds I tried was
2.6.7)

Will let you know how it goes on the real thing tonight.



-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of NeilBrown
Sent: Sunday, March 01, 2009 10:33 PM
To: Brian Manning
Cc: linux-raid@vger.kernel.org
Subject: Re: Raid-5 Reshape Gone Bad

On Mon, March 2, 2009 1:42 pm, Brian Manning wrote:
> I've been running a MD three-drive raid-5 for a while now with no 
> problems on a CentOS 5.2 i386 box.  I've attempted to add a fourth 
> drive to the array yesterday & grow it.  This is where things got
ugly....
>
> It began the reshape as expected, some hours later I rebooted the box 
> for another reason entirely, forgetting about the reshape that was 
> still going on.  But it was a clean shutdown process and md stopped 
> just fine.  So I wasn't too worried about it, I knew it was just pick 
> up again once it booted.
>
> After startup the kernel found the md, said it was to resume the 
> reshape... then it came time for the kernel to mount root.. and hung 
> scanning for Logical Volumes, I left it for over an hour, it never 
> proceeded past this stage.  Disk io light was off, nothing going on.
>
> My entire OS save /boot is on the raid-5, split across several LVM2s 
> inside that md device.  It's always worked fine for me in the past.
>
> But now LVM is hanging on boot, I can't even get into single mode or 
> anything like that.  So I bring out the boot disc and go into rescue
mode.
>
> I check the raid status, everything looks okay, so I manually start 
> the MD again from the boot cd, and that fires up as expected, 
> however.... when I look at /proc/mdstat... the speed is 0KB/sec, and 
> the ETA is growing by 100's of minutes a second.
>
> I let this go for about 2 hours, and nothing ever happens, speed is 0,

> diskio light is off, nothing is happening.

I notice that your array has a chunksize of 1024K.
That is big enough to cause an issue that was only resolved in
mdadm-2.6.8, which I suspect you aren't using.

If you
  echo 1024 > /sys/block/md0/md/stripe_cache_size
it might spring to life.

I think the 1024 is right, but if it doesn't work try a larger number
(e.g. 8192) just in case I got the math wrong.

And:  no, you cannot go back to a 3 drive array.  The transformation is
currently one-way.

NeilBrown



--
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org More majordomo info
at  http://vger.kernel.org/majordomo-info.html

______________________________________________________________
______________________________________________________________
This email may contain information protected under the Family 
Educational Rights and Privacy Act (FERPA) or the Health Insurance 
Portability and Accountability Act (HIPAA).  If this email contains 
confidential and/or privileged health or student information and you 
are not entitled to access such information under FERPA or HIPAA, 
federal regulations require that you destroy this email without 
reviewing it and you may not forward it to anyone.


--
This message has been scanned for viruses and
dangerous content by MailScanner, ClamAV and Bitdefender  and is
believed to be clean.

