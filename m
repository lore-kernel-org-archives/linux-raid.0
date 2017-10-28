From: Jun-Kai Teoh <kai.teoh@gmail.com>
Subject: Re: Raid 5 array down/missing - went through wiki steps
Date: Sat, 28 Oct 2017 15:15:11 -0700
Message-ID: <CAA4aoFatrJQFPHOUm9C6LjUAeNkSE9eH08T8xphuYNPErVg=QQ@mail.gmail.com>
References: <CAA4aoFardnK8fOck4kkCWeYNZc=8-03FJzn6KxS6K9wuYN5bdg@mail.gmail.com>
 <e917e077-a87e-5322-68dd-e25b53bf7678@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e917e077-a87e-5322-68dd-e25b53bf7678@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Anthony Youngman <antlists@youngman.org.uk>
Cc: mdraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Thanks for the response Anthony & Mark, really appreciate how helpful
both of you are.

I did try to reassemble last night (before I found the wiki and all)
and it would assemble, but then it'll say it can't bring the array up
6 drives with 1 rebuilding, and the array thinks that there should be
8 drives. Does that mean I'm... screwed?

mdadm version (mdadm --version)
mdadm - v3.3 - 3rd September 2013

kernel (uname -mrsn)
Linux livingrm-server 4.4.0-97-generic x86_64

distro
Ubuntu 16.04 LTS

On Sat, Oct 28, 2017 at 3:04 PM, Anthony Youngman
<antlists@youngman.org.uk> wrote:
> On 28/10/17 19:36, Jun-Kai Teoh wrote:
>>
>> Hi all,
>>
>> Hope this email is going to the right place.
>>
>> I'll cut to the chase - I added a drive to my RAID 5 and was resyncing
>> when my machine was abruptly powered down. Upon booting it up again,
>> my RAID array is now missing.
>>
>
> I've seen Mark's replies, so ...
>
>> I've followed the instructions that I've found on the wiki, and it
>> hasn't solved my issues, but it's given me a sense of the things that
>> I'm hoping can help you guys help me troubleshoot.
>>
> Found where? Did you look at the front page? Did you look at "When things go
> wrogn"?
>
>> My array can't be assembled. It tells me that the superblock on
>> /dev/sda doesn't match the others.
>>
>> /dev/sda thinks the array has 7 drives
>> /dev/sd[bcefghi] thinks the array has 8 drives
>>
> The event count tells me sda was kicked out of the array a LONG time ago -
> you were running a degraded array, sorry.
>
>> /dev/sda was not being reshaped
>> /dev/sd[bcefghi] has reshape position data in the raid.status file
>>
>> both /dev/sda and /dev/sdh think their device role is Active device 2
>>
>> I can't bring /dev/md126 back up with sd[bcefghi] as it'll tell me
>> that there are 6 drives and 1 rebuilding, not enough to start the
>> array
>>
>> My mdadm.conf shows a /dev/dev/127 with very minimal info in it - does
>> not look right to me.
>>
>> I haven't zeroed the superblock, nor have I tried a clean-assemble
>> either. I saw the wiki say I should email the group if I've gotten
>> that far and I'm panicking and nothing's working. So...
>>
>> Help me out, pretty please?
>
>
> Okay, I *think* you're going to be okay. The powerfail brought the machine
> down, and because the array was degraded, it wouldn't re-assemble. Like
> Mark, I'd wait for the experts to get on the case on Monday, but what I
> think they will advise is
>
> One - --assemble --force [bcdefghi] - note do NOT include the failed drive
> a. This will fire off the reshape again. BUT. On a degraded array you have
> no redundancy!!!
>
> Two - ADD ANOTHER DRIVE TO REPLACE SDA !!!
>
> I don't know how to read the smartctl statistics (and I don't know which one
> is sda!), but if I were you I would fire off a self-test on sda to find out
> whether it's bad or not. It may have been kicked out by a harmless glitch,
> or it may be ready to fail permanently. But be prepared to shell out for a
> replacement. In fact, I'd go out and get another drive right now. If sda
> turns out to be okay, you can go to a 9-drive raid-6.
>
> To cut a long story short, I think you've been running with a degraded array
> for a long time. You should be able to force-assemble it no problem but you
> need to fix it asap. And then you should go raid-6 to give you a bit extra
> safety and set up scrubbing! Again, I'll let the experts confirm, but I
> think going from 8-drives-degraded to 9-drive-raid-6 in one step is probably
> better than recovering your raid 5 and then adding another drive to go raid
> 6.
>
> Just wait for the experts to confirm this and then I think you'll be okay.
> On the good side, you do have proper raid drives - WD Reds :-)
>
> Cheers,
> Wol
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
