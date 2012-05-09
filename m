From: =?ISO-8859-1?Q?Patrik_Horn=EDk?= <patrik@dsl.sk>
Subject: Re: Interesting feature request for linux raid, waking up drives
Date: Thu, 10 May 2012 00:32:55 +0200
Message-ID: <CAAOsTS=M8get4xrjX3-GFQG96tTFQFX80Ka-1ffFtRUP-X5ufQ@mail.gmail.com>
References: <CAAOsTSkxo2Lxb2FCO6A19CrWVbDm1VsrtsYwVEykcs7X=-1sTQ@mail.gmail.com>
	<4FAACE5F.2010004@nuclearwinter.com>
	<CAAOsTSnd_hLTdRZeSDs0ThfQspAq7DVAnsVMeXgMEosugoesag@mail.gmail.com>
	<20120509213816.GA11037@lazy.lzy>
Reply-To: patrik@dsl.sk
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=0016e6de17e0a8193804bfa215ea
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120509213816.GA11037@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: Larkin Lowrey <llowrey@nuclearwinter.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--0016e6de17e0a8193804bfa215ea
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Piergiorgio,

it's not a problem at all and commercial NAS-es often do that... :)

In terms of maximum capacity, PSU must be able to support starting of
all drives anyway, because it actually does that when you start the
computer.

In terms of total power usage, maximum load is there only for very
short period of time, probably under 10 secs. How many times a day
they wake up depends on usage scenario and you can regulate that by
setting timeout time. In the case of NAS in my office drives wake up
in average fewer than fives times a day, sometimes in the weekend they
are sleeping all the weekend.

I've attached the graph of real power usage of this NAS, it is 7 * 1.5
TB RAID5 and graph is from one minute averages. You can see tri basic
level of power usage, under 50 W when all drivers are in standby,
something around 55 W when 1 drive with OS is up and around 80 W when
all drives are running.

The spikes when waking drives should be on start of 80 W levels, but
as you can see they are almost unnoticeable in one minute averages.
The other spikes around 85 - 90 W are probably load on CPU.

The bigger concern can be if more frequent stopping and starting
drives is not damaging drives. But if you have up to ten starts a day,
it should be OK. SMART value for start/stop count is typically
decreasing 1 for every 1000 start/stop cycles, so you get to 50 after
cca 13 years. And this value is critical at 0.

On other hand the drives are not spinning all the time and this puts
less stress on cheaper desktop drives.

Patrik

On Wed, May 9, 2012 at 11:38 PM, Piergiorgio Sartor
<piergiorgio.sartor@nexgo.de> wrote:
> Hi Patrik,
>
> On Wed, May 09, 2012 at 11:16:33PM +0200, Patrik Horn=EDk wrote:
>> On Wed, May 9, 2012 at 10:06 PM, Larkin Lowrey
>> <llowrey@nuclearwinter.com> wrote:
>> > I second this suggestion but I don't think it's the job of the raid
>> > layer to keep track of whether the member drives are spinning or not.
>>
>> I also dont think it should be directly in the raid level, but it is
>> problem of linux raid and so the solution should be sought here.
>>
>> > I have implemented a similar setup to this but am suffering from the
>> > sequential spin-up problem you described. It would be nice to have a
>> > solution.
>>
>> My script is not perfect but it eliminates sequential spin-up problem
>> perfectly. If you want, use it. The sequential spin-up problem was the
>> reason I wrote it and its main function is to detect woken drives and
>> immediately wake other drives from RAID.
>
> you mentioned "aggressive power saving", but, on the other
> hand, if I get it correctly, you want to spin-up the HDDs
> alltogether.
>
> How do you manage the current peak (power peak) you create
> at spin up? Expecially in comparison with PSU efficiency.
>
> I mean, a running HDD can consume 2W~5W, while at spin-up
> it consumes 20W~30W.
> If you have, let's say, 20 HDDs NAS, at spin-up the PSU
> should provide 20*30W=3D600W, while in normal operation it
> will have to provide only 20*2W=3D40W (extreme cases, of
> course, YMMV).
> In stand-by it will be less, probably 10W for the HDDs.
>
> Now, PSU efficiency usually is tuned at a certain power
> need, typically 80% of max PSU power rating.
> Above and below is less, obviously much less at, let's
> say, 10% of max PSU power.
> Golden or similar consumer PSU, marked 80+, can keep
> high efficiency (80%~90%) up to low power.
> The specification goes down to 20% of max power.
>
> In the above NAS example, the PSU will have to provide,
> at spin-up, more than 600W, I would say 700~800W,
> while in stand-by it will go down to 30~50W (or less).
> Keeping some safety margin, will require 1000W PSU,
> which will be used only 3~5% in stand-by.
> At this level efficiency will be a disaster (usually),
> resulting in an effective power usage (from mains)
> probably above 100W, defeating the wanted power saving.
>
> How do you deal with this issue?
> Have you any real world data about min/max power
> consumption?
> Do know PSUs (consumer class, ATX) capable of
> handling wide power range with high efficiency?
>
> Going back to the spin-up, my idea was exactly the
> opposite, i.e. to activate the HDDs with 4~5 secs.
> delay one from the other, in order to reduce the
> peak power, thus using a lower power rating PSU,
> thus havig high efficiency at low power.
>
> Thanks a lot in advance,
>
> bye,
>
> pg
>
>> > A userspace daemon could probably do the job. I found that relying on
>> > the drive's internal power management for spinning them down was
>> > unreliable (especially for WDC "green" drives) so I implemented a scri=
pt
>> > that watches /sys/block/sdX/stat for activity and spins down the drive
>> > directly (via hdparm) when no activity has been posted for a
>> > configurable period of time. A daemon process that was responsible for
>> > spinning down the constituent drives could also be responsible for
>> > spinning them up by watching /sys/block/mdX/stat for pending transfers=
.
>> > Perhaps you and I could work on such a project.
>>
>> I added support for spinning down drives only as addition after I
>> bought first WD Greens . It is done in wrong way, it relies on some
>> drives in the array working correctly and I guess your way is the
>> correct one. Do you have specification of /sys/block/sdX/stat?
>>
>> Right now the script is checking power status of drives by hdparm. I
>> dont know yet what is in /sys/block/sdX/stat and what is better, but
>> the basic principle behind my script works perfectly at least in my
>> setups - if at least one drive from raid array is awake, wake up all
>> of them.
>>
>> > One thing mdadm could do which would help greatly is to enumerate the
>> > member disk block devices (not just partitions or member raid devices)
>> > for a given array. This information is known since concurrent sync
>> > operations are serialized so no two sync operations occur at the same
>> > time on the same physical devices.
>>
>> Maybe Neil can give us his thoughts what is the best place / form for
>> such functionality.
>>
>> Patrik
>>
>> >
>> > --Larkin
>> >
>> > On 5/9/2012 12:37 PM, Patrik Horn=EDk wrote:
>> >> Hello Neil,
>> >>
>> >> I want to propose some functionality for linux raid subsystem that I
>> >> think will be very practical for many users, automatic waking of
>> >> drives. I am using my own user land script written years ago to do
>> >> that and I dont know if there is some standard solution now. If there
>> >> is some, please point me to it.
>> >>
>> >> I am using couple of big RAID5 arrays in servers working like NASes i=
n
>> >> small office and home, which are in use only small part of the day. I
>> >> am using low power server and aggressive power saving settings on HDD=
s
>> >> to make power consumption substantially lower, for example drives are
>> >> going to sleep after 15 min of inactivity. Normally problem with such
>> >> settings is extremely long waking time when array is accessed.
>> >> Software accessing data often first requests only chunk of data on
>> >> first drive in array and waiting cca 20-30 sec for them, after
>> >> processing them accessing data on another drive and waiting another
>> >> 20-30 sec and so on.
>> >>
>> >> I solved it with my own script in PHP, which monitors drives' status
>> >> periodically. When it detects that drive from RAID array woke up, it
>> >> immediately wakes other drives. So total waking time is equal to
>> >> waking of one drive plus couple of seconds. It works perfectly and
>> >> smoothly for years for me.
>> >>
>> >> I attached the script from one of my servers, it is little cruel and
>> >> using hwparm and smartctl to monitor and manipulating drives. It is
>> >> little customized and specific for its server, for example one drive
>> >> detected by model is not used to wake up other drives and two drives
>> >> are also putting one another into sleep, because I found out the
>> >> standby timeout setting was not working reliable on one drive. But yo=
u
>> >> will get the idea.
>> >>
>> >> I think it could be useful for some users if there is possibility to
>> >> use such feature. Do you think it would be useful? Do you think there
>> >> is some place in linux raid infrastructure where it can be somehow
>> >> implemented? (Possibly as some user land tool using some kernel APIs,
>> >> I dont know.)
>> >>
>> >> Best regards,
>> >>
>> >> Patrik Horn=EDk
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
> --
>
> piergiorgio

--0016e6de17e0a8193804bfa215ea
Content-Type: image/png; name="display_measurement.png"
Content-Disposition: attachment; filename="display_measurement.png"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h20xor8i0

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
AHC0/w+He3nllS9cHAAAAABJRU5ErkJggg==
--0016e6de17e0a8193804bfa215ea--
