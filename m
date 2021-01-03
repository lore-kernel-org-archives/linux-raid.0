Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74790C433DB
	for <linux-raid@archiver.kernel.org>; Sun,  3 Jan 2021 20:27:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2EEE520780
	for <linux-raid@archiver.kernel.org>; Sun,  3 Jan 2021 20:27:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726855AbhACU1i (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 3 Jan 2021 15:27:38 -0500
Received: from smtp.hosts.co.uk ([85.233.160.19]:9498 "EHLO smtp.hosts.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726265AbhACU1i (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Sun, 3 Jan 2021 15:27:38 -0500
Received: from host86-158-105-41.range86-158.btcentralplus.com ([86.158.105.41] helo=[192.168.1.65])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1kw9xk-0001Es-9L; Sun, 03 Jan 2021 20:26:53 +0000
Subject: Re: Raid working but stuck at 99.9%
To:     Teejay <teejay@gizzy.co.uk>, antlists <antlists@youngman.org.uk>,
        linux-raid@vger.kernel.org
References: <11a6cdb6-ab69-ec4d-8ffb-b92d80d5b03f@gizzy.co.uk>
 <0d41bab4-e051-cccb-3a63-e77c258ef78f@youngman.org.uk>
 <33f592e7-3408-4f9b-7146-11af526b1af8@gizzy.co.uk>
From:   antlists <antlists@youngman.org.uk>
Message-ID: <788a1d77-1712-be55-8a66-dc900fd6176e@youngman.org.uk>
Date:   Sun, 3 Jan 2021 20:26:55 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <33f592e7-3408-4f9b-7146-11af526b1af8@gizzy.co.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 02/01/2021 23:10, Teejay wrote:
> On 02/01/2021 19:32, antlists wrote:
>> On 02/01/2021 12:37, Teejay wrote:
>>> Hi,
> 
> Point taken, but it is what it is and I need to fix it. The internet is 
> full of advice about RAID - most of it contradicts itself as there is 
> little real consensus (welcome to the 21st Century :-) . As a newbie, I 
> went with what seemed right at the time. I concede I made a bad call. 
> Let's move on.
> 
That's why I took on updating the wiki. To try and provide an up-to-date 
reference site. Problem is, like you did, people usually find the old 
duff stuff first.
>>>
>>> To upgrade the array I used the following command:
>>>
>>> sudo mdadm --grow /dev/md0 --level=5 --raid-devices=5 --add /dev/sde 
>>> /dev/sdf --backup-file=/tmp/grow_md0.bak
>>>
>>> To my surprise it returned almost instantly with no errors. So I had 
>>> a look at the status:

Did your example tell you to use --backup-file? If it did, I hope it 
wasn't the wiki!

If the --grow told you it needed a backup, I'd be surprised but if it 
asks for it it needs it.

Once you were trying to fix things, it would be normal for it to ask for 
the backup you originally gave it ...
>>>
>>> less /proc/mdstat
>>>
>>> and it came back as being a raid 5 array and stated that it was 
>>> reshape = 0.01% and would take several million minutes to complete! 
>>> Somewhat concerned, I left it for half an hour and tried again only 
>>> to find that the number of complete blocks was the same and the time 
>>> had grown to an even more crazy number. It was clear the process had 
>>> stalled.
>>
>> uname -a ?
> 
> Linux lounge 5.4.0-58-generic #64-Ubuntu SMP Wed Dec 9 08:16:25 UTC 2020 
> x86_64 x86_64 x86_64 GNU/Linux
> 
>> mdadm --version ?
> 
> mdadm - v4.1 - 2018-10-01
> 
>>
>> This sounds similar to a problem we've regularly seen with raid-5. And 
>> it's noticeable with older Ubuntus.
> 
> My install of Ubuntu is not that old is it? - and it has all the 
> official updates.
> 
> lsb_release -a
> 
> Distributor ID:    Ubuntu
> Description:    Ubuntu 20.04.1 LTS
> Release:    20.04
> Codename:    focal
> 
That's new enough. So it's not (I hope) that problem.
>>>
>>
>> Ahhhhh ... you MAY be able to RMA them. What are they? If they're WD 
>> Reds I'd RMA them as a matter of course as "unfit for purpose". If 
>> they're BarraCudas, well, tough luck but you might get away with it. 
> RMA? - Newbie here!

Well, I don't know what the letters stand for, but the expression is a 
pretty standard term for "return to supplier". If you return anything 
that is defective, the supplier will usually ask you to "fill in an RMA".
> 
>>
>> Okay. What are those drives? I'm *guessing* your original three drives 
>> were WD Reds. What is the type number? If they're Reds this ends in 
>> EFAX or EFRX, if I remember correctly. I think EFAX are good and EFRX 
>> are bad. It could be the other way round ...
> 
> That means little to me. This is what I know: The four drives that form 
> the working array are the three original ones and one of the new ones. 
> Non of them are Reds. They are all the same Seagate drives, though it is 
> possible they are different internally as they were purchased at 
> different times, I have not opened them up. The Array is working and 
> AFAIK it is all there, I can find not evidence to the contrary. It 
> mounts (I have only tried Read Only), and I can access the data, with 
> not apparent issues.
> 
Dare I suggest you need to read this page ...

http://www.catb.org/~esr/faqs/smart-questions.html

If you haven't come across ESR he may be a bit of a nutter, but he is an 
extremely good psychologist - it is well worth reading!

I gave you a link. If you went there, the very first link in it gave you 
some advice - https://raid.wiki.kernel.org/index.php/Asking_for_help

YOU DIDN'T FOLLOW IT.

One of the things it asks for is the smartctl info for your drives - ALL 
OF THEM. It'll tell you the model number of your drives. How many 
different models do you have? Are they SMR? Google the model numbers and 
see if you can find out! If you come back and say you can't make head or 
tail of what you've found, that's fine. What's not fine is if you don't try.
> 
>>
>>> I need to somehow get back to a useful state. If I could get back to 
>>> level 0 with three drives that would be great. I could then delete 
>>> some junk and then backup the data the other two drives using rsync 
>>> or something.
>>>
>>> So I guess my questions are
>>>
>>> 1 - Can I safely get back to a three drive level 0 RAID thereby 
>>> freeing the two drives I added to allow me to make a backup of the data?
>>
>> I'll let others comment.
>>
>>> 2 - Even if I can revert, should I move my data and no longer even 
>>> use RAID 0 until I can get some decent hard drives?
>>
>> Don't mess with it yet.
>>
>>> 3 - Any other cunning ideas, at the moment I think my only option, if 
>>> I can't revert, which is to buy many TB's of storage to back up the 
>>> read only file system, which I can ill afford to do!
>>
Okay, to throw another option into the mix, get that 12TB BarraCuda, and 
copy your data across as your main drive. You're probably better off 
with an IronWolf, but I don't know if they come as a 12TB and they'd 
cost rather more ...

Then you can combine the other drives with btrfs as a backup volume. 
That way, if the 12TB breaks you've got a backup, and if one of the 4TBs 
break, btrfs means you only lose what's on that disk (which is "backed 
up" on your live disk ...)
> 
> Sounds like you misunderstood what I wrote; sarcasm is not a great way 
> of helping someone, especially when you only half read the email!
> 
Sorry, I don't mean to be sarcastic, and offering to spend more money 
usually gets vendors on side ...

> again let's move on!
> 
and imho, you NEED to back up your data, which I think means spending 
money, whether you can afford it or not :-(

I personally don't have experience playing with broken arrays (unlike 
others on this list), so I don't want to advise you to do something that 
trashes your array and loses everything ...
>>>
> 
> I did read the wiki, promise! More than once! - it does not seem to 
> cover my situation, or if it does, it makes a very good job of hiding 
> it. Like many such sites is was clearly written by someone that knows 
> exactly how everything works and forgets that the reader will not 
> necessary have a similar level of knowledge, in other words, it is not 
> for written for novices. It uses many abbreviations and has an 
> assumption of knowledge that is way beyond mine. Asking for stuff if 
> fine, but not much help if you don't know what it is asking for. While I 
> really appreciate the help, it is not useful if you to go on the 
> offensive. I said up front that I am a newbie. The best piece of advice 
> I could find on the wiki was not to do anything unless I was sure and to 
> ask for help first, thus the email. Unfortunately, I did not find the 
> wiki in time to avoid getting in to the mess, but when I did I followed 
> the advice and asked for help -  so all I ask is for some help getting 
> out of this mess. If you need more info, I will do my best to provide it 
> but please remember I am at the bottom looking up, and the view from 
> down here is not as clear as the view from where you stand; I understand 
> it can be difficult to remember that, I am an engineer too, just not one 
> that know anything about RAID :)
> 
You describe exactly how I often feel, so we do understand. And yes, 
when your raid isn't working properly I can understand the panic. Let's 
work out WHAT is wrong. I'm hoping, if your drives were purchased at 
different times, the problem might be the new drives only are SMR. If it 
looks like something I'm not happy dealing with, I can kick it up to 
people who have more experience.

Cheers,
Wol
