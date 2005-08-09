From: "Mark Cuss" <mcuss@cdlsystems.com>
Subject: Re: How to force a spare drive to take over in a RAID5?
Date: Tue, 9 Aug 2005 13:48:50 -0600
Message-ID: <00b301c59d1b$5d5645a0$ab0e10ac@pinchy>
References: <45138.213.188.237.106.1123086677.squirrel@localhost> <20050804195853.0866ade9.akpm@osdl.org> <34082.213.188.237.106.1123228569.squirrel@localhost> <20050805010236.12d811ff.akpm@osdl.org> <006301c599ca$69410700$ab0e10ac@pinchy> <42F5F0B0.3050105@dgreaves.com> <012701c59c62$3db09d40$ab0e10ac@pinchy> <1123540166.17810.1.camel@star2.austin.ibm.com>
Reply-To: "Mark Cuss" <mcuss@cdlsystems.com>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid-owner@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hmm - Okay.  If I do that, I get "/dev/sdr1 does not appear to be an md 
device".  If I add --force with this it doesn't seem to matter.

I think the problem is that the superblock is hooched up on this drive and 
therefore mdadm doesn't think it's a part of the array, even though 
madam --detail /dev/md4 lists it:
[root@hal root]# mdadm --detail /dev/md4
/dev/md4:
        Version : 00.90.00
  Creation Time : Sat Sep 11 14:07:20 2004
     Raid Level : raid5
     Array Size : 430115904 (410.19 GiB 440.48 GB)
    Device Size : 143371968 (136.73 GiB 146.86 GB)
   Raid Devices : 4
  Total Devices : 5
Preferred Minor : 4
    Persistence : Superblock is persistent

    Update Time : Mon Jul 18 10:43:13 2005
          State : dirty, no-errors
 Active Devices : 4
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 1

         Layout : left-symmetric
     Chunk Size : 64K

    Number   Major   Minor   RaidDevice State
       0      65       17        0      active sync   /dev/sdr1
       1       8      161        1      active sync   /dev/sdk1
       2       8      177        2      active sync   /dev/sdl1
       3       8      193        3      active sync   /dev/sdm1
       4      65       33        4        /dev/sds1
           UUID : 24989439:d4f0d908:67494e4a:97b3ba91
[root@hal root]#

I'd really like to get this md device to rebuilt onto sds and get rid of 
sdr, but I'm not sure what to do next.  I guess I could do something drastic 
like remove the device from the SCSI chain by echoing the 
"remove-single-device" command to /proc/scsi - I imagine that would trigger 
a rebuild onto the spare drive sds, but I'm nervous to try that on a 
production device until I ask the experts here :)

Thanks
Mark

----- Original Message ----- 
From: "Mike Tran" <mhtran@us.ibm.com>
To: <linux-raid@vger.kernel.org>
Sent: Monday, August 08, 2005 4:29 PM
Subject: Re: How to force a spare drive to take over in a RAID5?


> You're on the right track :) mdadm --fail /dev/sdr should do.
>
> --
> Mike T.
>
> On Mon, 2005-08-08 at 16:43, Mark Cuss wrote:
>> Kernel 2.4.27
>>
>> I've been using the old raidtools stuff and am new to mdadm - sorry if 
>> this
>> is a obvisouly simply question...
>>
>> After perusing the man page, is looks to me that I should use mdadm to 
>> mark
>> the drive I want to remove as failed to force a rebuild on the spare 
>> drive.
>> I want to double check that this is correct first though, as this md 
>> device
>> contains 300 gig of production data.
>>
>> Thanks for the help!
>>
>> Mark
>>
>> ----- Original Message ----- 
>> From: "David Greaves" <david@dgreaves.com>
>> To: "Mark Cuss" <mcuss@cdlsystems.com>
>> Cc: <linux-raid@vger.kernel.org>
>> Sent: Sunday, August 07, 2005 5:29 AM
>> Subject: Re: How to force a spare drive to take over in a RAID5?
>>
>>
>> > Mark Cuss wrote:
>> >
>> >> Hi!
>> >>
>> >> I have a 4 drive SW RAID5 running on my machine.  One of the drives is
>> >> upset for some reason - I'm not sure if the drive itself is bad, but
>> >> that's not too important right now.  The important thing is to get the
>> >> RAID5 to stop using this drive and start using a spare drive that I
>> >> just added.
>> >
>> >
>> >> I did a raidhotadd to add in a new drive, sds.  Now, I would like the
>> >> array to stop using sdr and reconstruct all of the parity tables on
>> >> sds so I can pull sdr and get it replaced or whatever...
>> >>
>> >> Any ideas?
>> >
>> > Install and read the manpage for mdadm
>> >
>> > What kernel version?
>> >
>> > David
>> >
>>
>>
>> -
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


