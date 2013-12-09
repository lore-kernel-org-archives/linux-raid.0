From: Christopher Hoover <ch@murgatroid.com>
Subject: Re: unable to assemble (mostly?) clean array
Date: Sun, 8 Dec 2013 19:00:02 -0800
Message-ID: <CACw0PsZ9=pL=D9fdQpzoFHCnm3DceEy_Erw0jjxpJgNjjTo9ew@mail.gmail.com>
References: <CACw0PsYr+u=YqXQJtUBLDzoppXPWCoRRLUqvgPLE4_L+V68iZw@mail.gmail.com>
 <52A5089D.3080109@websitemanagers.com.au> <CACw0PsYs+UwDVoPXAB6qf8j8OhU5qd8YhEeTj4Bok9aNR+bVew@mail.gmail.com>
 <20131209120217.54dd3082@notabene.brown> <CACw0PsaCzZAKWeh9MxXK39Fpwh5wg-bjHHMY0-0djW+59Qf-jQ@mail.gmail.com>
 <20131209123305.04e7257f@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20131209123305.04e7257f@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Adam Goryachev <adam@websitemanagers.com.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

OK, seems to be back to doing "something".    See below.

I'm a little concerned that it "promoted" sde1 rather than relying on
the other three drives with the same event count.

Very much thank you for your help!

-ch

p.s. is there anyway to assemble a container from components in read
only mode?  I have a feeling i'm going to loved sde1 again before the
recovery.



ch@snaggle:~/src/mdadm$ sudo ./mdadm -Avf /dev/md0  /dev/sd[efdg]1
mdadm: looking for devices for /dev/md0
mdadm: /dev/sdd1 is identified as a member of /dev/md0, slot 4.
mdadm: /dev/sde1 is identified as a member of /dev/md0, slot 1.
mdadm: /dev/sdf1 is identified as a member of /dev/md0, slot 2.
mdadm: /dev/sdg1 is identified as a member of /dev/md0, slot 5.
mdadm: forcing event count in /dev/sde1(1) from 286011 upto 286024
mdadm: no uptodate device for slot 0 of /dev/md0
mdadm: added /dev/sdf1 to /dev/md0 as 2
mdadm: no uptodate device for slot 6 of /dev/md0
mdadm: added /dev/sdd1 to /dev/md0 as 4
mdadm: added /dev/sdg1 to /dev/md0 as 5
mdadm: added /dev/sde1 to /dev/md0 as 1
mdadm: /dev/md0 has been started with 2 drives (out of 4) and 2 spares.

ch@snaggle:~/src/mdadm$ sudo mdadm -D /dev/md0
/dev/md0:
        Version : 0.90
  Creation Time : Mon May 23 00:02:10 2011
     Raid Level : raid6
     Array Size : 2930271872 (2794.53 GiB 3000.60 GB)
  Used Dev Size : 1465135936 (1397.26 GiB 1500.30 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Sun Dec  8 18:53:29 2013
          State : clean, degraded, recovering
 Active Devices : 2
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 2

         Layout : left-symmetric
     Chunk Size : 64K

 Rebuild Status : 0% complete

           UUID : 48af1ed4:8978e992:f8a6b934:875c877f (local to host snaggle)
         Events : 0.286025

    Number   Major   Minor   RaidDevice State
       4       8       97        0      spare rebuilding   /dev/sdg1
       1       8       65        1      active sync   /dev/sde1
       2       8       81        2      active sync   /dev/sdf1
       5       8       49        3      spare rebuilding   /dev/sdd1
ch@snaggle:~/src/mdadm$


On Sun, Dec 8, 2013 at 5:33 PM, NeilBrown <neilb@suse.de> wrote:
> On Sun, 8 Dec 2013 17:08:19 -0800 Christopher Hoover <ch@murgatroid.com>
> wrote:
>
>> ch@snaggle:~$ sudo mdadm --assemble --verbose  --force /dev/md0  /dev/sd[defg]1
>> mdadm: looking for devices for /dev/md0
>> mdadm: /dev/sdd1 is identified as a member of /dev/md0, slot 4.
>> mdadm: /dev/sde1 is identified as a member of /dev/md0, slot 1.
>> mdadm: /dev/sdf1 is identified as a member of /dev/md0, slot 2.
>> mdadm: /dev/sdg1 is identified as a member of /dev/md0, slot 5.
>> mdadm: ignoring /dev/sde1 as it reports /dev/sdd1 as failed
>> mdadm: ignoring /dev/sdf1 as it reports /dev/sdd1 as failed
>> mdadm: no uptodate device for slot 0 of /dev/md0
>> mdadm: no uptodate device for slot 1 of /dev/md0
>> mdadm: no uptodate device for slot 2 of /dev/md0
>> mdadm: no uptodate device for slot 3 of /dev/md0
>> mdadm: added /dev/sdg1 to /dev/md0 as 5
>> mdadm: added /dev/sdd1 to /dev/md0 as 4
>> mdadm: /dev/md0 assembled from 0 drives and 2 spares - not enough to
>> start the array.
>> ch@snaggle:~$
>
> Thanks.
>
> I recognise this bug now.  You are running mdadm-3.2.something - correct?
> You need 3.3.
> Just grab the latest:
>
>  cd /tmp;git clone git://neil.brown.name/mdadm ; cd mdadm ; make ; ./mdadm  -Avf /dev/md0 /dev/sd[defg]1
>
> NeilBrown
>
>
>>
>> On Sun, Dec 8, 2013 at 5:02 PM, NeilBrown <neilb@suse.de> wrote:
>> > On Sun, 8 Dec 2013 16:32:22 -0800 Christopher Hoover <ch@murgatroid.com>
>> > wrote:
>> >
>> >> yes, thanks, typo there.  that was done hastily for the e-mail.
>> >>
>> >> i had tried the right thing previously and here it is again.  still no luck:
>> >>
>> >>
>> >> ch@snaggle:~$ sudo mdadm -E /dev/sd[defg]1 | egrep 'Events|^/dev/sd'
>> >> /dev/sdd1:
>> >>          Events : 286024
>> >> /dev/sde1:
>> >>          Events : 286011
>> >> /dev/sdf1:
>> >>          Events : 286024
>> >> /dev/sdg1:
>> >>          Events : 286024
>> >> ch@snaggle:~$ sudo mdadm --assemble --force /dev/md0  /dev/sd[dfg]1
>> >> mdadm: ignoring /dev/sdf1 as it reports /dev/sdd1 as failed
>> >> mdadm: /dev/md0 assembled from 0 drives and 2 spares - not enough to
>> >> start the array.
>> >> ch@snaggle:~$
>> >
>> > Please try listing *all* of the devices, and add "-v" for extra output.
>> >
>> > NeilBrown
>
