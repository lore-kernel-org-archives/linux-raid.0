From: Larkin Lowrey <llowrey@nuclearwinter.com>
Subject: Re: Sleepy drives and MD RAID 6
Date: Thu, 14 Aug 2014 13:05:25 -0500
Message-ID: <53ECFA65.7050500@nuclearwinter.com>
References: <CAH_2GheOOaJRp7YimEsorFzGUJyObG2QsOpu87CYvwLPwz-V+A@mail.gmail.com>	<53E96C21.2050309@nuclearwinter.com>	<53E9AC63.1020809@gmail.com>	<BLU436-SMTP2487F2FA5F4B1A1A1B1E87B98EA0@phx.gbl>	<CAH_2GhfBKiJAT=+zCFH0_xkmyTfWFi=c-F+z8rwL1x++UwU+KA@mail.gmail.com>	<CAH_2Ghc+M2dCQBs3iRXYPZwKAsvY-TbS852VxhReT4k8HBQkQQ@mail.gmail.com>	<CAH_2GhcVeVv7Uh5Gw9nwmkzisABuTkHPK9hXUxzb=EPkBNu+dQ@mail.gmail.com>	<53ECEB42.8080400@nuclearwinter.com> <CAH_2Ghd5WZLhhct9drM1kgsNiYAQrWXeNxarSaST18PcuYc7HA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAH_2Ghd5WZLhhct9drM1kgsNiYAQrWXeNxarSaST18PcuYc7HA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Talbot <ajtalbot1@gmail.com>
Cc: "Wilson, Jonathan" <piercing_male@hotmail.com>, Can Jeuleers <can.jeuleers@gmail.com>, linux-raid@vger.kernel.org, rm@romanrm.net
List-Id: linux-raid.ids

My LSI SAS controller (SAS2008) is newer and may behave differently but
I guessing this is your problem.

I've been very happy with my HighPoint controllers (difficult to say in
public). I have an 8 port Rocket 2720SGL ($150) and a 16 port RocketRaid
2740 ($400+) . Both have worked flawlessly and performance has been
excellent. The 16 port card actually has two 8 port controllers on it
bridged together. I think you're better off with 2 8 port cards.

The 8 port RocketRaid 2680 is slower (3Gb/s) but should be fine for
spinning rust and is about $100. I don't have any experience with those.
I found one on ebay for $45 so there may be some good deals on that one
since it's a generation older.

--Larkin

On 8/14/2014 12:37 PM, Adam Talbot wrote:
> For testing I use two windows, just to make sure they are run
> independent. My shell script uses "(setsid put_some_command_here
> /dev/$i > /dev/null 2>&1 &)" to make sure the command is forced into
> the background.
>
> Hummm... A controller issue?
> lspci | grep LSI
> 07:00.0 SCSI storage controller: LSI Logic / Symbios Logic SAS1068E
> PCI-Express Fusion-MPT SAS (rev 02)
> 09:00.0 SCSI storage controller: LSI Logic / Symbios Logic SAS1068E
> PCI-Express Fusion-MPT SAS (rev 08)
> 0b:00.0 SCSI storage controller: LSI Logic / Symbios Logic SAS1068E
> PCI-Express Fusion-MPT SAS (rev 02)
> lspci | grep -i sata  (On-board)
> 00:1f.2 IDE interface: Intel Corporation 631xESB/632xESB/3100 Chipset
> SATA IDE Controller (rev 09)
>
> All but 1 of my drives are run through my 3X 4-port LSI cards.
> /dev/sdb is running through the onboard Intel SATA controller. Each
> drive takes 10 secounds to spin up. With a 7 disk RAID 6, I would
> expect a read/write to succeed 50 seconds (5 drives) after the
> request.  But on my system it always takes 40 seconds?!
>
> Quick test. sdb & sdc at the same time (Intel + LSI):
> root@nas:~/dm_drive_sleeper# time (dd if=/dev/sdc of=/dev/null bs=512k
> count=16 iflag=direct)
> 16+0 records in
> 16+0 records out
> 8388608 bytes (8.4 MB) copied, 10.2006 s, 822 kB/s
>
> real 0m10.202s
> user 0m0.000s
> sys 0m0.000s
>
> sdf & sde at the same time (LSI + LSI):root@nas:~/dm_drive_sleeper#
> time (dd if=/dev/sdf of=/dev/null bs=512k count=16 iflag=direct)
> 16+0 records in
> 16+0 records out
> 8388608 bytes (8.4 MB) copied, 10.2417 s, 819 kB/s
>
> real 0m20.208s
> user 0m0.000s
> sys 0m0.000s
>
> I blame the LSI cards!??!?   I have been looking for an excuse to
> upgrade, and now I have it!  Any clue where I can find a
> dumb/cheap/used 12-port (Or 2X 8-port).  My drive cage has 15 ports,
> standard SATA/SAS connections.  So I will have to pick up some adapter
> cables regardless of the new card type.
>
> In other news, Larkin I owe you a beer/coffee/tea.
>
> On Thu, Aug 14, 2014 at 10:00 AM, Larkin Lowrey
> <llowrey@nuclearwinter.com> wrote:
>> Have you tried the dd command w/o nonblock and putting it in the
>> background via &? You could then use the 'wait' command to wait for them
>> to finish.
>>
>> I did dust off some old memories and recalled that one of my SAS
>> controllers (LSI) does the spin ups serially no matter what and I ended
>> up moving these low duty cycle drives to my other SAS controller
>> (Marvell) and put my always spinning drives on the LSI. I've never seen
>> this behavior from any of my AHCI SATA controllers.
>>
>> --Larkin
>>
>> On 8/14/2014 11:50 AM, Adam Talbot wrote:
>>> I am running out of ideas.  Does anyone know how to wake a disk with a
>>> non-blocking, and non-caching method?
>>> I have tried the following commands:
>>> dd if=/dev/sdh of=/dev/null bs=4096 count=1 iflag=direct,nonblock
>>> hdparm --dco-identify /dev/sdh   (This gets cached after the 3~10th
>>> time running)
>>> hdparm --read-sector 48059863 /dev/sdh
>>>
>>> Any ideas?
>>>
>>> On Wed, Aug 13, 2014 at 9:07 AM, Adam Talbot <ajtalbot1@gmail.com> wrote:
>>>> Arg!!  Am I hitting some kind of blocking at the Linux kernel?? No
>>>> matter what I do, I can't seem to get the drives to spin up in
>>>> parallel.  Any ideas?
>>>>
>>>> A simple test case trying to get two drives to spin up at once.
>>>> root@nas:~# hdparm -C /dev/sdh /dev/sdg
>>>> /dev/sdh:
>>>>  drive state is:  standby
>>>>
>>>> /dev/sdg:
>>>>  drive state is:  standby
>>>>
>>>> #Two terminal windows dd'ing sdg and sdh at the same time.
>>>> root@nas:~/dm_drive_sleeper# time dd if=/dev/sdh of=/dev/null bs=4096
>>>> count=1 iflag=direct
>>>> 1+0 records in
>>>> 1+0 records out
>>>> 4096 bytes (4.1 kB) copied, 14.371 s, 0.3 kB/s
>>>>
>>>> real   0m28.139s ############# WHY?! ################
>>>> user   0m0.000s
>>>> sys   0m0.000s
>>>>
>>>> #A single drive spin-up
>>>> root@nas:~/dm_drive_sleeper# time dd if=/dev/sdh of=/dev/null bs=4096
>>>> count=1 iflag=direct
>>>> 1+0 records in
>>>> 1+0 records out
>>>> 4096 bytes (4.1 kB) copied, 14.4212 s, 0.3 kB/s
>>>>
>>>> real   0m14.424s
>>>> user   0m0.000s
>>>> sys   0m0.000s
>>>>
>>>> On Tue, Aug 12, 2014 at 8:23 AM, Adam Talbot <ajtalbot1@gmail.com> wrote:
>>>>> Thank you all for the input.  At this point I think I am going to write a
>>>>> simple daemon to do dm power management. I still think this would be a good
>>>>> feature set to roll into the driver stack, or madam-tools.
>>>>>
>>>>> As far as wear and tear on the disks. Yes, starting and stopping the drives
>>>>> shortens their life span. I don't trust my disks, regardless of
>>>>> starting/stopping, that is why I run RAID 6. Lets say I use my NAS with it's
>>>>> 7 disks for 2 hours a day, 7 days a week @ 10 watts per drive.  The current
>>>>> price for power in my area is $0.11 per kilowatt-hour. That comes out to be
>>>>> $5.62 per year to run my drives for 2 hours, daily.  But if I run my drives
>>>>> 24/7 it would cost me $67.45/year.  Basically it would cost me an extra
>>>>> $61.83/year to run the drives 24/7.  The 2TB 5400RPM SATA drives I have been
>>>>> picking up from local surplus, or auction websites are costing me $40~$50,
>>>>> including shipping and tax.  In other words I could buy a new disk every
>>>>> 8~10 months to replace failures and it would be the same cost. Drives don't
>>>>> fail that fast, even if I was start/stopping them 10 times daily. This is
>>>>> also completely ignoring the fact that drive prices are failing.  Sorry to
>>>>> disappoint, but I am going to spin down my array and save some money.
>>>>>
>>>>>
>>>>>
>>>>>
>>>>> On Tue, Aug 12, 2014 at 2:46 AM, Wilson, Jonathan
>>>>> <piercing_male@hotmail.com> wrote:
>>>>>> On Tue, 2014-08-12 at 07:55 +0200, Can Jeuleers wrote:
>>>>>>> On 08/12/2014 03:21 AM, Larkin Lowrey wrote:
>>>>>>>> Also, leaving spin-up to the controller is
>>>>>>>> also not so hot since some controllers spin-up the drives sequentially
>>>>>>>> rather than in parallel.
>>>>>>> Sequential spin-up is a feature to some, because it avoids large power
>>>>>>> spikes.
>>>>>> I vaguely recall older drives had a jumper to set a delayed spin up so
>>>>>> they stayed in a low power (possibly un-spun up) mode when power was
>>>>>> applied and only woke up when a command was received (I think any
>>>>>> command, not a specific "wake up" one).
>>>>>>
>>>>>> Also as mentioned some controllers may also only wake drives one after
>>>>>> the other, likewise mdriad does not care about the underlying
>>>>>> hardware/driver stack, only that it eventually responds, and even then I
>>>>>> believe it will happily wait till the end of time if no response or
>>>>>> error is propagated up the stack; hence the time out in scsi_device
>>>>>> stack not in the mdraid.
>>>>>>
>>>>>>
>>>>>>
>>>>>>> --
>>>>>>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>>>>>>> the body of a message to majordomo@vger.kernel.org
>>>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>>>>
>>>>>> --
>>>>>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>>>>>> the body of a message to majordomo@vger.kernel.org
>>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

