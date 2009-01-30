From: Tom <matx3001@gmail.com>
Subject: Re: raid 5, drives marked as failed. Can I recover?
Date: Fri, 30 Jan 2009 15:06:33 +0000
Message-ID: <f97906a70901300706j442b89c3k8c61e8bb4a8aa49e@mail.gmail.com>
References: <f97906a70901291517h2da6fd19pe800d9c17c49f562@mail.gmail.com>
	 <alpine.DEB.1.10.0901300917120.23960@p34.internal.lan>
	 <4983151A.4050609@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4983151A.4050609@dgreaves.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>, jpiszcz@lucidpixels.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I spent a night trying out mdadm --assemble on a virtual machine to
see how it attempts to fix a raid where 2 or more drives have been
marked faulty.
I was quite sure that the drives were fine and that they were wrongly
marked as bad.
I think I just have a bad ata controller.

I used --assemble on real machine and it seemed to have detected the raid again.
1 drive was found to be bad and it is recreating it now.
But my data is there and I can open it.
I am going to get some dvd's and back all this up before it dies again!


Regards and thanks for your help!


2009/1/30 David Greaves <david@dgreaves.com>:
> Justin Piszcz wrote:
>> Try to assmeble the array with --force.
> hmmmm? not yet...
>
>
>> On Thu, 29 Jan 2009, Tom wrote:
>>
>>> Hello,
>>>
>>> 2 drives have failed on my raid5 setup and I need to recover the data
>>> on the raid.
>>> I am sure that the drives still works or at least one of them still
>>> works.
>>>
>>> How do I recover my drives?
>
> How important is it?
> The more important the data the more you should reduce the risk of a subsequent
> failure.
> If you "don't care" then we just force it back together and cross fingers.
> Otherwise we run tests on all the drives before trying a restore.
> I'd say to run these tests on each drive; as a minimum do the first test on the
> failed drive, more paranoia, more tests and include the non-failed drives (to
> ensure they don't fail during recovery):
> * smartctl -t short
> * smartctl -t long
> * badblocks
>
> What happened? Smoke?
> Are the drives faulty (what does smartctl -a tell you)
> Did the cables just wiggle? Is the controller broken?
> You probably don't know :)
>
> I would obtain replacements for the failed drives and use ddrescue to copy from
> the failed drive to a replacement.
> Then install the good drives and begin recovery.
>
>>> I can't mount the raid no more and I am missing a hard drive when i
>>> run ls /dev/sd?
>>> I have 7 drives on my raid.
> You say you have 7 drives and 2 are failed.
> And yet I see 4 drives, not 5.
>
> Where is sdg?
>
>>> Here is output of /var/log/messages in following link
>>>
>>> http://matx.pastebin.com/m35423452
>
> Jan 29 21:14:11  sda died
> Jan 29 21:14:12  sdb died
>
>>>
>>> also some more information
> Also need:
>  Distro
>  Kernel version
>  Mdadm version
>  mdadm --examine for each available component.
>
> David
>
> --
> "Don't worry, you'll be fine; I saw it work in a cartoon once..."
>
