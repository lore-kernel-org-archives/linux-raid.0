From: Mark Knecht <markknecht@gmail.com>
Subject: Re: Array 'freezes' for some time after large writes?
Date: Tue, 30 Mar 2010 15:21:20 -0700
Message-ID: <5bdc1c8b1003301521s33c9b227s3a1f7434f78c4bc9@mail.gmail.com>
References: <dead81ad1003301007h4015ac57x99f36d232bb705b6@mail.gmail.com>
	 <5bdc1c8b1003301018j73f2d928x3e2624bac9c1ee94@mail.gmail.com>
	 <dead81ad1003301047t6be7b3b4r5bf70ad6317f9d1e@mail.gmail.com>
	 <5bdc1c8b1003301105o131b73aaj176c7679be20eada@mail.gmail.com>
	 <dead81ad1003301332k26f01a25t872106a9f93fd2f0@mail.gmail.com>
	 <5bdc1c8b1003301345p46efdaddv5d420c30e75b013f@mail.gmail.com>
	 <r2vdead81ad1003301359g73b5a6ady3a9bcc174d556579@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <r2vdead81ad1003301359g73b5a6ady3a9bcc174d556579@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jim Duchek <jim.duchek@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I just finished a long compile on my dad's i5-661/DH55HC machine which
uses this same WD drive and I didn't spot any sign of this happening
there. That's a very recent Intel chipset also and probably more or
less the same SATA controller.

I'm going to turn on the kernel message into dmesg thing for a while
and see if anything pops up.

I can set up some additional partitions on my local drive to test
other file systems but since you're ext3 and I'm ext3 then it's not
that unless the problem moved forward with code over time.

I like the idea of using dd but I want to be careful about that sort
of thing. I've not used dd before, but if I could tell it to write a
gigabyte without messing up existing stuff then that could be helpful.

Back later,
Mark

On Tue, Mar 30, 2010 at 1:59 PM, Jim Duchek <jim.duchek@gmail.com> wrot=
e:
> I'm using ext4 on everything, but it's hard to judge which ext3 bugs
> might affect ext4 as well. =C2=A0I really don't have the ability to
> destructively test the array, I need all the data that's on it and I
> don't have enough spare space elsewhere to back it all up. =C2=A0You =
might
> see if you can trigger it with dd, writing to the drive directly w/no
> filesystem?
>
> Jim
>
>
>
> On 30 March 2010 14:45, Mark Knecht <markknecht@gmail.com> wrote:
>> Hi,
>> =C2=A0 I am running the nvidia binary drivers. I'm not doing anythin=
g with
>> X at this point so I an just unload them I think. I could even remov=
e
>> the card I suppose.
>>
>> =C2=A0 I built a machine for my dad a couple of months ago that uses=
 the
>> same 1TB WD drive that I am using now. I don't remember seeing
>> anything like this on his machine but I'm going to go check that.
>>
>> =C2=A0 One other similarity I suspect we have is ext3? There were pr=
oblems
>> with ext3 priority inversion in earlier kernel. It's my understandin=
g
>> that they thought they had that worked out but possibly we're
>> triggering this somehow? since I've got a lot of disk space I can se=
t
>> up some other partitions, etc4, reiser4, etc., and try copying files
>> to trigger it. However it's difficult for me if it requires read/wri=
te
>> as I'm not set up to really use the machine yet. Is that something y=
ou
>> have room to try?
>>
>> =C2=A0 Also, we haven't discussed what drivers are loaded or kernel
>> config. Here's my current driver set:
>>
>> keeper ~ # lsmod
>> Module =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
Size =C2=A0Used by
>> ipv6 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A02=
07757 =C2=A030
>> usbhid =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 21529=
 =C2=A00
>> nvidia =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A010611606 =C2=A0=
22
>> snd_hda_codec_realtek =C2=A0 239530 =C2=A01
>> snd_hda_intel =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A017688 =C2=A00
>> ehci_hcd =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 30854 =C2=A0=
0
>> snd_hda_codec =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A045755 =C2=A02 snd_hd=
a_codec_realtek,snd_hda_intel
>> snd_pcm =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A058104=
 =C2=A02 snd_hda_intel,snd_hda_codec
>> snd_timer =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A015030 =C2=A0=
1 snd_pcm
>> snd =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A037476 =C2=A05
>> snd_hda_codec_realtek,snd_hda_intel,snd_hda_codec,snd_pcm,snd_timer
>> soundcore =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0800=
 =C2=A01 snd
>> snd_page_alloc =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A05809 =C2=A02 snd_hd=
a_intel,snd_pcm
>> rtc_cmos =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A07678=
 =C2=A00
>> rtc_core =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 11093 =C2=A0=
1 rtc_cmos
>> sg =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 23029 =C2=A00
>> uhci_hcd =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 18047 =C2=A0=
0
>> usbcore =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 115023 =C2=A0=
4 usbhid,ehci_hcd,uhci_hcd
>> agpgart =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A024341=
 =C2=A01 nvidia
>> processor =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A023121 =C2=A0=
0
>> e1000e =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0111701=
 =C2=A00
>> firewire_ohci =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A020022 =C2=A00
>> rtc_lib =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 1617=
 =C2=A01 rtc_core
>> firewire_core =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A036109 =C2=A01 firewi=
re_ohci
>> thermal =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A011650=
 =C2=A00
>> keeper ~ #
>>
>> - Mark
>>
>> On Tue, Mar 30, 2010 at 1:32 PM, Jim Duchek <jim.duchek@gmail.com> w=
rote:
>>> Hrm, I've never seen that kernel message. =C2=A0I don't think any o=
f my
>>> freezes have lasted for up to 120 seconds though (my drives are hal=
f
>>> as big -- might matter?) =C2=A0It looks like we've both got WD driv=
es --
>>> and we both have nvidia 9500gt's as well. =C2=A0Are you running the=
 nvidia
>>> binary drivers, or noveau? (It seems like it wouldn't matter
>>> especially as, at least on my system, they don't share an interrupt=
 or
>>> anything, but I hate to ignore any hardware that we both have the s=
ame
>>> of). I did move to 2.6.33 for some time, but that didn't change the
>>> behaviour.
>>>
>>> Jim
>>>
>>>
>>> On 30 March 2010 13:05, Mark Knecht <markknecht@gmail.com> wrote:
>>>> On Tue, Mar 30, 2010 at 10:47 AM, Jim Duchek <jim.duchek@gmail.com=
> wrote:
>>>> <SNIP>
>>>>> =C2=A0You're having this happen even if the disk in question is n=
ot in an
>>>>> array? =C2=A0If so perhaps it's an SATA issue and not a RAID one,=
 and we
>>>>> should move this discussion accordingly.
>>>>
>>>> Yes, in my case the delays are so long - sometimes 2 or 3 minutes =
-
>>>> that when I tried to build the system using RAID1 I got this kerne=
l
>>>> bug in dmesg. It's jsut info - not a real failure - but because it=
's
>>>> talking about long delays I gave up on RAID and tried a standard
>>>> single drive build. Turns out that it has (I think...) nothing to =
do
>>>> with RAID at all. you'll not that there are instructions for turni=
ng
>>>> the message off but I've not tried them. I intend to do a parallel
>>>> RAID1 build on this machine and be able to test both RAID vs non-R=
AID.
>>>>
>>>> - Mark
>>>>
>>>> INFO: task kjournald:17466 blocked for more than 120 seconds.
>>>> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this m=
essage.
>>>> kjournald =C2=A0 =C2=A0 D ffff8800280bbe00 =C2=A0 =C2=A0 0 17466 =C2=
=A0 =C2=A0 =C2=A02 0x00000000
>>>> =C2=A0ffff8801adf9d890 0000000000000046 0000000000000000 000000000=
0000000
>>>> =C2=A0ffff8801adcbde44 0000000000004000 000000000000fe00 000000000=
000c878
>>>> =C2=A00000000800000050 ffff88017a99aa40 ffff8801af90a150 ffff8801a=
df9db08
>>>> Call Trace:
>>>> =C2=A0[<ffffffff812dd063>] ? md_make_request+0xb6/0xf1
>>>> =C2=A0[<ffffffff8109c248>] ? sync_buffer+0x0/0x40
>>>> =C2=A0[<ffffffff8137a4fc>] ? io_schedule+0x2d/0x3a
>>>> =C2=A0[<ffffffff8109c283>] ? sync_buffer+0x3b/0x40
>>>> =C2=A0[<ffffffff8137a879>] ? __wait_on_bit+0x41/0x70
>>>> =C2=A0[<ffffffff8109c248>] ? sync_buffer+0x0/0x40
>>>> =C2=A0[<ffffffff8137a913>] ? out_of_line_wait_on_bit+0x6b/0x77
>>>> =C2=A0[<ffffffff810438b2>] ? wake_bit_function+0x0/0x23
>>>> =C2=A0[<ffffffff8109c637>] ? sync_dirty_buffer+0x72/0xaa
>>>> =C2=A0[<ffffffff81131b8e>] ? journal_commit_transaction+0xa74/0xde=
2
>>>> =C2=A0[<ffffffff8103abcc>] ? lock_timer_base+0x26/0x4b
>>>> =C2=A0[<ffffffff81043884>] ? autoremove_wake_function+0x0/0x2e
>>>> =C2=A0[<ffffffff81134804>] ? kjournald+0xe3/0x206
>>>> =C2=A0[<ffffffff81043884>] ? autoremove_wake_function+0x0/0x2e
>>>> =C2=A0[<ffffffff81134721>] ? kjournald+0x0/0x206
>>>> =C2=A0[<ffffffff81043591>] ? kthread+0x8b/0x93
>>>> =C2=A0[<ffffffff8100bd3a>] ? child_rip+0xa/0x20
>>>> =C2=A0[<ffffffff81043506>] ? kthread+0x0/0x93
>>>> =C2=A0[<ffffffff8100bd30>] ? child_rip+0x0/0x20
>>>> livecd ~ #
>>>>
>>>
>>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
