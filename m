From: joystick <joystick@shiftmail.org>
Subject: Re: 3.12: raid-1 mismatch_cnt question
Date: Thu, 14 Nov 2013 09:44:12 +0100
Message-ID: <52848D5C.7020701@shiftmail.org>
References: <000f01ced948$2fbab140$8f3013c0$@lucidpixels.com> <527E8B74.70301@shiftmail.org> <008301cedd9d$fc254cf0$f46fe6d0$@lucidpixels.com> <527F7FF5.3000002@shiftmail.org> <000301cedec0$1fa72d60$5ef58820$@lucidpixels.com> <5280BA1E.6060604@shiftmail.org> <CAO9zADyyXiw91y=GwArcC9wUrhRPNNxp_XMAgtcPxR=fiZZY1g@mail.gmail.com> <5281F53D.4060703@shiftmail.org> <528202ED.1040307@fastmail.fm> <000001cee0bd$1979da60$4c6d8f20$@lucidpixels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <000001cee0bd$1979da60$4c6d8f20$@lucidpixels.com>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: 'Bernd Schubert' <bernd.schubert@fastmail.fm>, 'linux-raid' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 13/11/2013 23:10, Justin Piszcz wrote:
> I attempted to test both here:
> http://home.comcast.net/~jpiszcz/20131113/joystick_cmds.txt
>
> The --re-add did not work btw.
>

Unfortunately the --re-add HAD to work for the test to be of any value.

Like you did, with just -a (--add), it resynced completely when you 
added the old device back in, similarly to when you run repair.
After that you had two exactly identical devices on the RAID, so, no 
wonder the two md5sums of the two legs resulted to be identical.
Also mismatch_cnt went to zero again, and will need to grow again to 
some significant value before you can repeat the test.

The reason for which --re-add failed seems to be (I did a test on our 
machines) that you need to also --remove the device after --fail, so it's:

when removing:
     mdadm /dev/md1 --fail /dev/sda2
mdadm: set /dev/sdb2 faulty in /dev/md1
     mdadm /dev/md1 --remove /dev/sda2
         mdadm: hot removed /dev/sdb2 from /dev/md1

.... compute md5sums ...

when re-adding:
     mdadm /dev/md1 --re-add /dev/sda2
         mdadm: re-added /dev/sda2

you actually did remove the drive, but after that you did not retry with 
--re-add, you went straight to --add which fully replicated the content 
of sda2 on sdb2

Also: does the array already have a bitmap? It's not clear from the log. 
If it does not have a bitmap, even --re-add will replicate all content, 
so you really need a bitmap for this test
To add a bitmap you can do:
mdadm /dev/md1 --grow --bitmap=internal
at the beginning of the test.

What kernel version is yours?

Regards
J.
