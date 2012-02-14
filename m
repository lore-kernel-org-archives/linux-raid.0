From: Jeff Johnson <jeff.johnson@aeoncomputing.com>
Subject: Re: SES Enclosure Management.
Date: Tue, 14 Feb 2012 13:24:00 -0800
Message-ID: <4F3AD0F0.7010306@aeoncomputing.com>
References: <CAB9NSeUBZXdGRkNNzYjC-KmJjv_AUp4bD_dJH2XyzkuO7PUPcw@mail.gmail.com> <20120215073130.792d4fae@notabene.brown> <4F3AC741.6050204@gmail.com> <4F3AC9CB.3070707@gmail.com> <4F3ACAF6.4030004@gmail.com> <4F3ACCC4.6070901@aeoncomputing.com> <4F3ACDD7.5040506@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F3ACDD7.5040506@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2/14/12 1:10 PM, Robert Woodworth wrote:
> On 02/14/2012 02:06 PM, Jeff Johnson wrote:
>> On 2/14/12 12:58 PM, Joe Landman wrote:
>>> <..snip...>
>>>> enclosure provides a device on the SCSI bus and you exclusively
>>>> communicate with that device regardless of the HBA. Most HW RAIDs (LSI
>>>> MegaRAID) will hide the SES device exactly like they hide the physical
>>>> disks.
>>>>
>>> A true managed enclosure has nothing to do with the HBA. A managed
>>>
>>> Ok.  Let me look to see if we can do this.  If so, we should be able 
>>> to help contribute some scripts.
>> I've been doing this for a while. In SES the various elements (slot, 
>> power supplies, fans, etc) are named.  At least if your JBOD vendor 
>> has their **** together. There is no need to decipher arrays of hex 
>> values and modify bits to assert control. Once you know the names of 
>> your elements you can address them by name for status and control 
>> (fault LED, power on/off, temps, etc).
>>
>> --Jeff
>
> Correct!  Now I just want to connect the RAID system to the SES system 
> so that when a disk fails, the kernel module that failed the disk can 
> light up the LED.
>
> I work for one of those vendors, it's my job to have our **** together.
>
The trick is to map the disk element names to the block device names. 
Different SAS HBAs and drivers can enumerate the devices differently. 
Persistence settings can muck things up as well. Sometimes a failed 
block device at /dev/sdf can appear as /dev/sdr when replaced. You could 
use udev rules to create alternate block device names but so far, for 
important data, I've seen no substitute for a pair of knowledgeable 
human eyes analyzing a failure and confirming a failed drive by 
corelating WWNs, etc.

--Jeff

-- 
------------------------------
Jeff Johnson
Manager
Aeon Computing

jeff.johnson@aeoncomputing.com
www.aeoncomputing.com
t: 858-412-3810 x101   f: 858-412-3845
m: 619-204-9061

4905 Morena Boulevard, Suite 1313 - San Diego, CA 92117

