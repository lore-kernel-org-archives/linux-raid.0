From: Alex Boag-Munroe <boagenator@gmail.com>
Subject: Re: I am an idiot.
Date: Thu, 4 Mar 2010 12:22:53 +0000
Message-ID: <68c4f7e31003040422u60b75b89id2042a34643424fa@mail.gmail.com>
References: <68c4f7e31003040330s21b6059ex6859247ff67b43e2@mail.gmail.com>
	 <4B8FA12E.9000606@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B8FA12E.9000606@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 4 March 2010 12:01, John Robinson <john.robinson@anonymous.org.uk> w=
rote:
> On 04/03/2010 11:30, Alex Boag-Munroe wrote:
>>
>> Hi guys...
>>
>> Yes I am an idiot. =A0I was changing the chunk size of my RAID5 arra=
y
>> last night from 64kb to 256kb and left it running overnight. =A0Duri=
ng
>> the night we had a power outage.
>>
>> This is where the idiot part comes in. =A0The backup file is on a
>> filesystem that's part of the RAID5 array, so obviously I am unable =
to
>> start it. =A0I completely forgot the filesystem I specified for
>> --backup-file was part of the same array.
>>
>> Once you're all done pointing and laughing, can you let me know if I
>> am totally screwed? =A0I've a lot of data here that I -really- don't
>> want to lose...
>>
>> Please help..
>>
>> Idiot.
>>
>> --
>> Alex Boag-Munroe
>>
>> Lack of planning on your part does not constitute an emergency on mi=
ne.
>
> OK, I was done pointing and laughing, until I saw your signature. Did=
 you
> choose that on purpose or did Gmail pick it for you?
>
> I'm afraid I can't help with your problem, except to say that I've a =
feeling
> you ought to be able to manually restart the half-reshaped array with=
out the
> backup file, so the worst case ought to be that you might lose one ba=
ckup
> file's worth of data. However, kernel and mdadm versions together wit=
h
> output of `mdadm --detail` of your md device and `mdadm --examine` of=
 its
> constituent devices will help those more knowledgeable than me tell y=
ou what
> to do next. If you're lucky the boss, Neil Brown, will help but I ima=
gine
> he's asleep right now since he lives in Australia and it's the middle=
 of the
> night there.
>
> Best of luck,
>
> John.
>

Hi John, thanks so much for your reply.

That is my signature and I stand by it, hence the whole "me idiot" and
not DEMANDING I get help etc.

mdadm is version 3.1.1.  New developments.  I found a post on the
internet where Neil recommended to someone to recreate the array
without erasing it.  Which I have done, mdadm starts the array and
mdadm -D shows that almost a terabyte of space is in use.

However, mdadm -D also shows a chunk size of 512k, which is neither
the 64k original chunk nor the 512k I asked for.

Kernel version is gentoo-sources-2.6.33.

Output of mdadm --examine for /dev/sda5 through /dev/sdd5:

/dev/sda5:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 17862986:014cb4c0:ffe6e849:786ed339 (local to host nc=
c-1701-e)
  Creation Time : Thu Mar  4 13:10:24 2010
     Raid Level : raid5
  Used Dev Size : 974767616 (929.61 GiB 998.16 GB)
     Array Size : 2924302848 (2788.83 GiB 2994.49 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 1

    Update Time : Thu Mar  4 13:10:29 2010
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0
       Checksum : b951290 - correct
         Events : 3

         Layout : left-symmetric
     Chunk Size : 512K

      Number   Major   Minor   RaidDevice State
this     0       8        5        0      active sync   /dev/sda5

   0     0       8        5        0      active sync   /dev/sda5
   1     1       8       21        1      active sync   /dev/sdb5
   2     2       8       37        2      active sync   /dev/sdc5
   3     3       8       53        3      active sync   /dev/sdd5
/dev/sdb5:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 17862986:014cb4c0:ffe6e849:786ed339 (local to host nc=
c-1701-e)
  Creation Time : Thu Mar  4 13:10:24 2010
     Raid Level : raid5
  Used Dev Size : 974767616 (929.61 GiB 998.16 GB)
     Array Size : 2924302848 (2788.83 GiB 2994.49 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 1

    Update Time : Thu Mar  4 13:10:29 2010
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0
       Checksum : b9512a2 - correct
         Events : 3

         Layout : left-symmetric
     Chunk Size : 512K

      Number   Major   Minor   RaidDevice State
this     1       8       21        1      active sync   /dev/sdb5

   0     0       8        5        0      active sync   /dev/sda5
   1     1       8       21        1      active sync   /dev/sdb5
   2     2       8       37        2      active sync   /dev/sdc5
   3     3       8       53        3      active sync   /dev/sdd5
/dev/sdc5:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 17862986:014cb4c0:ffe6e849:786ed339 (local to host nc=
c-1701-e)
  Creation Time : Thu Mar  4 13:10:24 2010
     Raid Level : raid5
  Used Dev Size : 974767616 (929.61 GiB 998.16 GB)
     Array Size : 2924302848 (2788.83 GiB 2994.49 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 1

    Update Time : Thu Mar  4 13:10:29 2010
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0
       Checksum : b9512b4 - correct
         Events : 3

         Layout : left-symmetric
     Chunk Size : 512K

      Number   Major   Minor   RaidDevice State
this     2       8       37        2      active sync   /dev/sdc5

   0     0       8        5        0      active sync   /dev/sda5
   1     1       8       21        1      active sync   /dev/sdb5
   2     2       8       37        2      active sync   /dev/sdc5
   3     3       8       53        3      active sync   /dev/sdd5
/dev/sdd5:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 17862986:014cb4c0:ffe6e849:786ed339 (local to host nc=
c-1701-e)
  Creation Time : Thu Mar  4 13:10:24 2010
     Raid Level : raid5
  Used Dev Size : 974767616 (929.61 GiB 998.16 GB)
     Array Size : 2924302848 (2788.83 GiB 2994.49 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 1

    Update Time : Thu Mar  4 13:10:29 2010
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0
       Checksum : b9512c6 - correct
         Events : 3

         Layout : left-symmetric
     Chunk Size : 512K

      Number   Major   Minor   RaidDevice State
this     3       8       53        3      active sync   /dev/sdd5

   0     0       8        5        0      active sync   /dev/sda5
   1     1       8       21        1      active sync   /dev/sdb5
   2     2       8       37        2      active sync   /dev/sdc5
   3     3       8       53        3      active sync   /dev/sdd5

Booting with autodetecting raid, states that there's no valid 0.9 super=
block.

--=20
Alex Boag-Munroe

Lack of planning on your part does not constitute an emergency on mine.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
