From: Antonio Perez <ap23563m@gmx.com>
Subject: Re: embedding area is unusually small... (GRUB2 on software RAID1)
Date: Wed, 06 Jan 2010 16:41:39 -0400
Message-ID: <1262825627.g6ATheBPQY@rnqqfki.eternal-september.org>
References: <4589525.I9CuDL8pqf@rnqqfki.eternal-september.org> <195985.49531.qm@web88208.mail.re2.yahoo.com>
Reply-To: ap23563m@gmx.com
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Lapohos Tibor wrote:

> Thanks for your reply, Antonio.
> 
> --- On Wed, 1/6/10, Antonio Perez <ap23563m@gmx.com> wrote:
> 
>> What's the output of:
>> fdisk -lu /dev/sda
> 
> I will look at it tonight. Thanks.

Good.

>> However, the way you are making partitions is quite complex
>> and the needed space could be somewhere else.

You did "mdadm -C /dev/md0 -v -e 0 -l 1 -n 2 /dev/sda1 /dev/sdb1"

Which is the usual way to set the /boot partition.

However, you did repartition md0, while still expecting to boot from md0.

That is "odd" to me. Just make a FS in md0 and use it as /boot (and root).
 
> Does this mean that this partitioning is not the right way to proceed?
> should I create all the partitions first and build them into so many
> /dev/md[01234] devices separately maybe?

I could tell you what seems to be a reasonable setup IMO:
	200Mb --> {sda1,sdb1} --> md1 --> RAID1 --> use as /boot
	5Gb   --> {sda2,sdb2} --> md2 --> RAID1 --> use as /
	2GB   --> independent sda3, sdb3  --> use as swap

		Use the rest as needed. One option is:
	rest --> {sda3,sdb3} --> md3 --> RAID1 --> LVM --> crete as many individual 
		disks as needed/wanted with lvcreate.

Having only two disks means to use only RAID1. RAID0 is too risky IMO as any 
disk failure means a complete loss of data.

>> Please, stop repeating your question everywhere.
 
> I am very sorry if I upset the community. I did not think that linux-raid,
> grub-devel and help-grub lists would represent the same experts. In fact,
> based on what I see on the GRUB sites is, that grub-devel experts are
> different from more like "legacy" supporting help-grub ones. Maybe a bit
> of clarification would help keeping the developers/maintainers email
> intake a bit lower. So I must ask: which one is the most appropriate for
> my question?

As I am not an expert in any sense of the word, I really can't tell you 
where to post. I am a common user which is trying to help you. But, in this 
list alone, there are three post from you with exactly the same content and 
question. If you are not getting any feedback, perhaps you should re-think 
of a different way to make your questions. And, please, allow more time for 
an answer.
Thanks for your cooperation.

-- 
Antonio Perez

