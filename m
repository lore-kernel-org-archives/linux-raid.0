From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: Does a "check" of a RAID6 actually read all disks in a stripe?
Date: Tue, 28 Apr 2020 22:00:41 +0800
Message-ID: <1d7fe96e-d87a-185d-1599-84cc445383cf@fnarfbargle.com>
References: <18271293-9866-1381-d73e-e351bf9278fd@fnarfbargle.com>
 <1ccd57ba-9d9a-d10e-4efd-dc0e8a5cf162@fnarfbargle.com>
 <e02412eb-d7f3-cea8-7398-4e5c0d749f43@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e02412eb-d7f3-cea8-7398-4e5c0d749f43@turmel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On 28/4/20 9:47 pm, Phil Turmel wrote:
> On 4/28/20 7:02 AM, Brad Campbell wrote:
>>
>>
>> On 28/4/20 2:47 pm, Brad Campbell wrote:
>>> G'day all,
>>>
>>> I have a test server with some old disks I use for beating up on. Bear in mind the disks are old and dicey which is *why* they live in a test server. I'm not after reliability, I'm more interested in finding corner cases.
>>>
>>> One disk has a persistent read error (pending sector). This can be identified easily with dd on a specific or whole disk basis.
>
> [trim /]
>
>>> Examine on the suspect disk :
>>>
>>> test:/home/brad# mdadm --examine /dev/sdj
>>> /dev/sdj:
>>>            Magic : a92b4efc
>>>          Version : 1.2
>>>      Feature Map : 0x1
>>>       Array UUID : dbbca7b5:327751b1:895f8f11:443f6ecb
>>>             Name : test:3  (local to host test)
>>>    Creation Time : Wed Nov 29 10:46:21 2017
>>>       Raid Level : raid6
>>>     Raid Devices : 9
>>>
>>>   Avail Dev Size : 3906767024 (1862.89 GiB 2000.26 GB)
>>>       Array Size : 13673684416 (13040.24 GiB 14001.85 GB)
>>>    Used Dev Size : 3906766976 (1862.89 GiB 2000.26 GB)
>>>      Data Offset : 262144 sectors
>>>     Super Offset : 8 sectors
>>>     Unused Space : before=262056 sectors, after=48 sectors
>>>            State : clean
>>>      Device UUID : f1a39d9b:fe217c62:26b065e3:0f859afd
>>>
>>> Internal Bitmap : 8 sectors from superblock
>>>      Update Time : Tue Apr 28 09:39:23 2020
>>>    Bad Block Log : 512 entries available at offset 72 sectors
>
> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>
>>>         Checksum : cb44256b - correct
>>>           Events : 177156
>>>
>>>           Layout : left-symmetric
>>>       Chunk Size : 64K
>>>
>>>     Device Role : Active device 5
>>>     Array State : AA.AAAAAA ('A' == active, '.' == missing, 'R' == replacing)
>
> The bad block log misfeature is turned on.  Any blocks recorded in it will never be read again by MD, last I looked.  This might explain what you are seeing.
>
>
While I see where you are going, the fact it corrected the bad sector by re-writing it during the re-build would intimate that isn't/wasn't the case.

Regards,

Brad
