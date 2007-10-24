From: David Greaves <david@dgreaves.com>
Subject: Re: Time to  deprecate old RAID formats?
Date: Wed, 24 Oct 2007 10:40:48 +0100
Message-ID: <471F1320.1060600@dgreaves.com>
References: <18200.49267.763509.924873@stoffel.org>	 <Pine.LNX.4.64.0710191109000.27246@p34.internal.lan>	 <18200.53593.687483.120827@stoffel.org>	 <1192810534.1666.68.camel@firewall.xsintricity.com>	 <471A0C02.4030407@msgid.tls.msk.ru> <18202.5687.672431.295590@stoffel.org>	 <471A47CC.1070508@msgid.tls.msk.ru>  <18205.2688.952701.567195@stoffel.org> <1193186569.10336.30.camel@firewall.xsintricity.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1193186569.10336.30.camel@firewall.xsintricity.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: John Stoffel <john@stoffel.org>, Michael Tokarev <mjt@tls.msk.ru>, Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Doug Ledford wrote:
> On Mon, 2007-10-22 at 16:39 -0400, John Stoffel wrote:
> 
>> I don't agree completely.  I think the superblock location is a key
>> issue, because if you have a superblock location which moves depending
>> the filesystem or LVM you use to look at the partition (or full disk)
>> then you need to be even more careful about how to poke at things.
> 
> This is the heart of the matter.  When you consider that each file
> system and each volume management stack has a superblock, and they some
> store their superblocks at the end of devices and some at the beginning,
> and they can be stacked, then it becomes next to impossible to make sure
> a stacked setup is never recognized incorrectly under any circumstance.

I wonder if we should not really be talking about superblock versions 1.0, 1.1,
1.2 etc but a data format (0.9 vs 1.0) and a location (end,start,offset4k)?

This would certainly make things a lot clearer to new users:

mdadm --create /dev/md0 --metadata 1.0 --meta-location offset4k


mdadm --detail /dev/md0

/dev/md0:
        Version : 01.0
  Metadata-locn : End-of-device
  Creation Time : Fri Aug  4 23:05:02 2006
     Raid Level : raid0


And there you have the deprecation... only two superblock versions and no real
changes to code etc

David
