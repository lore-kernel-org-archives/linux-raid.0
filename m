From: Mark Knecht <markknecht@gmail.com>
Subject: Re: Array 'freezes' for some time after large writes?
Date: Tue, 30 Mar 2010 13:45:36 -0700
Message-ID: <5bdc1c8b1003301345p46efdaddv5d420c30e75b013f@mail.gmail.com>
References: <dead81ad1003301007h4015ac57x99f36d232bb705b6@mail.gmail.com>
	 <5bdc1c8b1003301018j73f2d928x3e2624bac9c1ee94@mail.gmail.com>
	 <dead81ad1003301047t6be7b3b4r5bf70ad6317f9d1e@mail.gmail.com>
	 <5bdc1c8b1003301105o131b73aaj176c7679be20eada@mail.gmail.com>
	 <dead81ad1003301332k26f01a25t872106a9f93fd2f0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <dead81ad1003301332k26f01a25t872106a9f93fd2f0@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jim Duchek <jim.duchek@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,
   I am running the nvidia binary drivers. I'm not doing anything with
X at this point so I an just unload them I think. I could even remove
the card I suppose.

   I built a machine for my dad a couple of months ago that uses the
same 1TB WD drive that I am using now. I don't remember seeing
anything like this on his machine but I'm going to go check that.

   One other similarity I suspect we have is ext3? There were problems
with ext3 priority inversion in earlier kernel. It's my understanding
that they thought they had that worked out but possibly we're
triggering this somehow? since I've got a lot of disk space I can set
up some other partitions, etc4, reiser4, etc., and try copying files
to trigger it. However it's difficult for me if it requires read/write
as I'm not set up to really use the machine yet. Is that something you
have room to try?

   Also, we haven't discussed what drivers are loaded or kernel
config. Here's my current driver set:

keeper ~ # lsmod
Module                  Size  Used by
ipv6                  207757  30
usbhid                 21529  0
nvidia              10611606  22
snd_hda_codec_realtek   239530  1
snd_hda_intel          17688  0
ehci_hcd               30854  0
snd_hda_codec          45755  2 snd_hda_codec_realtek,snd_hda_intel
snd_pcm                58104  2 snd_hda_intel,snd_hda_codec
snd_timer              15030  1 snd_pcm
snd                    37476  5
snd_hda_codec_realtek,snd_hda_intel,snd_hda_codec,snd_pcm,snd_timer
soundcore                800  1 snd
snd_page_alloc          5809  2 snd_hda_intel,snd_pcm
rtc_cmos                7678  0
rtc_core               11093  1 rtc_cmos
sg                     23029  0
uhci_hcd               18047  0
usbcore               115023  4 usbhid,ehci_hcd,uhci_hcd
agpgart                24341  1 nvidia
processor              23121  0
e1000e                111701  0
firewire_ohci          20022  0
rtc_lib                 1617  1 rtc_core
firewire_core          36109  1 firewire_ohci
thermal                11650  0
keeper ~ #

- Mark

On Tue, Mar 30, 2010 at 1:32 PM, Jim Duchek <jim.duchek@gmail.com> wrot=
e:
> Hrm, I've never seen that kernel message. =C2=A0I don't think any of =
my
> freezes have lasted for up to 120 seconds though (my drives are half
> as big -- might matter?) =C2=A0It looks like we've both got WD drives=
 --
> and we both have nvidia 9500gt's as well. =C2=A0Are you running the n=
vidia
> binary drivers, or noveau? (It seems like it wouldn't matter
> especially as, at least on my system, they don't share an interrupt o=
r
> anything, but I hate to ignore any hardware that we both have the sam=
e
> of). I did move to 2.6.33 for some time, but that didn't change the
> behaviour.
>
> Jim
>
>
> On 30 March 2010 13:05, Mark Knecht <markknecht@gmail.com> wrote:
>> On Tue, Mar 30, 2010 at 10:47 AM, Jim Duchek <jim.duchek@gmail.com> =
wrote:
>> <SNIP>
>>> =C2=A0You're having this happen even if the disk in question is not=
 in an
>>> array? =C2=A0If so perhaps it's an SATA issue and not a RAID one, a=
nd we
>>> should move this discussion accordingly.
>>
>> Yes, in my case the delays are so long - sometimes 2 or 3 minutes -
>> that when I tried to build the system using RAID1 I got this kernel
>> bug in dmesg. It's jsut info - not a real failure - but because it's
>> talking about long delays I gave up on RAID and tried a standard
>> single drive build. Turns out that it has (I think...) nothing to do
>> with RAID at all. you'll not that there are instructions for turning
>> the message off but I've not tried them. I intend to do a parallel
>> RAID1 build on this machine and be able to test both RAID vs non-RAI=
D.
>>
>> - Mark
>>
>> INFO: task kjournald:17466 blocked for more than 120 seconds.
>> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this mes=
sage.
>> kjournald =C2=A0 =C2=A0 D ffff8800280bbe00 =C2=A0 =C2=A0 0 17466 =C2=
=A0 =C2=A0 =C2=A02 0x00000000
>> =C2=A0ffff8801adf9d890 0000000000000046 0000000000000000 00000000000=
00000
>> =C2=A0ffff8801adcbde44 0000000000004000 000000000000fe00 00000000000=
0c878
>> =C2=A00000000800000050 ffff88017a99aa40 ffff8801af90a150 ffff8801adf=
9db08
>> Call Trace:
>> =C2=A0[<ffffffff812dd063>] ? md_make_request+0xb6/0xf1
>> =C2=A0[<ffffffff8109c248>] ? sync_buffer+0x0/0x40
>> =C2=A0[<ffffffff8137a4fc>] ? io_schedule+0x2d/0x3a
>> =C2=A0[<ffffffff8109c283>] ? sync_buffer+0x3b/0x40
>> =C2=A0[<ffffffff8137a879>] ? __wait_on_bit+0x41/0x70
>> =C2=A0[<ffffffff8109c248>] ? sync_buffer+0x0/0x40
>> =C2=A0[<ffffffff8137a913>] ? out_of_line_wait_on_bit+0x6b/0x77
>> =C2=A0[<ffffffff810438b2>] ? wake_bit_function+0x0/0x23
>> =C2=A0[<ffffffff8109c637>] ? sync_dirty_buffer+0x72/0xaa
>> =C2=A0[<ffffffff81131b8e>] ? journal_commit_transaction+0xa74/0xde2
>> =C2=A0[<ffffffff8103abcc>] ? lock_timer_base+0x26/0x4b
>> =C2=A0[<ffffffff81043884>] ? autoremove_wake_function+0x0/0x2e
>> =C2=A0[<ffffffff81134804>] ? kjournald+0xe3/0x206
>> =C2=A0[<ffffffff81043884>] ? autoremove_wake_function+0x0/0x2e
>> =C2=A0[<ffffffff81134721>] ? kjournald+0x0/0x206
>> =C2=A0[<ffffffff81043591>] ? kthread+0x8b/0x93
>> =C2=A0[<ffffffff8100bd3a>] ? child_rip+0xa/0x20
>> =C2=A0[<ffffffff81043506>] ? kthread+0x0/0x93
>> =C2=A0[<ffffffff8100bd30>] ? child_rip+0x0/0x20
>> livecd ~ #
>>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
