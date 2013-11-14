From: "Justin Piszcz" <jpiszcz@lucidpixels.com>
Subject: RE: 3.12: raid-1 mismatch_cnt question
Date: Thu, 14 Nov 2013 05:43:30 -0500
Message-ID: <002201cee126$5c390290$14ab07b0$@lucidpixels.com>
References: <000f01ced948$2fbab140$8f3013c0$@lucidpixels.com> <527E8B74.70301@shiftmail.org> <008301cedd9d$fc254cf0$f46fe6d0$@lucidpixels.com> <527F7FF5.3000002@shiftmail.org> <000301cedec0$1fa72d60$5ef58820$@lucidpixels.com> <5280BA1E.6060604@shiftmail.org> <CAO9zADyyXiw91y=GwArcC9wUrhRPNNxp_XMAgtcPxR=fiZZY1g@mail.gmail.com> <5281F53D.4060703@shiftmail.org> <528202ED.1040307@fastmail.fm> <000001cee0bd$1979da60$4c6d8f20$@lucidpixels.com> <52848D5C.7020701@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52848D5C.7020701@shiftmail.org>
Content-Language: en-us
Sender: linux-raid-owner@vger.kernel.org
To: 'joystick' <joystick@shiftmail.org>
Cc: 'Bernd Schubert' <bernd.schubert@fastmail.fm>, 'linux-raid' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



-----Original Message-----
From: joystick [mailto:joystick@shiftmail.org] 
Sent: Thursday, November 14, 2013 3:44 AM
To: Justin Piszcz
Cc: 'Bernd Schubert'; 'linux-raid'
Subject: Re: 3.12: raid-1 mismatch_cnt question

On 13/11/2013 23:10, Justin Piszcz wrote:
> I attempted to test both here:
> http://home.comcast.net/~jpiszcz/20131113/joystick_cmds.txt
>
> The --re-add did not work btw.
>

>> Unfortunately the --re-add HAD to work for the test to be of any value.

$ cat /sys/devices/virtual/block/md1/md/mismatch_cnt
303232

Ready to test again, mismatch_cnt very high..

[ .. ]

Please see the following per your new instructions:
http://home.comcast.net/~jpiszcz/20131114/joystick_cmds2.txt

Summary: No diffs found.

>> What kernel version is yours?
Was using system rescue cd 3.7.0, appears to be 3.4.47.
Will re-try with the latest system rescue cd, 3.8.1, appears to be 3.4.66.

On a side note, I have not seen any corruption on any of my files; debsums also confirms no issues with any of the system files, so I am wondering if mismatch_cnt is accurate based on the diff above and not seeing any corruption?

# debsums|grep -v OK$
debsums: no md5sums for libgme0
#

Justin.

