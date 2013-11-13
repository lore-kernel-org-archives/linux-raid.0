From: "Justin Piszcz" <jpiszcz@lucidpixels.com>
Subject: RE: 3.12: raid-1 mismatch_cnt question
Date: Wed, 13 Nov 2013 17:10:00 -0500
Message-ID: <000001cee0bd$1979da60$4c6d8f20$@lucidpixels.com>
References: <000f01ced948$2fbab140$8f3013c0$@lucidpixels.com> <527E8B74.70301@shiftmail.org> <008301cedd9d$fc254cf0$f46fe6d0$@lucidpixels.com> <527F7FF5.3000002@shiftmail.org> <000301cedec0$1fa72d60$5ef58820$@lucidpixels.com> <5280BA1E.6060604@shiftmail.org> <CAO9zADyyXiw91y=GwArcC9wUrhRPNNxp_XMAgtcPxR=fiZZY1g@mail.gmail.com> <5281F53D.4060703@shiftmail.org> <528202ED.1040307@fastmail.fm>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <528202ED.1040307@fastmail.fm>
Content-Language: en-us
Sender: linux-raid-owner@vger.kernel.org
To: 'Bernd Schubert' <bernd.schubert@fastmail.fm>, 'joystick' <joystick@shiftmail.org>
Cc: 'linux-raid' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



-----Original Message-----
From: Bernd Schubert [mailto:bernd.schubert@fastmail.fm] 
Sent: Tuesday, November 12, 2013 5:29 AM
To: joystick; Justin Piszcz
Cc: linux-raid
Subject: Re: 3.12: raid-1 mismatch_cnt question

joystick's recommendations:

>> - wait for mismatch_cnt reach 2000 at least (the more, the better), then .. [ .. ]

$ cat /sys/devices/virtual/block/md1/md/mismatch_cnt 
254336


[ .. ]


If you have available disk space, you might run ql-fstest (possibly in 
combination) with the above method.

https://bitbucket.org/aakef/ql-fstest

Right now it does not support yet to restart it and to verify existing 
files, but I'm going to add this, either this evening or on Thursday.

[ .. ]

I attempted to test both here:
http://home.comcast.net/~jpiszcz/20131113/joystick_cmds.txt

The --re-add did not work btw.

Justin.

