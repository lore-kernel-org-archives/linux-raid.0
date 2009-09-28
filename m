From: Aggelos Kyritsis <filodoksos@gmail.com>
Subject: Re: mdadm 3.0.2 won't read mdadm.conf file
Date: Mon, 28 Sep 2009 17:14:15 +0300
Message-ID: <1e36c70e0909280714r2d81238dq198699a863be359e@mail.gmail.com>
References: <1e36c70e0909280013o616d74draf419a548183cc7f@mail.gmail.com>
	 <73e903670909280218t44e1ddb0u8117ea4611643883@mail.gmail.com>
	 <1e36c70e0909280536s513fa655n9533efe220dceddf@mail.gmail.com>
	 <73e903670909280553t3de93c68t5673ba234ac72bef@mail.gmail.com>
	 <1e36c70e0909280652j42ee420mabaa4141363a976a@mail.gmail.com>
	 <73e903670909280704r1189e86aoc08cbc260e6d8ab8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=000e0cd1e218a8b7870474a3e902
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <73e903670909280704r1189e86aoc08cbc260e6d8ab8@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: =?ISO-8859-1?Q?Kristleifur_Da=F0ason?= <kristleifur@gmail.com>
List-Id: linux-raid.ids

--000e0cd1e218a8b7870474a3e902
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Even if they are compiler flags, they are referring to the exact same
file (mdadm.conf) that my mdadm 3.0.2 completely ignores. It might be
a complete coincidence, but it does look suspicious, doesn't it?

I resend the attachment for the list to see

On Mon, Sep 28, 2009 at 5:04 PM, Kristleifur Da=F0ason
<kristleifur@gmail.com> wrote:
> Hi,
>
> it looks like we have actually started talking off-list :) (I think so at
> least ...)
>
> Btw, Those "-Werror" things are compiler flags (it means "warn on error")=
 --
> you're getting neither errors nor warnings there -- compilation is going
> fine
>
> You'd better take this back to the list, there's probably smarter people
> than me there ... and maybe also try the Ubuntu forums
>
> -- Kristleifur
>
> On Mon, Sep 28, 2009 at 1:52 PM, Aggelos Kyritsis <filodoksos@gmail.com>
> wrote:
>>
>> I think I found the cause of the whole situation.
>>
>> During the compilation of mdadm 3.0.2 several error messages appear
>> considering the mdadm.conf file.
>>
>> I attach a file with the compiler's output. I have a feeling that if
>> we can pinpoint the cause of those errors, the problem will be solved.
>>
>> Maybe my system is missing some compilation libraries? I have already
>> installed the build-essential and gcc packages.
>>
>>
>>
>> On Mon, Sep 28, 2009 at 3:53 PM, Kristleifur Da=F0ason
>> <kristleifur@gmail.com> wrote:
>> > Hi again :)
>> >
>> > I forgot that I have the old mdadm 2.6.9 on this machine, so it's
>> > probably
>> > not 100% the same; I did have 3.0.x but not currently, sorry about tha=
t.
>> >
>> > The /etc/mdadm/mdadm.conf is probably copied automatically into the
>> > initramdisk when you have the Ubuntu package for mdadm, but I'm not su=
re
>> > what happens if you have a custom-built mdadm.
>> >
>> > I would guess that there is probably some config file for
>> > update-initramfs
>> > that tells it to take this and that file.
>> >
>> > Wish I could help you better.
>> >
>> > Have you tried expanding the updated initramfs and checking what the
>> > mdadm.conf file in looks like?
>> >
>> > Good luck and by all means ask me any further questions you have!
>> >
>> > -- Kristleifur
>> >
>> > On Mon, Sep 28, 2009 at 12:36 PM, Aggelos Kyritsis
>> > <filodoksos@gmail.com>
>> > wrote:
>> >>
>> >> Thanks for the quick responce :-)
>> >>
>> >> I tried the "sudo update-initramfs -u -k all" command and it got the
>> >> following two messages
>> >>
>> >> update-initramfs: Generating /boot/initrd.img-2.6.28-15-generic
>> >> update-initramfs: Generating /boot/initrd.img-2.6.28-11-generic
>> >>
>> >> But still no luck with the mdadm
>> >>
>> >> I have found a guide on creating a custom initial ramdisk
>> >> (http://www.ibm.com/developerworks/linux/library/l-initrd.html) but i=
t
>> >> still isn't clear to me how to place the mdadm.conf in it (and make
>> >> mdadm read the file).
>> >>
>> >> Could you please elaborate?
>> >>
>> >>
>> >>
>> >>
>> >> On Mon, Sep 28, 2009 at 12:18 PM, Kristleifur Da=F0ason
>> >> <kristleifur@gmail.com> wrote:
>> >> > On Mon, Sep 28, 2009 at 7:13 AM, Aggelos Kyritsis
>> >> > <filodoksos@gmail.com>
>> >> > wrote:
>> >> >>
>> >> >> Dear sir/madam,
>> >> >>
>> >> >> I am running ubuntu 9.04. Until recently I used the mdadm version
>> >> >> that
>> >> >> exists in the ubuntu repositories, with perfect success. However,
>> >> >> since that version is fairly old (2.6, I think), I decided to
>> >> >> install
>> >> >> the latest version 3.0.2.
>> >> >>
>> >> >> On a freshly formatted system with no mdadm I downloaded
>> >> >> http://www.kernel.org/pub/linux/utils/raid/mdadm/mdadm-3.0.2.tar.g=
z,
>> >> >> unzipped it and run the "sudo make" and "sudo make install"
>> >> >> commands.
>> >> >> According to mdadm --version, I succesfuly installed version 3.0.2
>> >> >> of
>> >> >> the program. I was also successful on creating and mounting a fres=
h
>> >> >> raid 5 array.
>> >> >>
>> >> >> However, the installation didn't create either the
>> >> >> /etc/mdadm/mdadm.conf or the /etc/mdadm.conf file, where I need to
>> >> >> specify the array details so that it is assembled during boot time=
.
>> >> >>
>> >> >> I manually created the mdadm.conf file in both locations and added
>> >> >> the
>> >> >> "DEVICE partitions" line and a line with the result from mdadm
>> >> >> --examine --scan
>> >> >>
>> >> >> Even though this was enough on the old version of mdadm for auto
>> >> >> assemble during the boot sequence (so that /etc/fstab could mount
>> >> >> /dev/md0), on version 3.0.2 it made no diferrence at all, as if th=
e
>> >> >> mdadm I compiled and installed manually wouldn't read the
>> >> >> mdadm.config
>> >> >> file, neither on /etc/mdadm/mdadm.conf or on /etc/mdadm.conf
>> >> >>
>> >> >> Is there anything I could do to address this problem? Any way to
>> >> >> permanently point the mdadm to its mdadm.conf file? is there an
>> >> >> mdadm.conf file created on some other location on the disk, where =
I
>> >> >> can add the array information?
>> >> >>
>> >> >> Thanks in advance
>> >> >>
>> >> >> Kind regards
>> >> >>
>> >> >> Angelos Kyritsis.
>> >> >
>> >> > Hi,
>> >> >
>> >> > I've tried almost exactly the same setup. I suspect that you may
>> >> > simply need to update the initramfs, specifically to place the
>> >> > mdadm.conf in the init-ramdisk. Try "sudo update-initramfs -u -k
>> >> > all".
>> >> > "-u" means update the initrd, "-k all" means to update for all
>> >> > kernels.
>> >> >
>> >> > -- Kristleifur
>> >> >
>> >
>> >
>
>

--000e0cd1e218a8b7870474a3e902
Content-Type: application/octet-stream; name=compiler-message
Content-Disposition: attachment; filename=compiler-message
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g05astky0

Z2NjIC1XYWxsIC1XZXJyb3IgLVdzdHJpY3QtcHJvdG90eXBlcyAtZ2dkYiAtRFNlbmRtYWlsPVwi
Ii91c3Ivc2Jpbi9zZW5kbWFpbCAtdCJcIiAtRENPTkZGSUxFPVwiL2V0Yy9tZGFkbS5jb25mXCIg
LURDT05GRklMRTI9XCIvZXRjL21kYWRtL21kYWRtLmNvbmZcIiAgIC1jIC1vIG1kYWRtLm8gbWRh
ZG0uYwpnY2MgLVdhbGwgLVdlcnJvciAtV3N0cmljdC1wcm90b3R5cGVzIC1nZ2RiIC1EU2VuZG1h
aWw9XCIiL3Vzci9zYmluL3NlbmRtYWlsIC10IlwiIC1EQ09ORkZJTEU9XCIvZXRjL21kYWRtLmNv
bmZcIiAtRENPTkZGSUxFMj1cIi9ldGMvbWRhZG0vbWRhZG0uY29uZlwiICAgLWMgLW8gY29uZmln
Lm8gY29uZmlnLmMKZ2NjIC1XYWxsIC1XZXJyb3IgLVdzdHJpY3QtcHJvdG90eXBlcyAtZ2dkYiAt
RFNlbmRtYWlsPVwiIi91c3Ivc2Jpbi9zZW5kbWFpbCAtdCJcIiAtRENPTkZGSUxFPVwiL2V0Yy9t
ZGFkbS5jb25mXCIgLURDT05GRklMRTI9XCIvZXRjL21kYWRtL21kYWRtLmNvbmZcIiAgIC1jIC1v
IG1kc3RhdC5vIG1kc3RhdC5jCmdjYyAtV2FsbCAtV2Vycm9yIC1Xc3RyaWN0LXByb3RvdHlwZXMg
LWdnZGIgLURTZW5kbWFpbD1cIiIvdXNyL3NiaW4vc2VuZG1haWwgLXQiXCIgLURDT05GRklMRT1c
Ii9ldGMvbWRhZG0uY29uZlwiIC1EQ09ORkZJTEUyPVwiL2V0Yy9tZGFkbS9tZGFkbS5jb25mXCIg
ICAtYyAtbyBSZWFkTWUubyBSZWFkTWUuYwpnY2MgLVdhbGwgLVdlcnJvciAtV3N0cmljdC1wcm90
b3R5cGVzIC1nZ2RiIC1EU2VuZG1haWw9XCIiL3Vzci9zYmluL3NlbmRtYWlsIC10IlwiIC1EQ09O
RkZJTEU9XCIvZXRjL21kYWRtLmNvbmZcIiAtRENPTkZGSUxFMj1cIi9ldGMvbWRhZG0vbWRhZG0u
Y29uZlwiICAgLWMgLW8gdXRpbC5vIHV0aWwuYwpnY2MgLVdhbGwgLVdlcnJvciAtV3N0cmljdC1w
cm90b3R5cGVzIC1nZ2RiIC1EU2VuZG1haWw9XCIiL3Vzci9zYmluL3NlbmRtYWlsIC10IlwiIC1E
Q09ORkZJTEU9XCIvZXRjL21kYWRtLmNvbmZcIiAtRENPTkZGSUxFMj1cIi9ldGMvbWRhZG0vbWRh
ZG0uY29uZlwiICAgLWMgLW8gTWFuYWdlLm8gTWFuYWdlLmMKZ2NjIC1XYWxsIC1XZXJyb3IgLVdz
dHJpY3QtcHJvdG90eXBlcyAtZ2dkYiAtRFNlbmRtYWlsPVwiIi91c3Ivc2Jpbi9zZW5kbWFpbCAt
dCJcIiAtRENPTkZGSUxFPVwiL2V0Yy9tZGFkbS5jb25mXCIgLURDT05GRklMRTI9XCIvZXRjL21k
YWRtL21kYWRtLmNvbmZcIiAgIC1jIC1vIEFzc2VtYmxlLm8gQXNzZW1ibGUuYwpnY2MgLVdhbGwg
LVdlcnJvciAtV3N0cmljdC1wcm90b3R5cGVzIC1nZ2RiIC1EU2VuZG1haWw9XCIiL3Vzci9zYmlu
L3NlbmRtYWlsIC10IlwiIC1EQ09ORkZJTEU9XCIvZXRjL21kYWRtLmNvbmZcIiAtRENPTkZGSUxF
Mj1cIi9ldGMvbWRhZG0vbWRhZG0uY29uZlwiICAgLWMgLW8gQnVpbGQubyBCdWlsZC5jCmdjYyAt
V2FsbCAtV2Vycm9yIC1Xc3RyaWN0LXByb3RvdHlwZXMgLWdnZGIgLURTZW5kbWFpbD1cIiIvdXNy
L3NiaW4vc2VuZG1haWwgLXQiXCIgLURDT05GRklMRT1cIi9ldGMvbWRhZG0uY29uZlwiIC1EQ09O
RkZJTEUyPVwiL2V0Yy9tZGFkbS9tZGFkbS5jb25mXCIgICAtYyAtbyBDcmVhdGUubyBDcmVhdGUu
YwpnY2MgLVdhbGwgLVdlcnJvciAtV3N0cmljdC1wcm90b3R5cGVzIC1nZ2RiIC1EU2VuZG1haWw9
XCIiL3Vzci9zYmluL3NlbmRtYWlsIC10IlwiIC1EQ09ORkZJTEU9XCIvZXRjL21kYWRtLmNvbmZc
IiAtRENPTkZGSUxFMj1cIi9ldGMvbWRhZG0vbWRhZG0uY29uZlwiICAgLWMgLW8gRGV0YWlsLm8g
RGV0YWlsLmMKZ2NjIC1XYWxsIC1XZXJyb3IgLVdzdHJpY3QtcHJvdG90eXBlcyAtZ2dkYiAtRFNl
bmRtYWlsPVwiIi91c3Ivc2Jpbi9zZW5kbWFpbCAtdCJcIiAtRENPTkZGSUxFPVwiL2V0Yy9tZGFk
bS5jb25mXCIgLURDT05GRklMRTI9XCIvZXRjL21kYWRtL21kYWRtLmNvbmZcIiAgIC1jIC1vIEV4
YW1pbmUubyBFeGFtaW5lLmMKZ2NjIC1XYWxsIC1XZXJyb3IgLVdzdHJpY3QtcHJvdG90eXBlcyAt
Z2dkYiAtRFNlbmRtYWlsPVwiIi91c3Ivc2Jpbi9zZW5kbWFpbCAtdCJcIiAtRENPTkZGSUxFPVwi
L2V0Yy9tZGFkbS5jb25mXCIgLURDT05GRklMRTI9XCIvZXRjL21kYWRtL21kYWRtLmNvbmZcIiAg
IC1jIC1vIEdyb3cubyBHcm93LmMKZ2NjIC1XYWxsIC1XZXJyb3IgLVdzdHJpY3QtcHJvdG90eXBl
cyAtZ2dkYiAtRFNlbmRtYWlsPVwiIi91c3Ivc2Jpbi9zZW5kbWFpbCAtdCJcIiAtRENPTkZGSUxF
PVwiL2V0Yy9tZGFkbS5jb25mXCIgLURDT05GRklMRTI9XCIvZXRjL21kYWRtL21kYWRtLmNvbmZc
IiAgIC1jIC1vIE1vbml0b3IubyBNb25pdG9yLmMKZ2NjIC1XYWxsIC1XZXJyb3IgLVdzdHJpY3Qt
cHJvdG90eXBlcyAtZ2dkYiAtRFNlbmRtYWlsPVwiIi91c3Ivc2Jpbi9zZW5kbWFpbCAtdCJcIiAt
RENPTkZGSUxFPVwiL2V0Yy9tZGFkbS5jb25mXCIgLURDT05GRklMRTI9XCIvZXRjL21kYWRtL21k
YWRtLmNvbmZcIiAgIC1jIC1vIGRsaW5rLm8gZGxpbmsuYwpnY2MgLVdhbGwgLVdlcnJvciAtV3N0
cmljdC1wcm90b3R5cGVzIC1nZ2RiIC1EU2VuZG1haWw9XCIiL3Vzci9zYmluL3NlbmRtYWlsIC10
IlwiIC1EQ09ORkZJTEU9XCIvZXRjL21kYWRtLmNvbmZcIiAtRENPTkZGSUxFMj1cIi9ldGMvbWRh
ZG0vbWRhZG0uY29uZlwiICAgLWMgLW8gS2lsbC5vIEtpbGwuYwpnY2MgLVdhbGwgLVdlcnJvciAt
V3N0cmljdC1wcm90b3R5cGVzIC1nZ2RiIC1EU2VuZG1haWw9XCIiL3Vzci9zYmluL3NlbmRtYWls
IC10IlwiIC1EQ09ORkZJTEU9XCIvZXRjL21kYWRtLmNvbmZcIiAtRENPTkZGSUxFMj1cIi9ldGMv
bWRhZG0vbWRhZG0uY29uZlwiICAgLWMgLW8gUXVlcnkubyBRdWVyeS5jCmdjYyAtV2FsbCAtV2Vy
cm9yIC1Xc3RyaWN0LXByb3RvdHlwZXMgLWdnZGIgLURTZW5kbWFpbD1cIiIvdXNyL3NiaW4vc2Vu
ZG1haWwgLXQiXCIgLURDT05GRklMRT1cIi9ldGMvbWRhZG0uY29uZlwiIC1EQ09ORkZJTEUyPVwi
L2V0Yy9tZGFkbS9tZGFkbS5jb25mXCIgICAtYyAtbyBJbmNyZW1lbnRhbC5vIEluY3JlbWVudGFs
LmMKZ2NjIC1XYWxsIC1XZXJyb3IgLVdzdHJpY3QtcHJvdG90eXBlcyAtZ2dkYiAtRFNlbmRtYWls
PVwiIi91c3Ivc2Jpbi9zZW5kbWFpbCAtdCJcIiAtRENPTkZGSUxFPVwiL2V0Yy9tZGFkbS5jb25m
XCIgLURDT05GRklMRTI9XCIvZXRjL21kYWRtL21kYWRtLmNvbmZcIiAgIC1jIC1vIG1kb3Blbi5v
IG1kb3Blbi5jCmdjYyAtV2FsbCAtV2Vycm9yIC1Xc3RyaWN0LXByb3RvdHlwZXMgLWdnZGIgLURT
ZW5kbWFpbD1cIiIvdXNyL3NiaW4vc2VuZG1haWwgLXQiXCIgLURDT05GRklMRT1cIi9ldGMvbWRh
ZG0uY29uZlwiIC1EQ09ORkZJTEUyPVwiL2V0Yy9tZGFkbS9tZGFkbS5jb25mXCIgICAtYyAtbyBz
dXBlcjAubyBzdXBlcjAuYwpnY2MgLVdhbGwgLVdlcnJvciAtV3N0cmljdC1wcm90b3R5cGVzIC1n
Z2RiIC1EU2VuZG1haWw9XCIiL3Vzci9zYmluL3NlbmRtYWlsIC10IlwiIC1EQ09ORkZJTEU9XCIv
ZXRjL21kYWRtLmNvbmZcIiAtRENPTkZGSUxFMj1cIi9ldGMvbWRhZG0vbWRhZG0uY29uZlwiICAg
LWMgLW8gc3VwZXIxLm8gc3VwZXIxLmMKZ2NjIC1XYWxsIC1XZXJyb3IgLVdzdHJpY3QtcHJvdG90
eXBlcyAtZ2dkYiAtRFNlbmRtYWlsPVwiIi91c3Ivc2Jpbi9zZW5kbWFpbCAtdCJcIiAtRENPTkZG
SUxFPVwiL2V0Yy9tZGFkbS5jb25mXCIgLURDT05GRklMRTI9XCIvZXRjL21kYWRtL21kYWRtLmNv
bmZcIiAgIC1jIC1vIHN1cGVyLWRkZi5vIHN1cGVyLWRkZi5jCmdjYyAtV2FsbCAtV2Vycm9yIC1X
c3RyaWN0LXByb3RvdHlwZXMgLWdnZGIgLURTZW5kbWFpbD1cIiIvdXNyL3NiaW4vc2VuZG1haWwg
LXQiXCIgLURDT05GRklMRT1cIi9ldGMvbWRhZG0uY29uZlwiIC1EQ09ORkZJTEUyPVwiL2V0Yy9t
ZGFkbS9tZGFkbS5jb25mXCIgICAtYyAtbyBzdXBlci1pbnRlbC5vIHN1cGVyLWludGVsLmMKZ2Nj
IC1XYWxsIC1XZXJyb3IgLVdzdHJpY3QtcHJvdG90eXBlcyAtZ2dkYiAtRFNlbmRtYWlsPVwiIi91
c3Ivc2Jpbi9zZW5kbWFpbCAtdCJcIiAtRENPTkZGSUxFPVwiL2V0Yy9tZGFkbS5jb25mXCIgLURD
T05GRklMRTI9XCIvZXRjL21kYWRtL21kYWRtLmNvbmZcIiAgIC1jIC1vIGJpdG1hcC5vIGJpdG1h
cC5jCmdjYyAtV2FsbCAtV2Vycm9yIC1Xc3RyaWN0LXByb3RvdHlwZXMgLWdnZGIgLURTZW5kbWFp
bD1cIiIvdXNyL3NiaW4vc2VuZG1haWwgLXQiXCIgLURDT05GRklMRT1cIi9ldGMvbWRhZG0uY29u
ZlwiIC1EQ09ORkZJTEUyPVwiL2V0Yy9tZGFkbS9tZGFkbS5jb25mXCIgICAtYyAtbyByZXN0cmlw
ZS5vIHJlc3RyaXBlLmMKZ2NjIC1XYWxsIC1XZXJyb3IgLVdzdHJpY3QtcHJvdG90eXBlcyAtZ2dk
YiAtRFNlbmRtYWlsPVwiIi91c3Ivc2Jpbi9zZW5kbWFpbCAtdCJcIiAtRENPTkZGSUxFPVwiL2V0
Yy9tZGFkbS5jb25mXCIgLURDT05GRklMRTI9XCIvZXRjL21kYWRtL21kYWRtLmNvbmZcIiAgIC1j
IC1vIHN5c2ZzLm8gc3lzZnMuYwpnY2MgLVdhbGwgLVdlcnJvciAtV3N0cmljdC1wcm90b3R5cGVz
IC1nZ2RiIC1EU2VuZG1haWw9XCIiL3Vzci9zYmluL3NlbmRtYWlsIC10IlwiIC1EQ09ORkZJTEU9
XCIvZXRjL21kYWRtLmNvbmZcIiAtRENPTkZGSUxFMj1cIi9ldGMvbWRhZG0vbWRhZG0uY29uZlwi
IC1ESEFWRV9TVERJTlRfSCAtbyBzaGExLm8gLWMgc2hhMS5jCmdjYyAtV2FsbCAtV2Vycm9yIC1X
c3RyaWN0LXByb3RvdHlwZXMgLWdnZGIgLURTZW5kbWFpbD1cIiIvdXNyL3NiaW4vc2VuZG1haWwg
LXQiXCIgLURDT05GRklMRT1cIi9ldGMvbWRhZG0uY29uZlwiIC1EQ09ORkZJTEUyPVwiL2V0Yy9t
ZGFkbS9tZGFkbS5jb25mXCIgICAtYyAtbyBtYXBmaWxlLm8gbWFwZmlsZS5jCmdjYyAtV2FsbCAt
V2Vycm9yIC1Xc3RyaWN0LXByb3RvdHlwZXMgLWdnZGIgLURTZW5kbWFpbD1cIiIvdXNyL3NiaW4v
c2VuZG1haWwgLXQiXCIgLURDT05GRklMRT1cIi9ldGMvbWRhZG0uY29uZlwiIC1EQ09ORkZJTEUy
PVwiL2V0Yy9tZGFkbS9tZGFkbS5jb25mXCIgICAtYyAtbyBjcmMzMi5vIGNyYzMyLmMKZ2NjIC1X
YWxsIC1XZXJyb3IgLVdzdHJpY3QtcHJvdG90eXBlcyAtZ2dkYiAtRFNlbmRtYWlsPVwiIi91c3Iv
c2Jpbi9zZW5kbWFpbCAtdCJcIiAtRENPTkZGSUxFPVwiL2V0Yy9tZGFkbS5jb25mXCIgLURDT05G
RklMRTI9XCIvZXRjL21kYWRtL21kYWRtLmNvbmZcIiAgIC1jIC1vIHNnX2lvLm8gc2dfaW8uYwpn
Y2MgLVdhbGwgLVdlcnJvciAtV3N0cmljdC1wcm90b3R5cGVzIC1nZ2RiIC1EU2VuZG1haWw9XCIi
L3Vzci9zYmluL3NlbmRtYWlsIC10IlwiIC1EQ09ORkZJTEU9XCIvZXRjL21kYWRtLmNvbmZcIiAt
RENPTkZGSUxFMj1cIi9ldGMvbWRhZG0vbWRhZG0uY29uZlwiICAgLWMgLW8gbXNnLm8gbXNnLmMK
Z2NjIC1XYWxsIC1XZXJyb3IgLVdzdHJpY3QtcHJvdG90eXBlcyAtZ2dkYiAtRFNlbmRtYWlsPVwi
Ii91c3Ivc2Jpbi9zZW5kbWFpbCAtdCJcIiAtRENPTkZGSUxFPVwiL2V0Yy9tZGFkbS5jb25mXCIg
LURDT05GRklMRTI9XCIvZXRjL21kYWRtL21kYWRtLmNvbmZcIiAgIC1jIC1vIHBsYXRmb3JtLWlu
dGVsLm8gcGxhdGZvcm0taW50ZWwuYwpnY2MgLVdhbGwgLVdlcnJvciAtV3N0cmljdC1wcm90b3R5
cGVzIC1nZ2RiIC1EU2VuZG1haWw9XCIiL3Vzci9zYmluL3NlbmRtYWlsIC10IlwiIC1EQ09ORkZJ
TEU9XCIvZXRjL21kYWRtLmNvbmZcIiAtRENPTkZGSUxFMj1cIi9ldGMvbWRhZG0vbWRhZG0uY29u
ZlwiICAgLWMgLW8gcHJvYmVfcm9tcy5vIHByb2JlX3JvbXMuYwpnY2MgIC1vIG1kYWRtIG1kYWRt
Lm8gY29uZmlnLm8gbWRzdGF0Lm8gIFJlYWRNZS5vIHV0aWwubyBNYW5hZ2UubyBBc3NlbWJsZS5v
IEJ1aWxkLm8gQ3JlYXRlLm8gRGV0YWlsLm8gRXhhbWluZS5vIEdyb3cubyBNb25pdG9yLm8gZGxp
bmsubyBLaWxsLm8gUXVlcnkubyBJbmNyZW1lbnRhbC5vIG1kb3Blbi5vIHN1cGVyMC5vIHN1cGVy
MS5vIHN1cGVyLWRkZi5vIHN1cGVyLWludGVsLm8gYml0bWFwLm8gcmVzdHJpcGUubyBzeXNmcy5v
IHNoYTEubyBtYXBmaWxlLm8gY3JjMzIubyBzZ19pby5vIG1zZy5vIHBsYXRmb3JtLWludGVsLm8g
cHJvYmVfcm9tcy5vIApnY2MgLVdhbGwgLVdlcnJvciAtV3N0cmljdC1wcm90b3R5cGVzIC1nZ2Ri
IC1EU2VuZG1haWw9XCIiL3Vzci9zYmluL3NlbmRtYWlsIC10IlwiIC1EQ09ORkZJTEU9XCIvZXRj
L21kYWRtLmNvbmZcIiAtRENPTkZGSUxFMj1cIi9ldGMvbWRhZG0vbWRhZG0uY29uZlwiICAgLWMg
LW8gbWRtb24ubyBtZG1vbi5jCmdjYyAtV2FsbCAtV2Vycm9yIC1Xc3RyaWN0LXByb3RvdHlwZXMg
LWdnZGIgLURTZW5kbWFpbD1cIiIvdXNyL3NiaW4vc2VuZG1haWwgLXQiXCIgLURDT05GRklMRT1c
Ii9ldGMvbWRhZG0uY29uZlwiIC1EQ09ORkZJTEUyPVwiL2V0Yy9tZGFkbS9tZGFkbS5jb25mXCIg
ICAtYyAtbyBtb25pdG9yLm8gbW9uaXRvci5jCmdjYyAtV2FsbCAtV2Vycm9yIC1Xc3RyaWN0LXBy
b3RvdHlwZXMgLWdnZGIgLURTZW5kbWFpbD1cIiIvdXNyL3NiaW4vc2VuZG1haWwgLXQiXCIgLURD
T05GRklMRT1cIi9ldGMvbWRhZG0uY29uZlwiIC1EQ09ORkZJTEUyPVwiL2V0Yy9tZGFkbS9tZGFk
bS5jb25mXCIgICAtYyAtbyBtYW5hZ2Vtb24ubyBtYW5hZ2Vtb24uYwpnY2MgIC1vIG1kbW9uIG1k
bW9uLm8gbW9uaXRvci5vIG1hbmFnZW1vbi5vIHV0aWwubyBtZHN0YXQubyBzeXNmcy5vIGNvbmZp
Zy5vIEtpbGwubyBzZ19pby5vIGRsaW5rLm8gUmVhZE1lLm8gc3VwZXIwLm8gc3VwZXIxLm8gc3Vw
ZXItaW50ZWwubyBzdXBlci1kZGYubyBzaGExLm8gY3JjMzIubyBtc2cubyBiaXRtYXAubyBwbGF0
Zm9ybS1pbnRlbC5vIHByb2JlX3JvbXMubyAKbnJvZmYgLW1hbiBtZGFkbS44ID4gbWRhZG0ubWFu
Cm5yb2ZmIC1tYW4gbWQuNCA+IG1kLm1hbgpucm9mZiAtbWFuIG1kYWRtLmNvbmYuNSA+IG1kYWRt
LmNvbmYubWFuCm5yb2ZmIC1tYW4gbWRtb24uOCA+IG1kbW9uLm1hbgo=
--000e0cd1e218a8b7870474a3e902--
