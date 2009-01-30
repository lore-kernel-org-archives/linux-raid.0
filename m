From: David Greaves <david@dgreaves.com>
Subject: Re: raid 5, drives marked as failed. Can I recover?
Date: Fri, 30 Jan 2009 14:56:26 +0000
Message-ID: <4983151A.4050609@dgreaves.com>
References: <f97906a70901291517h2da6fd19pe800d9c17c49f562@mail.gmail.com> <alpine.DEB.1.10.0901300917120.23960@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0901300917120.23960@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Tom <matx3001@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Justin Piszcz wrote:
> Try to assmeble the array with --force.
hmmmm? not yet...


> On Thu, 29 Jan 2009, Tom wrote:
> 
>> Hello,
>>
>> 2 drives have failed on my raid5 setup and I need to recover the data
>> on the raid.
>> I am sure that the drives still works or at least one of them still
>> works.
>>
>> How do I recover my drives?

How important is it?
The more important the data the more you should reduce the risk of a subsequent
failure.
If you "don't care" then we just force it back together and cross fingers.
Otherwise we run tests on all the drives before trying a restore.
I'd say to run these tests on each drive; as a minimum do the first test on the
failed drive, more paranoia, more tests and include the non-failed drives (to
ensure they don't fail during recovery):
* smartctl -t short
* smartctl -t long
* badblocks

What happened? Smoke?
Are the drives faulty (what does smartctl -a tell you)
Did the cables just wiggle? Is the controller broken?
You probably don't know :)

I would obtain replacements for the failed drives and use ddrescue to copy from
the failed drive to a replacement.
Then install the good drives and begin recovery.

>> I can't mount the raid no more and I am missing a hard drive when i
>> run ls /dev/sd?
>> I have 7 drives on my raid.
You say you have 7 drives and 2 are failed.
And yet I see 4 drives, not 5.

Where is sdg?

>> Here is output of /var/log/messages in following link
>>
>> http://matx.pastebin.com/m35423452

Jan 29 21:14:11  sda died
Jan 29 21:14:12  sdb died

>>
>> also some more information
Also need:
 Distro
 Kernel version
 Mdadm version
 mdadm --examine for each available component.

David

-- 
"Don't worry, you'll be fine; I saw it work in a cartoon once..."
