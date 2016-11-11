From: Theophanis Kontogiannis <tkonto@gmail.com>
Subject: Re: Question on blocks periodic writes
Date: Fri, 11 Nov 2016 14:11:32 +0200
Message-ID: <CAOzB0-6YcVvVuFCUQZAUpeA08Cppv4XfvziA1x_WyHrx+9VuDA@mail.gmail.com>
References: <CAOzB0-6NYUqrzUyx3iQ8CbPwFh-dctKTVwE6GKupdYM-8AfOrg@mail.gmail.com>
 <8760nwm6vu.fsf@notabene.neil.brown.name> <58249BD9.8000303@youngman.org.uk> <87a8d6lr4t.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87a8d6lr4t.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Wols Lists <antlists@youngman.org.uk>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Neil,

Hi Community,


Regarding XFS we can ignore it. That file system will be moved to an
ext2 file system on a CF.

So we are left with the rest:


-bash-4.2# mdadm --detail /dev/md1
/dev/md1:
        Version : 1.2
  Creation Time : Thu Jun 16 18:02:57 2016
     Raid Level : raid6
     Array Size : 9397248 (8.96 GiB 9.62 GB)
  Used Dev Size : 3132416 (2.99 GiB 3.21 GB)
   Raid Devices : 5
  Total Devices : 5
    Persistence : Superblock is persistent

    Update Time : Fri Nov 11 14:05:33 2016
          State : clean
 Active Devices : 5
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 512K

           Name : tweety.example.com:1  (local to host tweety.example.com)
           UUID : 98e2af83:dc074310:d1639adb:3f19f0d3
         Events : 127

    Number   Major   Minor   RaidDevice State
       0       8        1        0      active sync   /dev/sda1
       1       8       49        1      active sync   /dev/sdd1
       2       8       65        2      active sync   /dev/sde1
       3       8       81        3      active sync   /dev/sdf1
       4       8       97        4      active sync   /dev/sdg1



-bash-4.2# mdadm --examine /dev/sda1
/dev/sda1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 98e2af83:dc074310:d1639adb:3f19f0d3
           Name : tweety.example.com:1  (local to host tweety.example.com)
  Creation Time : Thu Jun 16 18:02:57 2016
     Raid Level : raid6
   Raid Devices : 5

 Avail Dev Size : 6264832 (2.99 GiB 3.21 GB)
     Array Size : 9397248 (8.96 GiB 9.62 GB)
    Data Offset : 4096 sectors
   Super Offset : 8 sectors
   Unused Space : before=3D4008 sectors, after=3D0 sectors
          State : clean
    Device UUID : 5ff290a3:68faf9d0:22edd403:abbaf970

    Update Time : Fri Nov 11 14:05:59 2016
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 55812945 - correct
         Events : 127

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : AAAAA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D r=
eplacing)


Thank you ALL


---
Best regards,
=CE=9C=CE=A6=CE=A7,

Theophanis Kontogiannis



On Fri, Nov 11, 2016 at 3:52 AM, NeilBrown <neilb@suse.com> wrote:
> On Fri, Nov 11 2016, Wols Lists wrote:
>
>> On 10/11/16 02:00, NeilBrown wrote:
>>>> [ 8664.858104] xfsaild/md1(658): WRITE block 0 on md1 (8 sectors)
>>> This is XFS doing something.  md cannot possibly stop all IO while the
>>> filesystem performs occasional IO.  If these continue, you need to
>>> discuss with xfs developers how to stop it.  If the writes to individua=
l
>>> drives continue after there are no writes to 'md1', then it is worth
>>> coming back here to ask.
>>>
>>>
>> Would the new journal feature be any help?
>
> Probably not, though until we know what is causing the writes, it is
> hard to say.
>
>>
>> I haven't dug in enough to understand it properly, and it would increase
>> the vulnerability of the system to a journal failure, but the feature
>> itself seems almost perfect for batching writes and enabling the disks
>> to spin down for extended periods.
>
> You might be able to build functionality onto the journal which allows
> the drives in the main array to stay idle for longer, but it doesn't try
> to do that at present.
>
> NeilBrown
