From: =?ISO-8859-1?Q?Patrik_Horn=EDk?= <patrik@dsl.sk>
Subject: Re: Please advise, strange "not enough to start the array while not clean"
Date: Mon, 22 Sep 2014 08:34:21 +0200
Message-ID: <CAAOsTSncnYC=hTMtQ8O-dOAdkqueqP3=kJJi6jfoAb1CwQtvHA@mail.gmail.com>
References: <CAAOsTSkaFdum4LD8aOkOsG-f45fTjRSUPb=EqguJi4yaNjcSdQ@mail.gmail.com>
	<20140922131940.58f97093@notabene.brown>
Reply-To: patrik@dsl.sk
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140922131940.58f97093@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

- Well what is exact meaning of --no-degraded then? Because I am using
it also on RAID6 arrays that are missing one drive and mdadm starts
them. I thought until today that it is against assembling for example
RAID6 array with missing more than two drives or to be more precise
array with number of drives it used last time. (I did not look at the
code what does it exactly. It is mdadm 3.3 on Debian.)

- Well array was shutdown cleanly manually by mdadm -S. Cant the not
clean classification be result of md101 device between find devices or
result of first two assemble tries?

- Anyway as I mentioned superblock on all five devices has clean state.=
 Example:
/dev/sdk1:
          Magic : XXXXXXX
        Version : 1.2
    Feature Map : 0x1
     Array UUID : XXXXXXXXXXXXXXXXXXXXX
           Name :
  Creation Time : Thu Aug XXXXXXXX
     Raid Level : raid6
   Raid Devices : 6

 Avail Dev Size : 5860268943 (2794.39 GiB 3000.46 GB)
     Array Size : 11720536064 (11177.57 GiB 12001.83 GB)
  Used Dev Size : 5860268032 (2794.39 GiB 3000.46 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=3D262056 sectors, after=3D911 sectors
          State : clean
    Device UUID : YYYYYYYYYYYYYYYYYYYY

Internal Bitmap : 8 sectors from superblock
    Update Time : Mon Sep 22 02:23:45 2014
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : ZZZZZZZZ - correct
         Events : EEEEEE

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 4
   Array State : AAAAA. ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=
=3D replacing)

- md101 has Events count lower by 16 than others devices.

- Please I need little more assurance what is exact state of array and
explain why it is behaving as it is behaving, so I can be sure what
steps are needed and what happens. The data on array is important.
Patrik Horn=EDk
=B9=E9fredaktor www.DSL.sk
Tel.: +421 905 385 666
Email: patrik@dsl.sk


2014-09-22 5:19 GMT+02:00 NeilBrown <neilb@suse.de>:
> On Mon, 22 Sep 2014 04:11:20 +0200 Patrik Horn=EDk <patrik@dsl.sk> wr=
ote:
>
>> Hello Neil,
>>
>> I've got this situation unfamiliar to me on RAID6 array md1 with imp=
ortant data.
>>
>> - It is RAID6 with 6 devices, 5 are partitions and 1 is another RAID=
0
>> array md101 from two smaller drives. One of the smaller drives froze=
,
>> so md101 got kicked out from md1 and marked as faulty in md1. After
>> while I've stopped md1 without removing md101 from it first. Then I
>> rebooted and assembled md101.
>>
>> - First I tried mdadm -A --no-degraded -u UUID /dev/md1 but got
>> "mdadm: /dev/md1 assembled from 5 drives (out of 6), but not started=
=2E"
>> so I stopped the md1.
>>
>> - Second time I started it with -v and got:
>>
>> mdadm: /dev/md101 is identified as a member of /dev/md1, slot 5.
>> mdadm: /dev/sdk1 is identified as a member of /dev/md1, slot 4.
>> mdadm: /dev/sdi1 is identified as a member of /dev/md1, slot 1.
>> mdadm: /dev/sdh1 is identified as a member of /dev/md1, slot 2.
>> mdadm: /dev/sdg1 is identified as a member of /dev/md1, slot 0.
>> mdadm: /dev/sde1 is identified as a member of /dev/md1, slot 3.
>> mdadm: added /dev/sdi1 to /dev/md1 as 1
>> mdadm: added /dev/sdh1 to /dev/md1 as 2
>> mdadm: added /dev/sde1 to /dev/md1 as 3
>> mdadm: added /dev/sdk1 to /dev/md1 as 4
>> mdadm: added /dev/md101 to /dev/md1 as 5 (possibly out of date)
>> mdadm: added /dev/sdg1 to /dev/md1 as 0
>> mdadm: /dev/md1 assembled from 5 drives (out of 6), but not started.
>>
>> - On third time I tried without --nodegraded with mdadm -A -v -u UUI=
D
>> /dev/md1. This is what I've got:
>>
>> mdadm: /dev/md101 is identified as a member of /dev/md1, slot 5.
>> mdadm: /dev/sdk1 is identified as a member of /dev/md1, slot 4.
>> mdadm: /dev/sdi1 is identified as a member of /dev/md1, slot 1.
>> mdadm: /dev/sdh1 is identified as a member of /dev/md1, slot 2.
>> mdadm: /dev/sdg1 is identified as a member of /dev/md1, slot 0.
>> mdadm: /dev/sde1 is identified as a member of /dev/md1, slot 3.
>> mdadm: added /dev/sdi1 to /dev/md1 as 1
>> mdadm: added /dev/sdh1 to /dev/md1 as 2
>> mdadm: added /dev/sde1 to /dev/md1 as 3
>> mdadm: added /dev/sdk1 to /dev/md1 as 4
>> mdadm: added /dev/md101 to /dev/md1 as 5 (possibly out of date)
>> mdadm: added /dev/sdg1 to /dev/md1 as 0
>> mdadm: /dev/md1 assembled from 5 drives - not enough to start the
>> array while not clean - consider --force.
>>
>> Array md1 has bitmap. All drive devices have all same Events, their
>> state is clean and Device Role is Active device. md101 has active
>> state and lower Events.
>>
>> Is this expected behavior? My theory is that it is caused by md101 a=
nd
>> I should start array md1 without it (by for example stopping md101)
>> and then re-add it. Is that a case or is it something else?
>>
>> Thanks.
>>
>> Best regards,
>>
>> Patrik
>
>
> The array is clearly degraded as one of the devices failed and hasn't=
 been
> recovered yet, so using --nodegraded is counter productive, as you
> discovered.
>
> It appears that the array is also marked as 'dirty'.  That suggests t=
hat it
> wasn't shut down cleanly.
> What does "mdadm --examine" of some device show?
>
> You probably need to re-assemble the array with --force like it sugge=
sts,
> then add the failed device and let it recover.
>
> NeilBrown
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
