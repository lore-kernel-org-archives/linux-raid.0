From: "NeilBrown" <neilb@suse.de>
Subject: Re: RAID-5 spare drive: Can't make spare persist across reboot
Date: Sun, 31 May 2009 08:44:07 +1000 (EST)
Message-ID: <f9fa44a3d9376b5e2b4c624bd36fab89.squirrel@neil.brown.name>
References: <984c80610905301137l7649391fg64a8108769abd216@mail.gmail.com>
    <18977.43758.674932.381022@notabene.brown>
    <984c80610905301526h6a71b79cyd1cb66c992db355a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <984c80610905301526h6a71b79cyd1cb66c992db355a@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Rea <dave@daverea.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, May 31, 2009 8:26 am, David Rea wrote:
> On Sat, May 30, 2009 at 5:53 PM, Neil Brown <neilb@suse.de> wrote:
>
>>> However, after a reboot, I'm back to 3 active and 0 spare drives.
>>> [snip]
>>
>> This should "just work". =A0There might be some hints in
>> /var/log/messages if you'd like to post that.
>
> Here is the output of `cat /var/log/messages | grep raid`:
> http://pastebin.ca/1441575

That isn't very useful.  Getting the whole /var/log/messasges
would be best - then I can see what isn't there as well as what is.
maybe
   grep -C 10 -E '(md|raid)' /var/log/messages
might be enough.

>
> It seems that raid5 only sees the sd[acd] as active drives, but
> doesn't pick up the spare.
>
>>> -- Is there any way to instantiate a superblock on /dev/sdb1 so tha=
t
>>> it can be associated with this array's UUID?
>>
>> You have already done that. =A0Use
>> =A0 mdadm --examine /dev/sdb
>> to confirm.
>
> This successfully identifies /dev/sdb1 as a spare:
> http://pastebin.ca/1441576
> However running `mdadm --examine /dev/sda` for example does not:
> http://pastebin.ca/1441578

That would be because the array was assembled without /dev/sdb1
so even if sda knew about it before, it will have been told to forget.

Is there a reason why you are using whole drives (sda, sdc, sdd) for
some devices, and just a partition (sdb1) for others?




> And running `mdadm --detail /dev/md0` also says no spares:
> http://pastebin.ca/1441579
>
> (let me know if you'd rather I paste these inline, for archival
> purposes or what have you)

Inline is generally easier to work with, unless things are huge.


NeilBrown



>
>>> -- I have the ARRAY line (in mdadm.conf) specified by UUID; could t=
his
>>> be causing the spare to be excluded, since it (presumably) does not
>>> have a superblock?
>>
>> No. =A0And it does have a superblock.
>
> Gotcha, I stand corrected! I guess at this point I just need to figur=
e
> out how to get the spare to recognize on bootup, since it's already
> got the same UUID and is listed in mdadm.conf:
> http://pastebin.ca/1441588
>
> Thanks again for your help,
> Dave
>

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
