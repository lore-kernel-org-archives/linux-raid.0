From: Asdo <asdo@shiftmail.org>
Subject: Re: Some md/mdadm bugs
Date: Tue, 07 Feb 2012 18:47:06 +0100
Message-ID: <4F31639A.7020703@shiftmail.org>
References: <4F2ADF45.4040103@shiftmail.org>
 <20120203081717.195bfec8@notabene.brown> <4F2B1519.5010500@shiftmail.org>
 <4F3008DA.8060402@shiftmail.org> <20120207092005.7c11171a@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <20120207092005.7c11171a@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 02/06/12 23:20, NeilBrown wrote:
>>
>> Problem #2:
>>
>> by reinserting sda, it became sdax, and the array is still running like
>> this:
>>
>> md3 : active raid1 sdb4[2]
>>         10485688 blocks super 1.0 [2/1] [_U]
>>         bitmap: 0/160 pages [0KB], 32KB chunk
>>
>> please note the bitmap is active
> True, but there is nothing in it (0 pages).  That implies that no bits are
> set.  I guess that is possible if nothing has been written to the array since
> the other device was removed.

Almost certain: the array is not really in use (no lvm, not mounted) 
even if running


>> so now I'm trying auto hot-add:
>>
>> # mdadm  -I /dev/sdax4
>> mdadm: not adding /dev/sdax4 to active array (without --run) /dev/md3
>>
>> still the old problem I mentioned with 3.1.4.
> I need to see -E and -X output on both drives to be able to see what is
> happening here.  Also the content of /etc/mdadm.conf might be relevant.
> If you could supply that info I might be able to explain what is happening.


Please note the names changed since yesterday, because of hot-swap tests 
and reboots:
now it's sda4 and sdb4


md3 : active raid1 sdb4[2]
       10485688 blocks super 1.0 [2/1] [_U]
       bitmap: 0/160 pages [0KB], 32KB chunk


# ./mdadm -E /dev/sda4
/dev/sda4:
           Magic : a92b4efc
         Version : 1.0
     Feature Map : 0x1
      Array UUID : 8da28111:cdb69fa9:8d607b48:78fb102d
            Name : hardstorage1:sys2boot
   Creation Time : Mon Mar 21 16:13:46 2011
      Raid Level : raid1
    Raid Devices : 2

  Avail Dev Size : 20971376 (10.00 GiB 10.74 GB)
      Array Size : 20971376 (10.00 GiB 10.74 GB)
    Super Offset : 20971504 sectors
           State : clean
     Device UUID : c470ba58:897d9cb5:4054c89a:d41608d3

Internal Bitmap : -81 sectors from superblock
     Update Time : Tue Feb  7 17:25:16 2012
        Checksum : a4deb673 - correct
          Events : 106


    Device Role : Active device 0
    Array State : AA ('A' == active, '.' == missing)

# ./mdadm -X /dev/sda4
         Filename : /dev/sda4
            Magic : 6d746962
          Version : 4
             UUID : 8da28111:cdb69fa9:8d607b48:78fb102d
           Events : 106
   Events Cleared : 61
            State : OK
        Chunksize : 32 KB
           Daemon : 5s flush period
       Write Mode : Normal
        Sync Size : 10485688 (10.00 GiB 10.74 GB)
           Bitmap : 327678 bits (chunks), 0 dirty (0.0%)


# ./mdadm -E /dev/sdb4
/dev/sdb4:
           Magic : a92b4efc
         Version : 1.0
     Feature Map : 0x1
      Array UUID : 8da28111:cdb69fa9:8d607b48:78fb102d
            Name : hardstorage1:sys2boot
   Creation Time : Mon Mar 21 16:13:46 2011
      Raid Level : raid1
    Raid Devices : 2

  Avail Dev Size : 20971376 (10.00 GiB 10.74 GB)
      Array Size : 20971376 (10.00 GiB 10.74 GB)
    Super Offset : 20971504 sectors
           State : clean
     Device UUID : 0c978768:dccaa84d:4cbe07ee:501f863e

Internal Bitmap : -81 sectors from superblock
     Update Time : Tue Feb  7 17:29:06 2012
        Checksum : b769d7e - correct
          Events : 108


    Device Role : Active device 1
    Array State : .A ('A' == active, '.' == missing)

# ./mdadm -X /dev/sdb4
         Filename : /dev/sdb4
            Magic : 6d746962
          Version : 4
             UUID : 8da28111:cdb69fa9:8d607b48:78fb102d
           Events : 108
   Events Cleared : 61
            State : OK
        Chunksize : 32 KB
           Daemon : 5s flush period
       Write Mode : Normal
        Sync Size : 10485688 (10.00 GiB 10.74 GB)
           Bitmap : 327678 bits (chunks), 0 dirty (0.0%)




# cat /etc/mdadm/mdadm.conf
AUTO +1.x

(I made it simple :-D )


>> Trying more ways: (even with the "--run" which is suggested)
>>
>> # mdadm --run -I /dev/sdax4
>> mdadm: -I would set mdadm mode to "incremental", but it is already set
>> to "misc".
>>
>> # mdadm -I --run /dev/sdax4
>> mdadm: failed to add /dev/sdax4 to /dev/md3: Invalid argument.
>>
> Hmm... I'm able to reproduce something like this.
>
> Following patch seems to fix it, but I need to check the code more
> thoroughly to be sure.

Congrats, it really seems to fix it at least for 3.2.3:

before (with 3.2.3 from your git):

# ./mdadm -I /dev/sda4
mdadm: not adding /dev/sda4 to active array (without --run) /dev/md3

# ./mdadm -I --run /dev/sda4
mdadm: failed to add /dev/sda4 to /dev/md3: Invalid argument.


3.2.3 + your patch:

# ./mdadm -I /dev/sda4
mdadm: not adding /dev/sda4 to active array (without --run) /dev/md3

# ./mdadm -I --run /dev/sda4
mdadm: /dev/sda4 attached to /dev/md3 which is already active.



>   Note that this will *not* fix the "not adding ... not
> active array" problem.

it's not a: "not adding ... to not active array..."
but instead it's a: "not adding ... to *active* array..."

However, yes, I think the behaviour without --run should be different 
than it is now

Thanks for your help
A.
