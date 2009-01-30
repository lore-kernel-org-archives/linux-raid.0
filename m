From: David Greaves <david@dgreaves.com>
Subject: Re: raid 5, drives marked as failed. Can I recover?
Date: Fri, 30 Jan 2009 15:24:20 +0000
Message-ID: <49831BA4.2000000@dgreaves.com>
References: <f97906a70901291517h2da6fd19pe800d9c17c49f562@mail.gmail.com>	 <alpine.DEB.1.10.0901300917120.23960@p34.internal.lan>	 <4983151A.4050609@dgreaves.com> <f97906a70901300706j442b89c3k8c61e8bb4a8aa49e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <f97906a70901300706j442b89c3k8c61e8bb4a8aa49e@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Tom <matx3001@gmail.com>
Cc: jpiszcz@lucidpixels.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Tom wrote:
> Hello,
> 
> I spent a night trying out mdadm --assemble on a virtual machine to
> see how it attempts to fix a raid where 2 or more drives have been
> marked faulty.
> I was quite sure that the drives were fine and that they were wrongly
> marked as bad.
> I think I just have a bad ata controller.
Given 2 drives died in 1 second then I'd agree.

> I used --assemble on real machine and it seemed to have detected the raid again.
> 1 drive was found to be bad and it is recreating it now.
> But my data is there and I can open it.
> I am going to get some dvd's and back all this up before it dies again!

OK, that's good :)

A forced assemble will make md assume all the disks are good and that all writes
succeeded. ie all is well.

They probably didn't and it probably isn't. OTOH you probably lost a few hundred
bytes in many many Gb so nothing to panic over.

You should fsck and, ideally, checksum compare your filesystem against a backup.
I would run a read-only fsck before doing anything. Then if you just have light
damage, repair.

David

