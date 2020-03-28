From: Alexander Shenkin <al@shenkin.org>
Subject: Re: Raid-6 won't boot
Date: Sat, 28 Mar 2020 07:47:14 +0000
Message-ID: <1f393884-dc48-c03e-f734-f9880d9eed96@shenkin.org>
References: <7ce3a1b9-7b24-4666-860a-4c4b9325f671@shenkin.org>
 <3868d184-5e65-02e1-618a-2afeb7a80bab@youngman.org.uk>
 <ccab6f84-aab3-f483-e473-64d95cbeb7cc@shenkin.org>
 <CAAMCDee6TcJ_wR6rkQw5V02KyqPQ+xDf+bK+pQPbbfaptO_Tvg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAAMCDee6TcJ_wR6rkQw5V02KyqPQ+xDf+bK+pQPbbfaptO_Tvg@mail.gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Roger Heflin <rogerheflin@gmail.com>
Cc: antlists <antlists@youngman.org.uk>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Thanks Roger.  dmesg has nothing in it referring to md126 or md127....
any other thoughts on how to investigate?

thanks,
allie

On 3/27/2020 3:55 PM, Roger Heflin wrote:
> A non-assembled array always reports raid1.
> 
> I would run "dmesg | grep md126" to start with and see what it reports it saw.
> 
> On Fri, Mar 27, 2020 at 10:29 AM Alexander Shenkin <al@shenkin.org> wrote:
>>
>> Thanks Wol,
>>
>> Booting in SystemRescueCD and looking in /proc/mdstat, two arrays are
>> reported.  The first (md126) in reported as inactive with all 7 disks
>> listed as spares.  The second (md127) is reported as active
>> auto-read-only with all 7 disks operational.  Also, the only
>> "personality" reported is Raid1.  I could go ahead with your suggestion
>> of mdadm --stop array and then mdadm --assemble, but I thought the
>> reporting of just the Raid1 personality was a bit strange, so wanted to
>> check in before doing that...
>>
>> Thanks,
>> Allie
>>
>> On 3/26/2020 10:00 PM, antlists wrote:
>>> On 26/03/2020 17:07, Alexander Shenkin wrote:
>>>> I surely need to boot with a rescue disk of some sort, but from there,
>>>> I'm not sure exactly when I should do.  Any suggestions are very welcome!
>>>
>>> Okay. Find a liveCD that supports raid (hopefully something like
>>> SystemRescueCD). Make sure it has a very recent kernel and the latest
>>> mdadm.
>>>
>>> All being well, the resync will restart, and when it's finished your
>>> system will be fine. If it doesn't restart on its own, do an "mdadm
>>> --stop array", followed by an "mdadm --assemble"
>>>
>>> If that doesn't work, then
>>>
>>> https://raid.wiki.kernel.org/index.php/Linux_Raid#When_Things_Go_Wrogn
>>>
>>> Cheers,
>>> Wol
