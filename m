From: Kenneth Emerson <kenneth.emerson@gmail.com>
Subject: md metadata nightmare
Date: Wed, 23 Nov 2011 16:38:02 -0600
Message-ID: <CADzwnhV219RXdM-hB3m-6EbzrE+hBVsEQu--rpXtbdDefAtJMA@mail.gmail.com>
References: <CADzwnhXWvkVC13ZEJj8L0O6PLXLS6uhoBXqoLp67YwmeU60sQQ@mail.gmail.com>
	<20111123114743.1085889e@notabene.brown>
	<CADzwnhUJ7HbZH9yqa6x9sHFLo8Vg=1k_SyzvZyq2=iQ5YRLhZQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADzwnhUJ7HbZH9yqa6x9sHFLo8Vg=1k_SyzvZyq2=iQ5YRLhZQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Nov 22, 2011 at 6:47 PM, NeilBrown <neilb@suse.de> wrote:
> On Tue, 22 Nov 2011 18:05:21 -0600 Kenneth Emerson
> <kenneth.emerson@gmail.com> wrote:
>
>> NOTE: I have set the linux-raid flag on all of the partitions in the
>> GPT. I think I have read in the linux-raid archives that this is not
>> recommended. Could this have had an affect on what transpired?
>
> Net recommended, but also totally ineffective. =A0The Linux-RAID part=
ition type
> is only recognised in MS-DOS partition tables.
>
I will remove these flags.
>>
>> So my question is:
>>
>> Is there a way, short of backing up the data, completely rebuilding
>> the arrays, and restoring the data (a real PIA) to rewrite the
>> metadata given the existing array configurations in the running
>> system? =A0Also, is there an explanation as to why the metadata seem=
s so
>> screwed up that the arrays cannot be assembled automatically by the
>> kernel?
>
> There appear to be two problems here. =A0Both could be resolved by co=
nverting to
> v1.0 metadata. =A0But there are other approaches. =A0And converting t=
o v1.0 is
> not trivial (not enough developers to work on all the tasks!).
>

Here, I assume you mean providing a utility to upgrade the metatdata
is daunting since
below you give me instructions on how to do this with a brute-force met=
hod.

> One problem is the final partition on at least some of your disks is =
at a 64K
> alignment. =A0This means that the superblock looks valid for both the=
 whole
> device and for the partition.
> You can confirm this by running
> =A0mdadm --examine /dev/sda
> =A0mdadm --examine /dev/sda4
>
> (ditto for b,c,d,e,...)
>
> The "sdX4" should show a superblock. =A0The 'sdX' should not.
> I think it will show exactly the same superblock. =A0It could show a =
different
> superblock... that would be interesting.
>

I still have not re-installed the original sda drive, but the sde
drive (which is now sdd)
showed the similar problem where the kernel tried to build an array
with the entire drive.
When I look at the --examine on sdd and on sdd4 (and sdd1,2,3 as
well), none are exactly
the same (I assume that the output would be exactly the same if it
were the same superblock).
I get different UUID's and time stamps as well as RAID types.

> If I am correct here then you can "fix" this by changing mdadm.conf t=
o read:
>
> DEVICES /dev/sda? /dev/sdb? /dev/sdc? /dev/sdd? /dev/sde?
> or
> DEVICES /dev/sd[abcde][1-4]
>
> or similar. =A0i.e. tell it to ignore the whole devices.

I actually did this at one time, and it was better, but it still did
not assemble the correct arrays.
I will, however, change my current .conf file to ignore the whole drive=
s.

>
> The other problem is that v0.90 metadata isn't good with very large d=
evices.
> It has 32bits to record kilobytes per device.
> This show allow 4TB per device but due to a bug (relating to sign bit=
s) it
> only works well with 2TB per device. =A0This bug was introduced in 2.=
6.29 and
> removed in 3.1.
>
> So if you can run a 3.1.2 kernel, that would be best.
>

OK. Now you have me worried. =A0Is this "bug"=A0benign or is it a ticki=
ng
time bomb? =A0If I do
the conversion (below) to version 1.0 will that circumvent the problem?

> You could convert to v1.0 if you want. =A0You only need to do this fo=
r the last
> partition (sdX4).
>
> Assuming nothing has changed since the "--detail" output you provided=
, you
> should:
>
> =A0mdadm -S /dev/md3
> =A0mdadm -C /dev/md3 --metadata=3D1.0 --chunk=3D64k --level=3D6 --rai=
d-devices=3D5 \
> =A0 =A0 =A0missing /dev/sdb4 /dev/sdc4 /dev/sda4 /dev/sdd4 \
> =A0 =A0 =A0--assume-clean
>
> The order of the disks is import. =A0You should compare it with the o=
utput
> of "mdadm --detail" before you start to ensure that it is correct and=
 I have
> made any typos. =A0You should of course check the rest as well.
> After doing this (and possibly before) you should 'fsck' to ensure th=
e
> transition was successful. =A0If anything goes wrong, ask before risk=
ing
> further breakage.
>

I will do this conversion; but I will backup my data as best I can
first, just in case.
I still have the 5 1TB drives and my data should fit on there, just a
PIA to do it.
(Ahh, that's what weekends are for, right?)
After the RAID6 is repaired and running OK, I believe I will rebuild
the 2 RAID1 arrays
as that will be an easy project (since I have 5 copies of everything)
which will get rid of
all vestiges of previous raid arrays. =A0Do I need to anything special
other than zeroing
the superblocks (--zero-superblock)? =A0Also, shouldn't I do that on th=
e
RAID6 array before
doing the create or is that done automagically?

> Good luck.
>

Hopefully, luck has nothing to do with it, but I'll take it where I
can get it. =A0Lucky is
better than good any day in my book. =A0;-)
Thank you very much for your insight and experience. =A0I'll let you
know how it turns out.

-- Ken Emerson

> NeilBrown
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
