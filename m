From: "Justin Stephenson" <justin@evensteveninc.com>
Subject: Re[2]: Raid 6 Fail Event
Date: Mon, 17 Nov 2014 01:34:38 +0000
Message-ID: <em90cf29a7-2a88-4bcc-a6fa-eca2cd446449@littlez>
References: <3B23D2F1-09A3-4C1F-AB38-2AB0DDC2D5A7@colorremedies.com>
Reply-To: "Justin Stephenson" <justin@evensteveninc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3B23D2F1-09A3-4C1F-AB38-2AB0DDC2D5A7@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thank-you, Chris. I appreciate your help with this.

Backup are good. I'm a regular disk to disk to LTO guy. Here is what I=20
have turned up:

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
# smartctl -x /dev/sdh

big long list of stuff. I found the serial.

I also tried smartctl -H /dev/sdh and received

Overall-health self-assesment test restul: PASSED

184 End-to-End_Error {flag value worst thresh} Old_age FAILING_NOW_6

I did not find anything for the serial in results from dmesg

# smartctl -l scterc /dev/sdh

Warning: device does not support SCT Commands

# cat /sys/block/sdh/device/state

Running

# cat /sys/block/sdh/device/timeout

30

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D

Should I replace the drive or re add and resync?

I also went through and reseated all the SATA and power connections as =
I=20
understand these can cause issues as well.

Best,

- J


------ Original Message ------
=46rom: "Chris Murphy" <lists@colorremedies.com>
To: "Justin Stephenson" <justin@evensteveninc.com>
Cc: linux-raid@vger.kernel.org
Sent: 16/11/2014 2:52:02 PM
Subject: Re: Raid 6 Fail Event

>
>On Nov 16, 2014, at 8:39 AM, Justin Stephenson=20
><justin@evensteveninc.com> wrote:
>
>>  Hello,
>>
>>  I am new to MDADM and have just experienced my first device fail on=
=20
>>my raid 6.
>>
>>  I am wondering if someone might be able to help by outlining a prop=
er=20
>>protocol for troubleshooting and rebuilding this array (proc/mdstat=20
>>below).
>>
>>  Here is how I might approach it:
>>
>>  - remove the device
>>  - test the device
>>  - if the device tests OK then re add the device
>>  - if the device fails, then replace the device
>>  - resync
>>
>>  Thank-you for your consideration.
>>
>>  Best,
>>
>>  - Justin
>>
>>  Here is the mdstat email
>>
>>  -----------------
>>
>>  This is an automatically generated mail message from mdadm
>>  running on BigBlue
>>
>>  A Fail event had been detected on md device /dev/md0.
>>
>>  It could be related to component device /dev/sdh1.
>
>First step is getting the backup current.
>
>Second you can do this without removing the device:
>
># smartctl -x /dev/sdh
>
>And then look in dmesg for errors related to its ata designation. You=20
>should be able to get a serial number from the smartctl output and can=
=20
>search that with dmesg | grep <serial#> to find out what it=E2=80=99s =
ata=20
>designation (port and device number) is, then you can dmesg | grep=20
>ataX.YY to get any read/write error events that explain what=E2=80=99s=
 going=20
>on.
>
>While you=E2=80=99re at it the following would be helpful as well:
>
># smartctl -l scterc /dev/sdh
># cat /sys/block/sdh/device/state
># cat /sys/block/sdh/device/timeout
>
>These are read-only commands to determine states, they don=E2=80=99t c=
hange=20
>states so it=E2=80=99s safe.
>
>Chris Murphy

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
