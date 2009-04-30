From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: md extension to support booting from raid whole disks.
Date: Thu, 30 Apr 2009 14:01:47 +0100
Message-ID: <49F9A13B.5000501@anonymous.org.uk>
References: <1240574900.4507.2076.camel@ezra> <87hc0axhg9.fsf@frosties.localdomain> <49F68CE0.2010906@zytor.com> <e9c3a7c20904281124g4682d70cp22760176e7a8cfbc@mail.gmail.com> <1240957153.18303.689.camel@ezra> <18935.35747.471257.202356@notabene.brown> <49F78F26.2040909@zytor.com> <20090429074559.GA25938@maude.comedia.it> <20090430065935.GD22156@boogie.lpds.sztaki.hu> <20090430081144.GA31097@maude.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090430081144.GA31097@maude.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 30/04/2009 09:11, Luca Berra wrote:
> On Thu, Apr 30, 2009 at 08:59:35AM +0200, Gabor Gombas wrote:
[...]
> note that Windows is able to boot from a
> raid5 fakeraid, linux, afaik, is not.

I can't see why it wouldn't; a fakeraid BIOS lets you read from the RAID 
set via int13.

[...]
>> This failure mode also happens exactly the same way in the "reserve some
>> space at the beginning ant turn it into a RAID1 without telling enyone"
>> scheme.
> My idea is that the space at the beginning has no need of being a raid1.

But it's effectively a RAID-1 since you have to put your boot code at 
the start of every drive, or at least every drive that might appear as 
the boot drive. And if you want to boot off a RAID-[456] set, the boot 
code is going to have to have some kind of reimplementation of software 
RAID, like a fakeraid BIOS or Linux md. This looks to me like an 
unnecessary duplication of effort.

This whole "boot from raid whole discs" thing seems to me to be a bit of 
a misnomer anyway; "raid whole discs" don't have boot sectors on them, 
so by definition you can't boot from them, so in any case we're talking 
about booting from discs split, partitioned if you will, into a boot 
area and the RAID area.

Cheers,

John.

