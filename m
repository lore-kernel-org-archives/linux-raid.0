From: "Majed B." <majedb@gmail.com>
Subject: Re: 2 Disks Jumped Out While Reshaping RAID5
Date: Mon, 7 Sep 2009 02:55:47 +0300
Message-ID: <70ed7c3e0909061655u344c2c6dt1939f85b10f49fa0@mail.gmail.com>
References: <70ed7c3e0909051322l7cf66158lbbc8a5dd2cc18b8b@mail.gmail.com>
	<a6dfa0829c75cc81fd4482bb344bbff2.squirrel@neil.brown.name>
	<70ed7c3e0909060300la51bec3ke51c35373b2ee1fc@mail.gmail.com>
	<19108.19281.495223.465327@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <19108.19281.495223.465327@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks a lot Neil!

I didn't know that it requires you to register to download. My bad.
Here's the output of examine:

/dev/sda1:
          Magic : a92b4efc
        Version : 00.91.00
           UUID : ed1a2670:03308d80:95a69c9f:ccf9605f
  Creation Time : Sat May 23 00:22:49 2009
     Raid Level : raid5
  Used Dev Size : 976759808 (931.51 GiB 1000.20 GB)
     Array Size : 6837318656 (6520.58 GiB 7001.41 GB)
   Raid Devices : 8
  Total Devices : 8
Preferred Minor : 0

  Reshape pos'n : 3357066496 (3201.55 GiB 3437.64 GB)
  Delta Devices : 1 (7->8)

    Update Time : Wed Sep  2 13:28:39 2009
          State : clean
 Active Devices : 6
Working Devices : 6
 Failed Devices : 1
  Spare Devices : 0
       Checksum : 5b5a1163 - correct
         Events : 949214

         Layout : left-symmetric
     Chunk Size : 256K

      Number   Major   Minor   RaidDevice State
this     4       8        1        4      active sync   /dev/sda1

   0     0       0        0        0      removed
   1     1       8       65        1      active sync   /dev/sde1
   2     2       8       33        2      active sync   /dev/sdc1
   3     3       0        0        3      faulty removed
   4     4       8        1        4      active sync   /dev/sda1
   5     5       8      113        5      active sync   /dev/sdh1
   6     6       8       17        6      active sync   /dev/sdb1
   7     7       8       49        7      active sync   /dev/sdd1
/dev/sdb1:
          Magic : a92b4efc
        Version : 00.91.00
           UUID : ed1a2670:03308d80:95a69c9f:ccf9605f
  Creation Time : Sat May 23 00:22:49 2009
     Raid Level : raid5
  Used Dev Size : 976759808 (931.51 GiB 1000.20 GB)
     Array Size : 6837318656 (6520.58 GiB 7001.41 GB)
   Raid Devices : 8
  Total Devices : 8
Preferred Minor : 0

  Reshape pos'n : 3357066496 (3201.55 GiB 3437.64 GB)
  Delta Devices : 1 (7->8)

    Update Time : Wed Sep  2 13:28:39 2009
          State : clean
 Active Devices : 6
Working Devices : 6
 Failed Devices : 1
  Spare Devices : 0
       Checksum : 5b5a1177 - correct
         Events : 949214

         Layout : left-symmetric
     Chunk Size : 256K

      Number   Major   Minor   RaidDevice State
this     6       8       17        6      active sync   /dev/sdb1

   0     0       0        0        0      removed
   1     1       8       65        1      active sync   /dev/sde1
   2     2       8       33        2      active sync   /dev/sdc1
   3     3       0        0        3      faulty removed
   4     4       8        1        4      active sync   /dev/sda1
   5     5       8      113        5      active sync   /dev/sdh1
   6     6       8       17        6      active sync   /dev/sdb1
   7     7       8       49        7      active sync   /dev/sdd1
/dev/sdc1:
          Magic : a92b4efc
        Version : 00.91.00
           UUID : ed1a2670:03308d80:95a69c9f:ccf9605f
  Creation Time : Sat May 23 00:22:49 2009
     Raid Level : raid5
  Used Dev Size : 976759808 (931.51 GiB 1000.20 GB)
     Array Size : 6837318656 (6520.58 GiB 7001.41 GB)
   Raid Devices : 8
  Total Devices : 8
Preferred Minor : 0

  Reshape pos'n : 3357066496 (3201.55 GiB 3437.64 GB)
  Delta Devices : 1 (7->8)

    Update Time : Wed Sep  2 13:28:39 2009
          State : clean
 Active Devices : 6
Working Devices : 6
 Failed Devices : 1
  Spare Devices : 0
       Checksum : 5b5a117f - correct
         Events : 949214

         Layout : left-symmetric
     Chunk Size : 256K

      Number   Major   Minor   RaidDevice State
this     2       8       33        2      active sync   /dev/sdc1

   0     0       0        0        0      removed
   1     1       8       65        1      active sync   /dev/sde1
   2     2       8       33        2      active sync   /dev/sdc1
   3     3       0        0        3      faulty removed
   4     4       8        1        4      active sync   /dev/sda1
   5     5       8      113        5      active sync   /dev/sdh1
   6     6       8       17        6      active sync   /dev/sdb1
   7     7       8       49        7      active sync   /dev/sdd1
/dev/sdd1:
          Magic : a92b4efc
        Version : 00.91.00
           UUID : ed1a2670:03308d80:95a69c9f:ccf9605f
  Creation Time : Sat May 23 00:22:49 2009
     Raid Level : raid5
  Used Dev Size : 976759808 (931.51 GiB 1000.20 GB)
     Array Size : 6837318656 (6520.58 GiB 7001.41 GB)
   Raid Devices : 8
  Total Devices : 8
Preferred Minor : 0

  Reshape pos'n : 3357066496 (3201.55 GiB 3437.64 GB)
  Delta Devices : 1 (7->8)

    Update Time : Wed Sep  2 13:28:39 2009
          State : clean
 Active Devices : 6
Working Devices : 6
 Failed Devices : 1
  Spare Devices : 0
       Checksum : 5b5a1199 - correct
         Events : 949214

         Layout : left-symmetric
     Chunk Size : 256K

      Number   Major   Minor   RaidDevice State
this     7       8       49        7      active sync   /dev/sdd1

   0     0       0        0        0      removed
   1     1       8       65        1      active sync   /dev/sde1
   2     2       8       33        2      active sync   /dev/sdc1
   3     3       0        0        3      faulty removed
   4     4       8        1        4      active sync   /dev/sda1
   5     5       8      113        5      active sync   /dev/sdh1
   6     6       8       17        6      active sync   /dev/sdb1
   7     7       8       49        7      active sync   /dev/sdd1
/dev/sde1:
          Magic : a92b4efc
        Version : 00.91.00
           UUID : ed1a2670:03308d80:95a69c9f:ccf9605f
  Creation Time : Sat May 23 00:22:49 2009
     Raid Level : raid5
  Used Dev Size : 976759808 (931.51 GiB 1000.20 GB)
     Array Size : 6837318656 (6520.58 GiB 7001.41 GB)
   Raid Devices : 8
  Total Devices : 8
Preferred Minor : 0

  Reshape pos'n : 3357066496 (3201.55 GiB 3437.64 GB)
  Delta Devices : 1 (7->8)

    Update Time : Wed Sep  2 13:28:39 2009
          State : clean
 Active Devices : 6
Working Devices : 6
 Failed Devices : 1
  Spare Devices : 0
       Checksum : 5b5a119d - correct
         Events : 949214

         Layout : left-symmetric
     Chunk Size : 256K

      Number   Major   Minor   RaidDevice State
this     1       8       65        1      active sync   /dev/sde1

   0     0       0        0        0      removed
   1     1       8       65        1      active sync   /dev/sde1
   2     2       8       33        2      active sync   /dev/sdc1
   3     3       0        0        3      faulty removed
   4     4       8        1        4      active sync   /dev/sda1
   5     5       8      113        5      active sync   /dev/sdh1
   6     6       8       17        6      active sync   /dev/sdb1
   7     7       8       49        7      active sync   /dev/sdd1
/dev/sdf1:
          Magic : a92b4efc
        Version : 00.91.00
           UUID : ed1a2670:03308d80:95a69c9f:ccf9605f
  Creation Time : Sat May 23 00:22:49 2009
     Raid Level : raid5
  Used Dev Size : 976759808 (931.51 GiB 1000.20 GB)
     Array Size : 6837318656 (6520.58 GiB 7001.41 GB)
   Raid Devices : 8
  Total Devices : 8
Preferred Minor : 0

  Reshape pos'n : 3357066496 (3201.55 GiB 3437.64 GB)
  Delta Devices : 1 (7->8)

    Update Time : Wed Sep  2 06:40:04 2009
          State : clean
 Active Devices : 7
Working Devices : 7
 Failed Devices : 1
  Spare Devices : 0
       Checksum : 5b59b1c1 - correct
         Events : 949204

         Layout : left-symmetric
     Chunk Size : 256K

      Number   Major   Minor   RaidDevice State
this     0       8       81        0      active sync   /dev/sdf1

   0     0       8       81        0      active sync   /dev/sdf1
   1     1       8       65        1      active sync   /dev/sde1
   2     2       8       33        2      active sync   /dev/sdc1
   3     3       0        0        3      faulty removed
   4     4       8        1        4      active sync   /dev/sda1
   5     5       8      113        5      active sync   /dev/sdh1
   6     6       8       17        6      active sync   /dev/sdb1
   7     7       8       49        7      active sync   /dev/sdd1
/dev/sdg1:
          Magic : a92b4efc
        Version : 00.91.00
           UUID : ed1a2670:03308d80:95a69c9f:ccf9605f
  Creation Time : Sat May 23 00:22:49 2009
     Raid Level : raid5
  Used Dev Size : 976759808 (931.51 GiB 1000.20 GB)
     Array Size : 6837318656 (6520.58 GiB 7001.41 GB)
   Raid Devices : 8
  Total Devices : 8
Preferred Minor : 0

  Reshape pos'n : 2554257664 (2435.93 GiB 2615.56 GB)
  Delta Devices : 1 (7->8)

    Update Time : Wed Sep  2 00:10:39 2009
          State : clean
 Active Devices : 8
Working Devices : 8
 Failed Devices : 0
  Spare Devices : 0
       Checksum : fba3471a - correct
         Events : 874530

         Layout : left-symmetric
     Chunk Size : 256K

      Number   Major   Minor   RaidDevice State
this     3       8       97        3      active sync   /dev/sdg1

   0     0       8       81        0      active sync   /dev/sdf1
   1     1       8       65        1      active sync   /dev/sde1
   2     2       8       33        2      active sync   /dev/sdc1
   3     3       8       97        3      active sync   /dev/sdg1
   4     4       8        1        4      active sync   /dev/sda1
   5     5       8      113        5      active sync   /dev/sdh1
   6     6       8       17        6      active sync   /dev/sdb1
   7     7       8       49        7      active sync   /dev/sdd1
/dev/sdh1:
          Magic : a92b4efc
        Version : 00.91.00
           UUID : ed1a2670:03308d80:95a69c9f:ccf9605f
  Creation Time : Sat May 23 00:22:49 2009
     Raid Level : raid5
  Used Dev Size : 976759808 (931.51 GiB 1000.20 GB)
     Array Size : 6837318656 (6520.58 GiB 7001.41 GB)
   Raid Devices : 8
  Total Devices : 8
Preferred Minor : 0

  Reshape pos'n : 3357066496 (3201.55 GiB 3437.64 GB)
  Delta Devices : 1 (7->8)

    Update Time : Wed Sep  2 13:28:39 2009
          State : clean
 Active Devices : 6
Working Devices : 6
 Failed Devices : 1
  Spare Devices : 0
       Checksum : 5b5a11d5 - correct
         Events : 949214

         Layout : left-symmetric
     Chunk Size : 256K

      Number   Major   Minor   RaidDevice State
this     5       8      113        5      active sync   /dev/sdh1

   0     0       0        0        0      removed
   1     1       8       65        1      active sync   /dev/sde1
   2     2       8       33        2      active sync   /dev/sdc1
   3     3       0        0        3      faulty removed
   4     4       8        1        4      active sync   /dev/sda1
   5     5       8      113        5      active sync   /dev/sdh1
   6     6       8       17        6      active sync   /dev/sdb1
   7     7       8       49        7      active sync   /dev/sdd1


I have already downloaded and compiled mdadm 3.0, but didn't install
it, awaiting further instructions from you. I'll install it now and
run -Af and report back what happens.

Thank you again!

On Mon, Sep 7, 2009 at 2:52 AM, Neil Brown<neilb@suse.de> wrote:
> On Sunday September 6, majedb@gmail.com wrote:
>> I forgot to mention that I'm running mdadm 2.6.7.1 (latest in Ubuntu
>> Server repositories).
>
> You will need at least 2.6.8 to be able to assemble arrays which are
> in the middle of a reshape. =C2=A0I would suggest 2.6.9 or 3.0.
>
>>
>> I tried forcing the assembly, but as mentioned, I just got an error:
>> root@Adam:/var/www# mdadm -Af /dev/md0
>> mdadm: superblock on /dev/sdh1 doesn't match others - assembly abort=
ed
>
> This incorrect message is fixed in 2.6.8 an later.
>
>>
>> I know I could've pasted whatever I wrote here, but it seemed
>> redundant. I'll keep your hint in mind for the next time, if any
>> (hopefully not).
>
> Redundant? =C2=A0How is that relevant?
> If you want help, your goal should be to make it as easy as possible
> for people to help you. =C2=A0Having all information in one email mes=
sage
> is easy. =C2=A0Having to use a browser to get some of it makes it har=
d.
> Having to register on the website to down load an attachment makes it
> nearly impossible.
>
>>
>> This may be of an interest to you:
>> root@Adam:/var/www# mdadm -E /dev/sd[a-h]1 | grep Reshap
>> sda1 =C2=A0Reshape pos'n : 3357066496 (3201.55 GiB 3437.64 GB)
>> sdb1 =C2=A0Reshape pos'n : 3357066496 (3201.55 GiB 3437.64 GB)
>> sdc1 =C2=A0Reshape pos'n : 3357066496 (3201.55 GiB 3437.64 GB)
>> sdd1 =C2=A0Reshape pos'n : 3357066496 (3201.55 GiB 3437.64 GB)
>> sde1 =C2=A0Reshape pos'n : 3357066496 (3201.55 GiB 3437.64 GB)
>> sdf1 =C2=A0 Reshape pos'n : 3357066496 (3201.55 GiB 3437.64 GB)
>> sdg1 =C2=A0Reshape pos'n : 2554257664 (2435.93 GiB 2615.56 GB)
>> sdh1 =C2=A0Reshape pos'n : 3357066496 (3201.55 GiB 3437.64 GB)
>
> If you can post that again but without the "grep" I might be able to
> be more helpful. =C2=A0(i.e. the complete output of "mdadm -E /dev/sd=
[a-h]1").
>
> NeilBrown
>
>
>
>>
>> Note that sdd1 was the spare.
>>
>> The UUIDs are all the same and the superblock is all similar except
>> for the reshaping position of sdg1.
>>
>> I didn't try to recreate the array as I've never faced this issue
>> before, so I don't know what kind of repercussions it may have.
>>
>> What I do know, that at the worst case scenario, I can recreate the
>> array out of 7 disks (all but sdg1), but lose about 2.3TB worth of
>> data :(
>>
>> On Sun, Sep 6, 2009 at 12:32 AM, NeilBrown<neilb@suse.de> wrote:
>> > On Sun, September 6, 2009 6:22 am, Majed B. wrote:
>> >> Hello all,
>> >>
>> >> I have posted my problem already here:
>> >> http://ubuntuforums.org/showthread.php?p=3D7900571#post7900571
>> >> It also has file attachments of the output of mdadm -E /dev/sd[a-=
h]1
>> >
>> > It seems that you need to log in to read the attachements... so I =
haven't.
>> >
>> >>
>> >> I appreciate any help on this.
>> >
>> > Hopefully you just need to add "--force" to the assemble command
>> > and it would all just work. =C2=A0However I haven't tested that on=
 an array
>> > that is in the process of a reshape so I cannot promise.
>> > I might try to reproduce your situation and with some scratch driv=
es
>> > and check that mdadm -Af does the right thing, but it won't be a d=
ay
>> > or so, and as I cannot see the --examine output I might get the
>> > situation a bit wrong ... (hint hint: it is always best to post
>> > full information rather than pointers to it, unless said informati=
on is
>> > really really big).
>> >
>> > NeilBrown
>>
>> --
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0Majed B.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.h=
tml
>



--=20
       Majed B.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
