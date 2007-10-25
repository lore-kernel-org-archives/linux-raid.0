From: David Greaves <david@dgreaves.com>
Subject: Re: Time to  deprecate old RAID formats?
Date: Thu, 25 Oct 2007 09:09:41 +0100
Message-ID: <47204F45.4010205@dgreaves.com>
References: <18200.49267.763509.924873@stoffel.org>	<Pine.LNX.4.64.0710191109000.27246@p34.internal.lan>	<18200.53593.687483.120827@stoffel.org>	<1192810534.1666.68.camel@firewall.xsintricity.com>	<18200.56684.14194.630264@stoffel.org>	<1192813877.1666.79.camel@firewall.xsintricity.com>	<18200.63987.514073.184865@stoffel.org>	<471E7DC6.7050206@tmr.com>	<1193184555.10336.3.camel@firewall.xsintricity.com> <18207.56169.769976.512617@notabene.brown> <471FDEB1.8040401@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <471FDEB1.8040401@garzik.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>, Neil Brown <neilb@suse.de>
Cc: Doug Ledford <dledford@redhat.com>, Bill Davidsen <davidsen@tmr.com>, John Stoffel <john@stoffel.org>, Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jeff Garzik wrote:
> Neil Brown wrote:
>> As for where the metadata "should" be placed, it is interesting to
>> observe that the SNIA's "DDFv1.2" puts it at the end of the device.
>> And as DDF is an industry standard sponsored by multiple companies it
>> must be ......
>> Sorry.  I had intended to say "correct", but when it came to it, my
>> fingers refused to type that word in that context.

>> For the record, I have no intention of deprecating any of the metadata
>> formats, not even 0.90.
> 
> strongly agreed

I didn't get a reply to my suggestion of separating the data and location...

ie not talking about superblock versions 0.9, 1.0, 1.1, 1.2 etc but a data
format (0.9 vs 1.0) and a location (end,start,offset4k)?

This would certainly make things a lot clearer to new (and old!) users:

mdadm --create /dev/md0 --metadata 1.0 --meta-location offset4k
or
mdadm --create /dev/md0 --metadata 1.0 --meta-location start
or
mdadm --create /dev/md0 --metadata 1.0 --meta-location end

resulting in:
mdadm --detail /dev/md0

/dev/md0:
        Version : 01.0
  Metadata-locn : End-of-device
  Creation Time : Fri Aug  4 23:05:02 2006
     Raid Level : raid0

You provide rational defaults for mortals and this approach allows people like
Doug to do wacky HA things explicitly.

I'm not sure you need any changes to the kernel code - probably just the docs
and mdadm.

>> It is conceivable that I could change the default, though that would
>> require a decision as to what the new default would be.  I think it
>> would have to be 1.0 or it would cause too much confusion.
> 
> A newer default would be nice.

I also suspect that a *lot* of people will assume that the highest superblock
version is the best and should be used for new installs etc.

So if you make 1.0 the default then how many users will try 'the bleeding edge'
and use 1.2? So then you have 1.3 which is the same as 1.0? Hmmmm? So to quote
from an old Soap: "Confused, you  will be..."

David
