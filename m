From: David Greaves <david@dgreaves.com>
Subject: Re: Time to  deprecate old RAID formats?
Date: Thu, 25 Oct 2007 16:00:31 +0100
Message-ID: <4720AF8F.4050906@dgreaves.com>
References: <18200.49267.763509.924873@stoffel.org>	<Pine.LNX.4.64.0710191109000.27246@p34.internal.lan>	<18200.53593.687483.120827@stoffel.org>	<1192810534.1666.68.camel@firewall.xsintricity.com>	<18200.56684.14194.630264@stoffel.org>	<1192813877.1666.79.camel@firewall.xsintricity.com>	<18200.63987.514073.184865@stoffel.org>	<471E7DC6.7050206@tmr.com>	<1193184555.10336.3.camel@firewall.xsintricity.com> <18207.56169.769976.512617@notabene.brown> <4720AD15.7040600@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4720AD15.7040600@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Neil Brown <neilb@suse.de>, Doug Ledford <dledford@redhat.com>, John Stoffel <john@stoffel.org>, Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Bill Davidsen wrote:
> Neil Brown wrote:
>> I certainly accept that the documentation is probably less that
>> perfect (by a large margin).  I am more than happy to accept patches
>> or concrete suggestions on how to improve that.  I always think it is
>> best if a non-developer writes documentation (and a developer reviews
>> it) as then it is more likely to address the issues that a
>> non-developer will want to read about, and in a way that will make
>> sense to a non-developer. (i.e. I'm to close to the subject to write
>> good doco).
> 
> Patches against what's in 2.6.4 I assume? I can't promise to write
> anything which pleases even me, but I will take a look at it.
> 

The man page is a great place for describing, eg, the superblock location; but
don't forget we have
  http://linux-raid.osdl.org/index.php/Main_Page
which is probably a better place for *discussions* (or essays) about the
superblock location (eg the LVM / v1.1 comment Janek picked up on)

In fact I was going to take some of the writings from this thread and put them
up there.

David
