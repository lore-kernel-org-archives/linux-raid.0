From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Can not start md0 after upgrade.
Date: Wed, 25 May 2011 16:57:38 -0500
Message-ID: <4DDD7B52.2060800@hardwarefreak.com>
References: <201105250819.27372.johnm@advocap.org> <201105251006.30945.johnm@advocap.org> <4DDD22C7.2000501@hardwarefreak.com> <201105251521.15679.johnm@advocap.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201105251521.15679.johnm@advocap.org>
Sender: linux-raid-owner@vger.kernel.org
To: John McMonagle <johnm@advocap.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 5/25/2011 3:21 PM, John McMonagle wrote:
> 
> On Wednesday 25 May 2011 10:39:51 am Stan Hoeppner wrote:
>> On 5/25/2011 10:06 AM, John McMonagle wrote:
>>> On Wednesday, May 25, 2011 09:54:32 am Stan Hoeppner wrote:
>>>> On 5/25/2011 8:19 AM, John McMonagle wrote:
>>>>> Just upgraded a poweredge 1850 server from Debian lenny to squeeze and
>>>>> can not boot with the new 2.6.32 kernel.
>>>>>
>>>>> From lspci  have this controller:
>>>>> SCSI storage controller: LSI Logic / Symbios Logic 53c1030 PCI-X
>>>>> Fusion-MPT Dual Ultra320 SCSI (rev 08)
>>>>>
>>>>>
>>>>> Running mdadm raid with root on md0.
>>>>>
>>>>> Normally run xen but all  info is for when running without xen.
>>>>>
>>>>> I can still boot with the 2.6.26 kernel but not with the new 2.6.32
>>>>> kernel. Under 2.6.32 it fails to start md0.
>>>>> in the busy box console
>>>>> Can see all the needed partitions.
>>>>> What was sda and sdb are now sdb and sdc that should not matter??
>>>>> mdadm.conf is:
>>>>> DEVICE partitions
>>>>> CREATE owner=root group=disk mode=0660 auto=yes
>>>>> HOMEHOST <system>
>>>>> MAILADDR xxxxx@advocap.org
>>>>> ARRAY /dev/md0 level=raid1 num-devices=2
>>>>> UUID=6f744c89:d2578f95:c150b018:d9f789b1
>>>>> ARRAY /dev/md1 level=raid1 num-devices=2
>>>>> UUID=7938d59c:28a69e5e:3facbdc2:12974557
>>>>
>>>> This is probably due to udev changes.  What device is now sda?
>>>>
>>>> Using drive UUIDs instead of /dev/sdx in your arrays should fix this.
>>>
>>> I think sda is a cd or virtual  cd now.
>>>
>>> In the mdadm.conf it uses uuids and no /dev/sdx references or are you
>>> referring to something else?
>>
>> How is /dev/md0 assembled in your initramfs?  You said your root
>> filesystem is on /dev/md0.  Thus /dev/md0 must be assembled before
>> /etc/mdadm.conf can be read.
>>
>> Another way around this problem is to create persistent udev rules.  But
>> since this requires created one-to-one mappings between
>> /dev/sdx<->drive_UUID mappings, it is easy to simply have mdraid use
>> drive UUIDs across the board, including within initramfs.
> 
> Stan
> 
> The /etc/mdadm/mdadm.conf file is in the initramfs and is referenced by 
> the  /scripts/local-top/mdadm script.
> If I run it manually it starts raid Ok and I can mount  /dev/md0
> I'm not sure how on gets it to complete the boot process.

Please show the contents of /etc/mdadm.conf, and dmesg output.

-- 
Stan
