From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: md RAID5: Disk wrongly marked "spare", need to force re-add it
Date: Sun, 21 Apr 2013 18:45:39 +0800
Message-ID: <5173C353.6080008@fnarfbargle.com>
References: <516869D2.9030506@bucksch.org> <516B3077.9020507@schinagl.nl> <516B590C.5060807@bucksch.org> <516AE7A0.4070504@schinagl.nl> <516BD5E0.4040007@bucksch.org> <516FF25B.4000907@bucksch.org> <516FFC13.2030803@ultratux.net> <5171CB91.1040708@bucksch.org> <5171EED3.8030505@bucksch.org> <5171F52D.4040701@bucksch.org> <51739405.1060805@fnarfbargle.com> <5173A159.70202@bucksch.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5173A159.70202@bucksch.org>
Sender: linux-raid-owner@vger.kernel.org
To: Ben Bucksch <linux.news@bucksch.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 21/04/13 16:20, Ben Bucksch wrote:
> Brad Campbell wrote, On 21.04.2013 09:23:
>> As others have already told you, md does not go randomly kicking
>> drives from arrays. Your system had a failure of some kind which
>> caused the loss of two drives.
>
> You ignore the facts and do "mi mi mi" in face of bugs reports. 2
> different arrays lost 1 drive, both at the same time at reboot after the
> OS upgrade, and both drives are working fine. Facts.

Those are not facts, they are uninformed guesses at what happened. You 
have no facts other than something bad happened and two drives were 
ejected from the array. If you had actual facts then we'd have been able 
to assist you in determining what actually happened and how it might 
have been rectified.

> And even *if* they had a temporary error, my case shows why it's a *bug*
> to kick them out of the array. And it's a *bug* to not let me put them
> back in with data. Tons of other people have suffered dataloss because
> of various temporary, easily recoverable problems and these 2 bugs.

It's not a bug. It is working as intended. That it is not working the 
way _you_ would like it to work is not a bug at all.

When you have an array, you don't get "temporary errors". It's either 
good or its not. An error is an error is an error. You had an error, 
which means something in your storage stack is broken. That you can't 
figure out what it is is even more insidious and needs to be fixed 
before you can continue.

May I point you at the source of both the kernel and md and suggest if 
you'd like it to "work" differently you might attempt to make it do so.

Question. Have you ever worked with hardware arrays? What do you think 
would happen in the same set of circumstances with a hardware array 
(hint, precisely the same thing). The bonus with md is (if you know what 
you are doing and with the right assistance) you can do things like 
--create --assume-clean and get access to your data. You can't do that 
with any hardware array I've ever used.

> People like you are the reason why people like me suffer dataloss.

Riiiight.

Remember, and I quote "I have to do risky operations like re-create that 
can easily destroy all data. Effectively, md achieves the opposite that 
is intended: It actively risks and destroys my data."

So you knew the operation was risky, yet you went ahead without enough 
information to do it safely and blitzed all your data. I'm sorry, but 
that's not my fault.

Again : "Good news: In my desperation, I now ran the following dangerous 
command: mdadm --create /dev/md0 --assume-clean --level=raid5 -n 8 
--chunk=64 --layout=left-symmetric --metadata=0.90 /dev/sdj missing 
/dev/sdl /dev/sd[mopnq]"

How did you verify you had your disks in the correct order? Where did 
that command line come from?

This will be my last post on the subject. I pointed you at a path of 
action in my last post.

