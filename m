From: Tim Bostrom <tbostrom@gmail.com>
Subject: Re: RAID 5 array recovery - two drives errors in external enclosure
Date: Thu, 17 Sep 2009 16:11:32 -0700
Message-ID: <2267211f0909171611m4b4a0d02p81b80bc882a0855@mail.gmail.com>
References: <2267211f0909171342g6ebf68a2y393daa587e59c714@mail.gmail.com>
	<20090917212252.GC19611@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090917212252.GC19611@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I re-cabled the drives so that they show up as the same drive letter
as they were before when in the enclosure.

I then went ahead and tried your idea of restarting the array. I tried
this first:

mdadm -C /dev/md0 -l 5 -n 5 -c 256 /dev/sd[bcde]1 missing

mount -o ro /dev/md0 /mnt/teradata

/var/log/messages:
-----------------
Sep 17 16:07:09 tera kernel: md: bind<sdb1>
Sep 17 16:07:09 tera kernel: md: bind<sdc1>
Sep 17 16:07:09 tera kernel: md: bind<sdd1>
Sep 17 16:07:09 tera kernel: md: bind<sde1>
Sep 17 16:07:09 tera kernel: raid5: device sde1 operational as raid dis=
k 3
Sep 17 16:07:09 tera kernel: raid5: device sdd1 operational as raid dis=
k 2
Sep 17 16:07:09 tera kernel: raid5: device sdc1 operational as raid dis=
k 1
Sep 17 16:07:09 tera kernel: raid5: device sdb1 operational as raid dis=
k 0
Sep 17 16:07:09 tera kernel: raid5: allocated 5268kB for md0
Sep 17 16:07:09 tera kernel: raid5: raid level 5 set md0 active with 4
out of 5 devices, algorithm 2
Sep 17 16:07:09 tera kernel: RAID5 conf printout:
Sep 17 16:07:09 tera kernel: --- rd:5 wd:4
Sep 17 16:07:09 tera kernel: disk 0, o:1, dev:sdb1
Sep 17 16:07:09 tera kernel: disk 1, o:1, dev:sdc1
Sep 17 16:07:09 tera kernel: disk 2, o:1, dev:sdd1
Sep 17 16:07:09 tera kernel: disk 3, o:1, dev:sde1
Sep 17 16:07:56 tera kernel: EXT3-fs error (device md0):
ext3_check_descriptors: Block bitmap for group 8064 not in group
(block 532677632)!
Sep 17 16:07:56 tera kernel: EXT3-fs: group descriptors corrupted!
--------------------------------


I then tried a few more permutations of the command:
mdadm -C /dev/md0 -l 5 -n 5 -c 256 /dev/sd[bdce]1 missing
mdadm -C /dev/md0 -l 5 -n 5 -c 256 /dev/sd[bdec]1 missing
mdadm -C /dev/md0 -l 5 -n 5 -c 256 /dev/sd[becd]1 missing

Every time I changed the order, it would still print the order the
same in the log:

Sep 17 16:02:52 tera kernel: md: bind<sdb1>
Sep 17 16:02:52 tera kernel: md: bind<sdc1>
Sep 17 16:02:52 tera kernel: md: bind<sdd1>
Sep 17 16:02:52 tera kernel: md: bind<sde1>
Sep 17 16:02:52 tera kernel: raid5: device sde1 operational as raid dis=
k 3
Sep 17 16:02:52 tera kernel: raid5: device sdd1 operational as raid dis=
k 2
Sep 17 16:02:52 tera kernel: raid5: device sdc1 operational as raid dis=
k 1
Sep 17 16:02:52 tera kernel: raid5: device sdb1 operational as raid dis=
k 0
Sep 17 16:02:52 tera kernel: raid5: allocated 5268kB for md0
Sep 17 16:02:52 tera kernel: raid5: raid level 5 set md0 active with 4
out of 5 devices, algorithm 2
Sep 17 16:02:52 tera kernel: RAID5 conf printout:
Sep 17 16:02:52 tera kernel: --- rd:5 wd:4
Sep 17 16:02:52 tera kernel: disk 0, o:1, dev:sdb1
Sep 17 16:02:52 tera kernel: disk 1, o:1, dev:sdc1
Sep 17 16:02:52 tera kernel: disk 2, o:1, dev:sdd1
Sep 17 16:02:52 tera kernel: disk 3, o:1, dev:sde1



Am I doing something wrong?




On Thu, Sep 17, 2009 at 2:22 PM, Robin Hill <robin@robinhill.me.uk> wro=
te:
> On Thu Sep 17, 2009 at 01:42:30PM -0700, Tim Bostrom wrote:
>
>> OK,
>>
>> Let me start off by saying - I panicked. =A0Rule #1 - don't panic. =A0=
I
>> did. =A0Sorry.
>>
>> I have a RAID 5 array running on Fedora 10.
>> (Linux tera.teambostrom.com 2.6.27.30-170.2.82.fc10.i686 #1 SMP Mon
>> Aug 17 08:38:59 EDT 2009 i686 athlon i386 GNU/Linux)
>>
>> 5 drives in an external enclosure (AMS eSATA Venus T5). =A0It's a
>> Sil4726 inside the enclosure running to a Sil3132 controller via eSA=
TA
>> in the desktop. =A0I had been running this setup for just over a yea=
r.
>> Was working fine. =A0 I just moved into a new home and had my server
>> down for a while =A0- before I brought it back online, I got a "grea=
t
>> idea" to blow out the dust from the enclosure using compressed air.
>> When I finally brought up the array again, I noticed that drives wer=
e
>> missing. =A0Tried re-adding the drives to the array and had some iss=
ues
>> - they seemed to get added but after a short time of rebuilding the
>> array, I would get a bunch of HW resets in dmesg and then the array
>> would kick out drives and stop.
>>
> <- much snippage ->
>
>> I popped the drives out of the enclosure and into the actual tower
>> case and connected each of them to its own SATA port. =A0The HW rese=
ts
>> seemed to go away, but I couldn't get the array to come back online.
>> =A0Then I did the stupid panic (following someone's advice I shouldn=
't
>> have).
>>
>> thinking I should just re-create the array, I did:
>>
>> mdadm --create /dev/md0 --level=3D5 --raid-devices=3D5 /dev/sd[b-f]1
>>
>> Stupid me again - ignores the warning that it belongs to an array
>> already. =A0I let it build for a minute or so and then tried to moun=
t it
>> while rebuilding... and got error messages:
>>
>> EXT3-fs: unable to read superblock
>> EXT3-fs: md0: couldn't mount because of unsupported optional feature=
s
>> (3fd18e00).
>>
>> Now - I'm at a loss. =A0I'm afraid to do anything else. =A0 I've bee=
n
>> viewing the FAQ and I have a few ideas, but I'm just more freaked. =A0=
Is
>> there any hope? =A0What should I do next without causing more troubl=
e?
>>
> Looking at the mdadm output, there's a couple of possible errors.
> Firstly, your newly created array has a different chunksize than your
> original one. =A0Secondly, the drives may be in the wrong order. =A0I=
n
> either case, providing you don't _actually_ have any faulty drives, t=
hen
> it should be (mostly) recoverable.
>
> Given the order you specified the drives in the create, sdf1 will be =
the
> partition that's been trashed by the rebuild, so you'll want to leave
> that out altogether for now.
>
> You need to try to recreate the array with the correct chunk size and
> with the remaining drives in different orders, running a read-only
> filesystem check each time until you find the correct order.
>
> So start with:
> =A0 =A0mdadm -C /dev/md0 -l 5 -n 5 -c 256 /dev/sd[bcde]1 missing
>
> Then repeat for every possible order of the four disks and "missing",
> stopping the array each time if the mount fails.
>
> When you've finally found the correct order, you can re-add sdf1 to g=
et
> the array back to normal.
>
> HTH,
> =A0 =A0Robin
> --
> =A0 =A0 ___
> =A0 =A0( ' } =A0 =A0 | =A0 =A0 =A0 Robin Hill =A0 =A0 =A0 =A0<robin@r=
obinhill.me.uk> |
> =A0 / / ) =A0 =A0 =A0| Little Jim says .... =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0|
> =A0// !! =A0 =A0 =A0 | =A0 =A0 =A0"He fallen in de water !!" =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 |
>



--=20
-tim
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
