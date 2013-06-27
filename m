From: Martin Wilck <mwilck@arcor.de>
Subject: Re: [PATCH 1/2] select_devices: fix scanning of container members
 with dev list
Date: Thu, 27 Jun 2013 20:15:08 +0200
Message-ID: <51CC812C.3030500@arcor.de>
References: <1371759665-5625-1-git-send-email-mwilck@arcor.de> <20130624165547.0c0bd93b@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130624165547.0c0bd93b@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

>> commit b3908491 "Detail: fix --brief --verbose" introduced a
>> problem when a mdadm.conf file generated with
>> "mdadm --Detail --brief --verbose" is later scanned with
>> "mdadm --Assemble --scan --config=mdadm.conf"
>>
>> mdadm -Dbv will print a "devices" list now, but because the
>> container device is not in that list, it won't be considered
>> for assembly.
>>
>> This patch fixes that by moving the test for member devices
>> further down, after the check for a container.
>>
>> Signed-off-by: Martin Wilck <mwilck@arcor.de>
> 
> Hi Martin,
>  I really don't like this.  If there is a "device=" entry then it should not
>  even open anything not listed.

That doesn't work for containers. The "device" in the container case is
the container itself. Only by parsing the container and its subarrays
does mdadm -As succeed.

>  Can you give me more details about the problem you are experiencing?  Maybe
>  the problem is in "mdadm -Dbv".

Well, the problem might be fixed differently by having "mdadm -Dbv" in
the container case print the container device. I am not sure if that's
what you meant.

Below is the output of mdadm -Dbv from the DDF test case. Without my
patch, it can't be assembled with -As because /dev/md/ddf0 is not in the
devices list. If the "devices=" lines are deleted from the file, it
works. It would also work if the container device was a member of the
devices list.

Note that even if the "devices=" line is missing, select_devices() will
discard all the devices listed for subarrays ("/dev/loop10 has wrong
UUID"). This is because getinfo_super() will return the UUID of the
container, not of any subarray, in line 370 of Assemble.c. But the
scanning of the container device works.

ARRAY /dev/md/ddf0 level=container num-devices=5 metadata=ddf
UUID=0cadff6e:56f14bc0:5ac6bed5:b602c0a9
   devices=/dev/loop10,/dev/loop11,/dev/loop12,/dev/loop8,/dev/loop9
ARRAY /dev/md/r0 level=raid0 num-devices=5 container=/dev/md/ddf0
member=0 UUID=6c900c64:1873e2d0:ee78718b:7f156c44
   devices=/dev/loop10,/dev/loop11,/dev/loop12,/dev/loop8,/dev/loop9
ARRAY /dev/md/r1 level=raid1 num-devices=2 container=/dev/md/ddf0
member=1 UUID=caae05ca:e07a497a:bd066562:b5164eea
   devices=/dev/loop8,/dev/loop9
ARRAY /dev/md/r5 level=raid5 num-devices=3 container=/dev/md/ddf0
member=2 UUID=29f6e6ea:16d4a6f7:1808b76e:33c50480
   devices=/dev/loop10,/dev/loop11,/dev/loop12

Regards
Martin

