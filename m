From: Another Sillyname <anothersname@googlemail.com>
Subject: Re: Fwd: RAID6 Array crash during reshape.....now will not re-assemble.
Date: Sat, 5 Mar 2016 10:28:21 +0000
Message-ID: <CAOS+5GEjZizchhKoq6BhJicSA5oraCBfgdR=xiDEVqzg23iung@mail.gmail.com>
References: <CAOS+5GEd4E2wzYhw0rPdrZnjK6UwAUdKCQLLTxXrdPO8d7hS7w@mail.gmail.com>
	<56D6E883.50801@youngman.org.uk>
	<CAOS+5GHof=F94x58SKqFojV26hGpDSLF85dFfm8Xc6M43sN6jA@mail.gmail.com>
	<CAOS+5GEfQ2p0xguguKC3uXW8GYBDCxt2vk=-Ci6+nTKwkcWtdQ@mail.gmail.com>
	<CAOS+5GGX8QBo3=s+Mcj=Kd6VSmZyatfZ30NXBy8E=4WJE6z0sA@mail.gmail.com>
	<CAOS+5GGB5gVSFJbYwwJu+z0C0oyYPzsLRhnjD6FkmLEWFFquFA@mail.gmail.com>
	<56D8348E.9070802@youngman.org.uk>
	<CAOS+5GH1Rcu8zGk1dQ+aSNmVzjo=irH65KfPuq1ZGruzqX_=vg@mail.gmail.com>
	<CAOS+5GHUKD63M90zWfiv14QkJunj2QF+gYqDMrg208-S4oXE2Q@mail.gmail.com>
	<56D878E8.1060409@prgmr.com>
	<CAOS+5GEnvtPMUqorddDNUvkNr2+K2S=0N76i3f0AkAOE-7U4Pg@mail.gmail.com>
	<22232.41693.691818.451316@quad.stoffel.home>
	<CAOS+5GFfNdeYrfw6j_LowkW+g69h2fEOikHN1=-VQ98ZF9Jtpg@mail.gmail.com>
	<22232.48582.65930.822795@quad.stoffel.home>
	<CAOS+5GEeGapxE1_GUhxD6F2BCabso-M=h-HQYjZ0hvNxh04Hug@mail.gmail.com>
	<CAB-428mE21BZSvNCjyygQ4AWvRfRTyu7ZFfYZ8RYnEtbw+cMew@mail.gmail.com>
	<CAOS+5GEZxF6B7f9W3eQg07fahYf02EGStu2whzWGTP4+p71fPQ@mail.gmail.com>
	<CAB-428nDwNOuFe5Bqh=LXD5Vw8MxzKzpP6ELuAqen1wD54urmA@mail.gmail.com>
	<CAOS+5GEr2p9nOcxWJxnX_u3_2PGyTfEPXnnzWYsMBWuXxSy-4Q@mail.gmail.com>
	<22234.1802.863099.33875@quad.stoffel.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <22234.1802.863099.33875@quad.stoffel.home>
Sender: linux-raid-owner@vger.kernel.org
To: John Stoffel <john@stoffel.org>
Cc: Alireza Haghdoost <alireza@cs.umn.edu>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

John

As I said in a previous reply I'm not willing to just 'try' things
(such as using a later mdadm) as in my opinion that's not an
analytical approach and nothing will be learnt from a success.  I want
to understand both why this happened and also what specifically needs
to be done to recover it (if it is a later version of mdadm what in
that later version addesses this problem), only then can any
subsequent user with a similar problem be able to to follow this
example to fix their array.

I'd already posted the mdadm examine in the OP, I've copied the
original OP below again for completeness.

Thanks for your thoughts.


The original post.
-----------------------------------------------------------------------------

I have a 30TB RAID6 array using 7 x 6TB drives that I wanted to
migrate to RAID5 to take one of the drives offline and use in a new
array for a migration.

sudo mdadm --grow /dev/md127 --level=raid5 --raid-device=6
--backup-file=mdadm_backupfile

I watched this using cat /proc/mdstat and even after an hour the
percentage of the reshape was still 0.0%.

I know from previous experience that reshaping can be slow, but did
not expect it to be this slow frankly.  But erring on the side of
caution I decided to leave the array for 12 hours and see what was
happening then.

Sure enough, 12 hours later cat /proc/mdstat still shows reshape at 0.0%

Looking at CPU usage the reshape process is using 0% of the CPU.

So reading a bit more......if you reboot a server the reshape should continue.

Reboot.....

Array will not come back online at all.

Bring the server up without the array trying to automount.

cat /proc/mdstat shows the array offline.

Personalities :
md127 : inactive sdf1[2](S) sde1[3](S) sdg1[0](S) sdb1[8](S)
sdh1[7](S) sdc1[1](S) sdd1[6](S)
      41022733300 blocks super 1.2

unused devices: <none>

Try to reassemble the array.

>sudo mdadm --assemble /dev/md127 /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1 /dev/sdf1 /dev/sdg1 /dev/sdh1
mdadm: /dev/sdg1 is busy - skipping
mdadm: /dev/sdh1 is busy - skipping
mdadm: Merging with already-assembled /dev/md/server187.internallan.com:1
mdadm: Failed to restore critical section for reshape, sorry.
       Possibly you needed to specify the --backup-file


Have no idea where the server187 stuff has come from.

stop the array.

>sudo mdadm --stop /dev/md127

try to re-assemble

>sudo mdadm --assemble /dev/md127 /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1 /dev/sdf1 /dev/sdg1 /dev/sdh1

mdadm: Failed to restore critical section for reshape, sorry.
       Possibly you needed to specify the --backup-file


try to re-assemble using the backup file

>sudo mdadm --assemble /dev/md127 /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1 /dev/sdf1 /dev/sdg1 /dev/sdh1 --backup-file=mdadm_backupfile

mdadm: Failed to restore critical section for reshape, sorry.

have a look at the individual drives

>sudo mdadm --examine /dev/sd[b-h]1

/dev/sdb1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x5
     Array UUID : da29a06f:f8cf1409:bc52afb2:6945ba08
           Name : server187.internallan.com:1
  Creation Time : Sun May 10 14:47:51 2015
     Raid Level : raid6
   Raid Devices : 7

 Avail Dev Size : 11720780943 (5588.90 GiB 6001.04 GB)
     Array Size : 29301952000 (27944.52 GiB 30005.20 GB)
  Used Dev Size : 11720780800 (5588.90 GiB 6001.04 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=143 sectors
          State : clean
    Device UUID : 1152bdeb:15546156:1918b67d:37d68b1f

Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 0
     New Layout : left-symmetric-6

    Update Time : Wed Mar  2 01:19:42 2016
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 3a66db58 - correct
         Events : 369282

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 4
   Array State : AAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdc1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x5
     Array UUID : da29a06f:f8cf1409:bc52afb2:6945ba08
           Name : server187.internallan.com:1
  Creation Time : Sun May 10 14:47:51 2015
     Raid Level : raid6
   Raid Devices : 7

 Avail Dev Size : 11720780943 (5588.90 GiB 6001.04 GB)
     Array Size : 29301952000 (27944.52 GiB 30005.20 GB)
  Used Dev Size : 11720780800 (5588.90 GiB 6001.04 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=143 sectors
          State : clean
    Device UUID : 140e09af:56e14b4e:5035d724:c2005f0b

Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 0
     New Layout : left-symmetric-6

    Update Time : Wed Mar  2 01:19:42 2016
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 88916c56 - correct
         Events : 369282

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 1
   Array State : AAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdd1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x5
     Array UUID : da29a06f:f8cf1409:bc52afb2:6945ba08
           Name : server187.internallan.com:1
  Creation Time : Sun May 10 14:47:51 2015
     Raid Level : raid6
   Raid Devices : 7

 Avail Dev Size : 11720780943 (5588.90 GiB 6001.04 GB)
     Array Size : 29301952000 (27944.52 GiB 30005.20 GB)
  Used Dev Size : 11720780800 (5588.90 GiB 6001.04 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=143 sectors
          State : clean
    Device UUID : a50dd0a1:eeb0b3df:76200476:818e004d

Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 0
     New Layout : left-symmetric-6

    Update Time : Wed Mar  2 01:19:42 2016
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 9f8eb46a - correct
         Events : 369282

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 6
   Array State : AAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sde1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x5
     Array UUID : da29a06f:f8cf1409:bc52afb2:6945ba08
           Name : server187.internallan.com:1
  Creation Time : Sun May 10 14:47:51 2015
     Raid Level : raid6
   Raid Devices : 7

 Avail Dev Size : 11720780943 (5588.90 GiB 6001.04 GB)
     Array Size : 29301952000 (27944.52 GiB 30005.20 GB)
  Used Dev Size : 11720780800 (5588.90 GiB 6001.04 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=143 sectors
          State : clean
    Device UUID : 7d0b65b3:d2ba2023:4625c287:1db2de9b

Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 0
     New Layout : left-symmetric-6

    Update Time : Wed Mar  2 01:19:42 2016
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 552ce48f - correct
         Events : 369282

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 3
   Array State : AAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdf1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x5
     Array UUID : da29a06f:f8cf1409:bc52afb2:6945ba08
           Name : server187.internallan.com:1
  Creation Time : Sun May 10 14:47:51 2015
     Raid Level : raid6
   Raid Devices : 7

 Avail Dev Size : 11720780943 (5588.90 GiB 6001.04 GB)
     Array Size : 29301952000 (27944.52 GiB 30005.20 GB)
  Used Dev Size : 11720780800 (5588.90 GiB 6001.04 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=143 sectors
          State : clean
    Device UUID : cda4f5e5:a489dbb9:5c1ab6a0:b257c984

Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 0
     New Layout : left-symmetric-6

    Update Time : Wed Mar  2 01:19:42 2016
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 2056e75c - correct
         Events : 369282

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 2
   Array State : AAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdg1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x5
     Array UUID : da29a06f:f8cf1409:bc52afb2:6945ba08
           Name : server187.internallan.com:1
  Creation Time : Sun May 10 14:47:51 2015
     Raid Level : raid6
   Raid Devices : 7

 Avail Dev Size : 11720780943 (5588.90 GiB 6001.04 GB)
     Array Size : 29301952000 (27944.52 GiB 30005.20 GB)
  Used Dev Size : 11720780800 (5588.90 GiB 6001.04 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=143 sectors
          State : clean
    Device UUID : df5af6ce:9017c863:697da267:046c9709

Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 0
     New Layout : left-symmetric-6

    Update Time : Wed Mar  2 01:19:42 2016
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : fefea2b5 - correct
         Events : 369282

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : AAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdh1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x5
     Array UUID : da29a06f:f8cf1409:bc52afb2:6945ba08
           Name : server187.internallan.com:1
  Creation Time : Sun May 10 14:47:51 2015
     Raid Level : raid6
   Raid Devices : 7

 Avail Dev Size : 11720780943 (5588.90 GiB 6001.04 GB)
     Array Size : 29301952000 (27944.52 GiB 30005.20 GB)
  Used Dev Size : 11720780800 (5588.90 GiB 6001.04 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=143 sectors
          State : clean
    Device UUID : 9d98af83:243c3e02:94de20c7:293de111

Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 0
     New Layout : left-symmetric-6

    Update Time : Wed Mar  2 01:19:42 2016
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : b9f6375e - correct
         Events : 369282

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 5
   Array State : AAAAAAA ('A' == active, '.' == missing, 'R' == replacing)


As all the drives are showing Reshape pos'n 0 I'm assuming the reshape
never got started (even though cat /proc/mdstat showed the array
reshaping)?

So now I'm well out of my comfort zone so instead of flapping around
have decided to sleep for a few hours before revisiting this.

Any help and guidance would be appreciated, the drives showing clean
gives me comfort that the data is likely intact and complete (crossed
fingers) however I can't re-assemble the array as I keep getting the
'critical information for reshape, sorry' warning.

Help???

--------------------------------------------------------------------------------------------------------

On 4 March 2016 at 22:07, John Stoffel <john@stoffel.org> wrote:
>
> Can you post the output of mdadm -E /dev/sd?1 for all your drives?
> And did you pull down the latest version of mdadm from neil's repo and
> build it and use that to undo the re-shape?
>
> John
>
>
> Another> I have no clue, they were used in a temporary system for 10 days about
> Another> 8 months ago, they were then used in the new array that was built back
> Another> in August.
>
> Another> Even if the metadata was removed from those two drives the 'merge'
> Another> that happened, without warning or requiring verification, seems to now
> Another> have 'contaminated' all the drives possibly.
>
> Another> I'm still reasonably convinced the data is there and intact, just need
> Another> an analytical approach to how to recover it.
>
>
>
> Another> On 4 March 2016 at 21:02, Alireza Haghdoost <alireza@cs.umn.edu> wrote:
>>> On Fri, Mar 4, 2016 at 2:30 PM, Another Sillyname
>>> <anothersname@googlemail.com> wrote:
>>>> That's possibly true, however there are lessons to be learnt here even
>>>> if my array is not recoverable.
>>>>
>>>> I don't know the process order of doing a reshape....but I would
>>>> suspect it's something along the lines of.
>>>>
>>>> Examine existing array.
>>>> Confirm command can be run against existing array configuration (i.e.
>>>> It's a valid command for this array setup).
>>>> Do backup file (if specified)
>>>> Set reshape flag high
>>>> Start reshape
>>>>
>>>> I would suggest....
>>>>
>>>> There needs to be another step in the process
>>>>
>>>> Before 'Set reshape flag high' that the backup file needs to be
>>>> checked for consistency.
>>>>
>>>> My backup file appears to be just full of EOLs (now for all I know the
>>>> backup file actually gets 'created' during the process and therefore
>>>> starts out as EOLs).  But once the flag is set high you are then
>>>> committing the array before you know if the backup is good.
>>>>
>>>> Also
>>>>
>>>> The drives in this array had been working correctly for 6 months and
>>>> undergone a number of reboots.
>>>>
>>>> If, as we are theorising, there was some metadata from a previous
>>>> array setup on two of the drives that as a result of the reshape
>>>> somehow became the 'valid' metadata regarding those two drives RAID
>>>> status then I would suggest that during any mdadm raid create process
>>>> there is an extensive and thorough check of any drives being used to
>>>> identify and remove any possible previously existing RAID metadata
>>>> information...thus making the drives 'clean'.
>>>>
>>>>
>>>>
>>>>
>>>>
>>>>
>>>> On 4 March 2016 at 19:11, Alireza Haghdoost <alireza@cs.umn.edu> wrote:
>>>>> On Fri, Mar 4, 2016 at 1:01 PM, Another Sillyname
>>>>> <anothersname@googlemail.com> wrote:
>>>>>>
>>>>>>
>>>>>> Thanks for the suggestion but I'm still stuck and there is no bug
>>>>>> tracker on the mdadm git website so I have to wait here.
>>>>>>
>>>>>> Ho Huum
>>>>>>
>>>>>>
>>>>>
>>>>> Looks like it is going to be a long wait. I think you are waiting to
>>>>> do something that might not be inplace/available at all. That thing is
>>>>> the capability to reset reshape flag when the array metadata is not
>>>>> consistent. You had an old array in two of these drives and it seems
>>>>> mdadm confused when it observes the drives metadata are not
>>>>> consistent.
>>>>>
>>>>> Hope someone chip in some tricks to do so without a need to develop
>>>>> such a functionality in mdadm.
>>>
>>> Do you know the metadata version that is used on those two drives ?
>>> For example, if the version is < 1.0 then we could easily erase the
>>> old metadata since it has been recorded in the end of the drive. Newer
>>> metada versions after 1.0 are stored in the beginning of the drive.
>>>
>>> Therefore, there is no risk to erase your current array metadata !
> Another> --
> Another> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> Another> the body of a message to majordomo@vger.kernel.org
> Another> More majordomo info at  http://vger.kernel.org/majordomo-info.html
