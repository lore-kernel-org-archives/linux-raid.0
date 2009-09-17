From: Tim Bostrom <tbostrom@gmail.com>
Subject: Re: RAID 5 array recovery - two drives errors in external enclosure
Date: Thu, 17 Sep 2009 16:54:55 -0700
Message-ID: <2267211f0909171654v766e658fn620b23268a2393a6@mail.gmail.com>
References: <2267211f0909171342g6ebf68a2y393daa587e59c714@mail.gmail.com>
	<20090917212252.GC19611@cthulhu.home.robinhill.me.uk> <2267211f0909171611m4b4a0d02p81b80bc882a0855@mail.gmail.com>
	<70ed7c3e0909171628w4040ae5cydf4335adb51f2b7d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <70ed7c3e0909171628w4040ae5cydf4335adb51f2b7d@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

It's still showing the order that you had previously posted:  [bcde]
(see log below)

It appears that trying different permutations isn't yielding any
change.  I haven't tried every permutation, but are these commands
supposed to yield different effects?  They seem to always build the
array as [bcde] no matter what.  Or should I be swapping around the
cables on the drives?

>> mdadm -C /dev/md0 -l 5 -n 5 -c 256 /dev/sd[bdce]1 missing
>> mdadm -C /dev/md0 -l 5 -n 5 -c 256 /dev/sd[bdec]1 missing
>> mdadm -C /dev/md0 -l 5 -n 5 -c 256 /dev/sd[becd]1 missing


-Tim

[root@tera ~]# mdadm --examine /dev/sdb1
/dev/sdb1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 9fefb6ce:dcbfe649:f456b3f0:371e8bcc
  Creation Time : Thu Sep 17 16:13:45 2009
     Raid Level : raid5
  Used Dev Size : 976759808 (931.51 GiB 1000.20 GB)
     Array Size : 3907039232 (3726.04 GiB 4000.81 GB)
   Raid Devices : 5
  Total Devices : 5
Preferred Minor : 0

    Update Time : Thu Sep 17 16:13:45 2009
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 1
  Spare Devices : 0
       Checksum : 20f1deab - correct
         Events : 1

         Layout : left-symmetric
     Chunk Size : 256K

      Number   Major   Minor   RaidDevice State
this     0       8       17        0      active sync   /dev/sdb1

   0     0       8       17        0      active sync   /dev/sdb1
   1     1       8       33        1      active sync   /dev/sdc1
   2     2       8       49        2      active sync   /dev/sdd1
   3     3       8       65        3      active sync   /dev/sde1
   4     4       0        0        4      faulty



On Thu, Sep 17, 2009 at 4:28 PM, Majed B. <majedb@gmail.com> wrote:
> Before creating the array, did you re-examine the disks with mdadm an=
d
> made sure of each disk's position in the array?
>
> After your recabling, the disk names may have changed again.
>
> mdadm --examine /dev/sdb1
>
> =A0 =A0 =A0Number =A0 Major =A0 Minor =A0 RaidDevice State
> this =A0 =A0 7 =A0 =A0 =A0 8 =A0 =A0 =A0 17 =A0 =A0 =A0 =A07 =A0 =A0 =
=A0active sync =A0 /dev/sdb1
>
> =A0 0 =A0 =A0 0 =A0 =A0 =A0 8 =A0 =A0 =A0113 =A0 =A0 =A0 =A00 =A0 =A0=
 =A0active sync =A0 /dev/sdh1
> =A0 1 =A0 =A0 1 =A0 =A0 =A0 8 =A0 =A0 =A0 97 =A0 =A0 =A0 =A01 =A0 =A0=
 =A0active sync =A0 /dev/sdg1
> =A0 2 =A0 =A0 2 =A0 =A0 =A0 0 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A02 =A0 =A0=
 =A0faulty removed
> =A0 3 =A0 =A0 3 =A0 =A0 =A0 0 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A03 =A0 =A0=
 =A0faulty removed
> =A0 4 =A0 =A0 4 =A0 =A0 =A0 8 =A0 =A0 =A0 33 =A0 =A0 =A0 =A04 =A0 =A0=
 =A0active sync =A0 /dev/sdc1
> =A0 5 =A0 =A0 5 =A0 =A0 =A0 8 =A0 =A0 =A0 65 =A0 =A0 =A0 =A05 =A0 =A0=
 =A0active sync =A0 /dev/sde1
> =A0 6 =A0 =A0 6 =A0 =A0 =A0 8 =A0 =A0 =A0 49 =A0 =A0 =A0 =A06 =A0 =A0=
 =A0active sync =A0 /dev/sdd1
> =A0 7 =A0 =A0 7 =A0 =A0 =A0 8 =A0 =A0 =A0 17 =A0 =A0 =A0 =A07 =A0 =A0=
 =A0active sync =A0 /dev/sdb1
>
> (That's the output of an array I'm working on)
>
> Notice the first line: *this* and then the value of RaidDevice. That'=
s
> the position of the partition in the array. 0 is first, 1 is second,
> and so on.
>
> In my case, the order is: sdh1,sdg1,missing,missing,sdc1,sde1,sdd1,sd=
b1
>
> On Fri, Sep 18, 2009 at 2:11 AM, Tim Bostrom <tbostrom@gmail.com> wro=
te:
>> I re-cabled the drives so that they show up as the same drive letter
>> as they were before when in the enclosure.
>>
>> I then went ahead and tried your idea of restarting the array. I tri=
ed
>> this first:
>>
>> mdadm -C /dev/md0 -l 5 -n 5 -c 256 /dev/sd[bcde]1 missing
>>
>> mount -o ro /dev/md0 /mnt/teradata
>>
>> /var/log/messages:
>> -----------------
>> Sep 17 16:07:09 tera kernel: md: bind<sdb1>
>> Sep 17 16:07:09 tera kernel: md: bind<sdc1>
>> Sep 17 16:07:09 tera kernel: md: bind<sdd1>
>> Sep 17 16:07:09 tera kernel: md: bind<sde1>
>> Sep 17 16:07:09 tera kernel: raid5: device sde1 operational as raid =
disk 3
>> Sep 17 16:07:09 tera kernel: raid5: device sdd1 operational as raid =
disk 2
>> Sep 17 16:07:09 tera kernel: raid5: device sdc1 operational as raid =
disk 1
>> Sep 17 16:07:09 tera kernel: raid5: device sdb1 operational as raid =
disk 0
>> Sep 17 16:07:09 tera kernel: raid5: allocated 5268kB for md0
>> Sep 17 16:07:09 tera kernel: raid5: raid level 5 set md0 active with=
 4
>> out of 5 devices, algorithm 2
>> Sep 17 16:07:09 tera kernel: RAID5 conf printout:
>> Sep 17 16:07:09 tera kernel: --- rd:5 wd:4
>> Sep 17 16:07:09 tera kernel: disk 0, o:1, dev:sdb1
>> Sep 17 16:07:09 tera kernel: disk 1, o:1, dev:sdc1
>> Sep 17 16:07:09 tera kernel: disk 2, o:1, dev:sdd1
>> Sep 17 16:07:09 tera kernel: disk 3, o:1, dev:sde1
>> Sep 17 16:07:56 tera kernel: EXT3-fs error (device md0):
>> ext3_check_descriptors: Block bitmap for group 8064 not in group
>> (block 532677632)!
>> Sep 17 16:07:56 tera kernel: EXT3-fs: group descriptors corrupted!
>> --------------------------------
>>
>>
>> I then tried a few more permutations of the command:
>> mdadm -C /dev/md0 -l 5 -n 5 -c 256 /dev/sd[bdce]1 missing
>> mdadm -C /dev/md0 -l 5 -n 5 -c 256 /dev/sd[bdec]1 missing
>> mdadm -C /dev/md0 -l 5 -n 5 -c 256 /dev/sd[becd]1 missing
>>
>> Every time I changed the order, it would still print the order the
>> same in the log:
>>
>> Sep 17 16:02:52 tera kernel: md: bind<sdb1>
>> Sep 17 16:02:52 tera kernel: md: bind<sdc1>
>> Sep 17 16:02:52 tera kernel: md: bind<sdd1>
>> Sep 17 16:02:52 tera kernel: md: bind<sde1>
>> Sep 17 16:02:52 tera kernel: raid5: device sde1 operational as raid =
disk 3
>> Sep 17 16:02:52 tera kernel: raid5: device sdd1 operational as raid =
disk 2
>> Sep 17 16:02:52 tera kernel: raid5: device sdc1 operational as raid =
disk 1
>> Sep 17 16:02:52 tera kernel: raid5: device sdb1 operational as raid =
disk 0
>> Sep 17 16:02:52 tera kernel: raid5: allocated 5268kB for md0
>> Sep 17 16:02:52 tera kernel: raid5: raid level 5 set md0 active with=
 4
>> out of 5 devices, algorithm 2
>> Sep 17 16:02:52 tera kernel: RAID5 conf printout:
>> Sep 17 16:02:52 tera kernel: --- rd:5 wd:4
>> Sep 17 16:02:52 tera kernel: disk 0, o:1, dev:sdb1
>> Sep 17 16:02:52 tera kernel: disk 1, o:1, dev:sdc1
>> Sep 17 16:02:52 tera kernel: disk 2, o:1, dev:sdd1
>> Sep 17 16:02:52 tera kernel: disk 3, o:1, dev:sde1
>>
>>
>>
>> Am I doing something wrong?
>>
>>
>>
>>
>> On Thu, Sep 17, 2009 at 2:22 PM, Robin Hill <robin@robinhill.me.uk> =
wrote:
>>> On Thu Sep 17, 2009 at 01:42:30PM -0700, Tim Bostrom wrote:
>>>
>>>> OK,
>>>>
>>>> Let me start off by saying - I panicked. =A0Rule #1 - don't panic.=
 =A0I
>>>> did. =A0Sorry.
>>>>
>>>> I have a RAID 5 array running on Fedora 10.
>>>> (Linux tera.teambostrom.com 2.6.27.30-170.2.82.fc10.i686 #1 SMP Mo=
n
>>>> Aug 17 08:38:59 EDT 2009 i686 athlon i386 GNU/Linux)
>>>>
>>>> 5 drives in an external enclosure (AMS eSATA Venus T5). =A0It's a
>>>> Sil4726 inside the enclosure running to a Sil3132 controller via e=
SATA
>>>> in the desktop. =A0I had been running this setup for just over a y=
ear.
>>>> Was working fine. =A0 I just moved into a new home and had my serv=
er
>>>> down for a while =A0- before I brought it back online, I got a "gr=
eat
>>>> idea" to blow out the dust from the enclosure using compressed air=
=2E
>>>> When I finally brought up the array again, I noticed that drives w=
ere
>>>> missing. =A0Tried re-adding the drives to the array and had some i=
ssues
>>>> - they seemed to get added but after a short time of rebuilding th=
e
>>>> array, I would get a bunch of HW resets in dmesg and then the arra=
y
>>>> would kick out drives and stop.
>>>>
>>> <- much snippage ->
>>>
>>>> I popped the drives out of the enclosure and into the actual tower
>>>> case and connected each of them to its own SATA port. =A0The HW re=
sets
>>>> seemed to go away, but I couldn't get the array to come back onlin=
e.
>>>> =A0Then I did the stupid panic (following someone's advice I shoul=
dn't
>>>> have).
>>>>
>>>> thinking I should just re-create the array, I did:
>>>>
>>>> mdadm --create /dev/md0 --level=3D5 --raid-devices=3D5 /dev/sd[b-f=
]1
>>>>
>>>> Stupid me again - ignores the warning that it belongs to an array
>>>> already. =A0I let it build for a minute or so and then tried to mo=
unt it
>>>> while rebuilding... and got error messages:
>>>>
>>>> EXT3-fs: unable to read superblock
>>>> EXT3-fs: md0: couldn't mount because of unsupported optional featu=
res
>>>> (3fd18e00).
>>>>
>>>> Now - I'm at a loss. =A0I'm afraid to do anything else. =A0 I've b=
een
>>>> viewing the FAQ and I have a few ideas, but I'm just more freaked.=
 =A0Is
>>>> there any hope? =A0What should I do next without causing more trou=
ble?
>>>>
>>> Looking at the mdadm output, there's a couple of possible errors.
>>> Firstly, your newly created array has a different chunksize than yo=
ur
>>> original one. =A0Secondly, the drives may be in the wrong order. =A0=
In
>>> either case, providing you don't _actually_ have any faulty drives,=
 then
>>> it should be (mostly) recoverable.
>>>
>>> Given the order you specified the drives in the create, sdf1 will b=
e the
>>> partition that's been trashed by the rebuild, so you'll want to lea=
ve
>>> that out altogether for now.
>>>
>>> You need to try to recreate the array with the correct chunk size a=
nd
>>> with the remaining drives in different orders, running a read-only
>>> filesystem check each time until you find the correct order.
>>>
>>> So start with:
>>> =A0 =A0mdadm -C /dev/md0 -l 5 -n 5 -c 256 /dev/sd[bcde]1 missing
>>>
>>> Then repeat for every possible order of the four disks and "missing=
",
>>> stopping the array each time if the mount fails.
>>>
>>> When you've finally found the correct order, you can re-add sdf1 to=
 get
>>> the array back to normal.
>>>
>>> HTH,
>>> =A0 =A0Robin
>>> --
>>> =A0 =A0 ___
>>> =A0 =A0( ' } =A0 =A0 | =A0 =A0 =A0 Robin Hill =A0 =A0 =A0 =A0<robin=
@robinhill.me.uk> |
>>> =A0 / / ) =A0 =A0 =A0| Little Jim says .... =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0|
>>> =A0// !! =A0 =A0 =A0 | =A0 =A0 =A0"He fallen in de water !!" =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 |
>>>
>>
>>
>>
>> --
>> -tim
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>>
>
>
>
> --
> =A0 =A0 =A0 Majed B.
>



--=20
-tim
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
