From: "Majed B." <majedb@gmail.com>
Subject: Re: 2 Disks Jumped Out While Reshaping RAID5
Date: Sun, 6 Sep 2009 13:00:18 +0300
Message-ID: <70ed7c3e0909060300la51bec3ke51c35373b2ee1fc@mail.gmail.com>
References: <70ed7c3e0909051322l7cf66158lbbc8a5dd2cc18b8b@mail.gmail.com>
	<a6dfa0829c75cc81fd4482bb344bbff2.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <a6dfa0829c75cc81fd4482bb344bbff2.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I forgot to mention that I'm running mdadm 2.6.7.1 (latest in Ubuntu
Server repositories).

I tried forcing the assembly, but as mentioned, I just got an error:
root@Adam:/var/www# mdadm -Af /dev/md0
mdadm: superblock on /dev/sdh1 doesn't match others - assembly aborted

I know I could've pasted whatever I wrote here, but it seemed
redundant. I'll keep your hint in mind for the next time, if any
(hopefully not).

This may be of an interest to you:
root@Adam:/var/www# mdadm -E /dev/sd[a-h]1 | grep Reshap
sda1  Reshape pos'n : 3357066496 (3201.55 GiB 3437.64 GB)
sdb1  Reshape pos'n : 3357066496 (3201.55 GiB 3437.64 GB)
sdc1  Reshape pos'n : 3357066496 (3201.55 GiB 3437.64 GB)
sdd1  Reshape pos'n : 3357066496 (3201.55 GiB 3437.64 GB)
sde1  Reshape pos'n : 3357066496 (3201.55 GiB 3437.64 GB)
sdf1   Reshape pos'n : 3357066496 (3201.55 GiB 3437.64 GB)
sdg1  Reshape pos'n : 2554257664 (2435.93 GiB 2615.56 GB)
sdh1  Reshape pos'n : 3357066496 (3201.55 GiB 3437.64 GB)

Note that sdd1 was the spare.

The UUIDs are all the same and the superblock is all similar except
for the reshaping position of sdg1.

I didn't try to recreate the array as I've never faced this issue
before, so I don't know what kind of repercussions it may have.

What I do know, that at the worst case scenario, I can recreate the
array out of 7 disks (all but sdg1), but lose about 2.3TB worth of
data :(

On Sun, Sep 6, 2009 at 12:32 AM, NeilBrown<neilb@suse.de> wrote:
> On Sun, September 6, 2009 6:22 am, Majed B. wrote:
>> Hello all,
>>
>> I have posted my problem already here:
>> http://ubuntuforums.org/showthread.php?p=3D7900571#post7900571
>> It also has file attachments of the output of mdadm -E /dev/sd[a-h]1
>
> It seems that you need to log in to read the attachements... so I hav=
en't.
>
>>
>> I appreciate any help on this.
>
> Hopefully you just need to add "--force" to the assemble command
> and it would all just work. =C2=A0However I haven't tested that on an=
 array
> that is in the process of a reshape so I cannot promise.
> I might try to reproduce your situation and with some scratch drives
> and check that mdadm -Af does the right thing, but it won't be a day
> or so, and as I cannot see the --examine output I might get the
> situation a bit wrong ... (hint hint: it is always best to post
> full information rather than pointers to it, unless said information =
is
> really really big).
>
> NeilBrown

--=20
       Majed B.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
