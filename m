From: Jim Duchek <jim.duchek@gmail.com>
Subject: Re: Array 'freezes' for some time after large writes?
Date: Tue, 30 Mar 2010 14:59:20 -0600
Message-ID: <r2vdead81ad1003301359g73b5a6ady3a9bcc174d556579@mail.gmail.com>
References: <dead81ad1003301007h4015ac57x99f36d232bb705b6@mail.gmail.com>
	 <5bdc1c8b1003301018j73f2d928x3e2624bac9c1ee94@mail.gmail.com>
	 <dead81ad1003301047t6be7b3b4r5bf70ad6317f9d1e@mail.gmail.com>
	 <5bdc1c8b1003301105o131b73aaj176c7679be20eada@mail.gmail.com>
	 <dead81ad1003301332k26f01a25t872106a9f93fd2f0@mail.gmail.com>
	 <5bdc1c8b1003301345p46efdaddv5d420c30e75b013f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5bdc1c8b1003301345p46efdaddv5d420c30e75b013f@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Knecht <markknecht@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm using ext4 on everything, but it's hard to judge which ext3 bugs
might affect ext4 as well.  I really don't have the ability to
destructively test the array, I need all the data that's on it and I
don't have enough spare space elsewhere to back it all up.  You might
see if you can trigger it with dd, writing to the drive directly w/no
filesystem?

Jim



On 30 March 2010 14:45, Mark Knecht <markknecht@gmail.com> wrote:
> Hi,
> =A0 I am running the nvidia binary drivers. I'm not doing anything wi=
th
> X at this point so I an just unload them I think. I could even remove
> the card I suppose.
>
> =A0 I built a machine for my dad a couple of months ago that uses the
> same 1TB WD drive that I am using now. I don't remember seeing
> anything like this on his machine but I'm going to go check that.
>
> =A0 One other similarity I suspect we have is ext3? There were proble=
ms
> with ext3 priority inversion in earlier kernel. It's my understanding
> that they thought they had that worked out but possibly we're
> triggering this somehow? since I've got a lot of disk space I can set
> up some other partitions, etc4, reiser4, etc., and try copying files
> to trigger it. However it's difficult for me if it requires read/writ=
e
> as I'm not set up to really use the machine yet. Is that something yo=
u
> have room to try?
>
> =A0 Also, we haven't discussed what drivers are loaded or kernel
> config. Here's my current driver set:
>
> keeper ~ # lsmod
> Module =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Size =A0Used by
> ipv6 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0207757 =A030
> usbhid =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 21529 =A00
> nvidia =A0 =A0 =A0 =A0 =A0 =A0 =A010611606 =A022
> snd_hda_codec_realtek =A0 239530 =A01
> snd_hda_intel =A0 =A0 =A0 =A0 =A017688 =A00
> ehci_hcd =A0 =A0 =A0 =A0 =A0 =A0 =A0 30854 =A00
> snd_hda_codec =A0 =A0 =A0 =A0 =A045755 =A02 snd_hda_codec_realtek,snd=
_hda_intel
> snd_pcm =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A058104 =A02 snd_hda_intel,snd_h=
da_codec
> snd_timer =A0 =A0 =A0 =A0 =A0 =A0 =A015030 =A01 snd_pcm
> snd =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A037476 =A05
> snd_hda_codec_realtek,snd_hda_intel,snd_hda_codec,snd_pcm,snd_timer
> soundcore =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0800 =A01 snd
> snd_page_alloc =A0 =A0 =A0 =A0 =A05809 =A02 snd_hda_intel,snd_pcm
> rtc_cmos =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A07678 =A00
> rtc_core =A0 =A0 =A0 =A0 =A0 =A0 =A0 11093 =A01 rtc_cmos
> sg =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 23029 =A00
> uhci_hcd =A0 =A0 =A0 =A0 =A0 =A0 =A0 18047 =A00
> usbcore =A0 =A0 =A0 =A0 =A0 =A0 =A0 115023 =A04 usbhid,ehci_hcd,uhci_=
hcd
> agpgart =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A024341 =A01 nvidia
> processor =A0 =A0 =A0 =A0 =A0 =A0 =A023121 =A00
> e1000e =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0111701 =A00
> firewire_ohci =A0 =A0 =A0 =A0 =A020022 =A00
> rtc_lib =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 1617 =A01 rtc_core
> firewire_core =A0 =A0 =A0 =A0 =A036109 =A01 firewire_ohci
> thermal =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A011650 =A00
> keeper ~ #
>
> - Mark
>
> On Tue, Mar 30, 2010 at 1:32 PM, Jim Duchek <jim.duchek@gmail.com> wr=
ote:
>> Hrm, I've never seen that kernel message. =A0I don't think any of my
>> freezes have lasted for up to 120 seconds though (my drives are half
>> as big -- might matter?) =A0It looks like we've both got WD drives -=
-
>> and we both have nvidia 9500gt's as well. =A0Are you running the nvi=
dia
>> binary drivers, or noveau? (It seems like it wouldn't matter
>> especially as, at least on my system, they don't share an interrupt =
or
>> anything, but I hate to ignore any hardware that we both have the sa=
me
>> of). I did move to 2.6.33 for some time, but that didn't change the
>> behaviour.
>>
>> Jim
>>
>>
>> On 30 March 2010 13:05, Mark Knecht <markknecht@gmail.com> wrote:
>>> On Tue, Mar 30, 2010 at 10:47 AM, Jim Duchek <jim.duchek@gmail.com>=
 wrote:
>>> <SNIP>
>>>> =A0You're having this happen even if the disk in question is not i=
n an
>>>> array? =A0If so perhaps it's an SATA issue and not a RAID one, and=
 we
>>>> should move this discussion accordingly.
>>>
>>> Yes, in my case the delays are so long - sometimes 2 or 3 minutes -
>>> that when I tried to build the system using RAID1 I got this kernel
>>> bug in dmesg. It's jsut info - not a real failure - but because it'=
s
>>> talking about long delays I gave up on RAID and tried a standard
>>> single drive build. Turns out that it has (I think...) nothing to d=
o
>>> with RAID at all. you'll not that there are instructions for turnin=
g
>>> the message off but I've not tried them. I intend to do a parallel
>>> RAID1 build on this machine and be able to test both RAID vs non-RA=
ID.
>>>
>>> - Mark
>>>
>>> INFO: task kjournald:17466 blocked for more than 120 seconds.
>>> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this me=
ssage.
>>> kjournald =A0 =A0 D ffff8800280bbe00 =A0 =A0 0 17466 =A0 =A0 =A02 0=
x00000000
>>> =A0ffff8801adf9d890 0000000000000046 0000000000000000 0000000000000=
000
>>> =A0ffff8801adcbde44 0000000000004000 000000000000fe00 000000000000c=
878
>>> =A00000000800000050 ffff88017a99aa40 ffff8801af90a150 ffff8801adf9d=
b08
>>> Call Trace:
>>> =A0[<ffffffff812dd063>] ? md_make_request+0xb6/0xf1
>>> =A0[<ffffffff8109c248>] ? sync_buffer+0x0/0x40
>>> =A0[<ffffffff8137a4fc>] ? io_schedule+0x2d/0x3a
>>> =A0[<ffffffff8109c283>] ? sync_buffer+0x3b/0x40
>>> =A0[<ffffffff8137a879>] ? __wait_on_bit+0x41/0x70
>>> =A0[<ffffffff8109c248>] ? sync_buffer+0x0/0x40
>>> =A0[<ffffffff8137a913>] ? out_of_line_wait_on_bit+0x6b/0x77
>>> =A0[<ffffffff810438b2>] ? wake_bit_function+0x0/0x23
>>> =A0[<ffffffff8109c637>] ? sync_dirty_buffer+0x72/0xaa
>>> =A0[<ffffffff81131b8e>] ? journal_commit_transaction+0xa74/0xde2
>>> =A0[<ffffffff8103abcc>] ? lock_timer_base+0x26/0x4b
>>> =A0[<ffffffff81043884>] ? autoremove_wake_function+0x0/0x2e
>>> =A0[<ffffffff81134804>] ? kjournald+0xe3/0x206
>>> =A0[<ffffffff81043884>] ? autoremove_wake_function+0x0/0x2e
>>> =A0[<ffffffff81134721>] ? kjournald+0x0/0x206
>>> =A0[<ffffffff81043591>] ? kthread+0x8b/0x93
>>> =A0[<ffffffff8100bd3a>] ? child_rip+0xa/0x20
>>> =A0[<ffffffff81043506>] ? kthread+0x0/0x93
>>> =A0[<ffffffff8100bd30>] ? child_rip+0x0/0x20
>>> livecd ~ #
>>>
>>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
