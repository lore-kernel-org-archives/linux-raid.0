From: "Stephen Hargrove" <stephen@exitwound.org>
Subject: RE: Should I Start Over?
Date: Wed, 7 Jul 2004 14:40:46 -0500 (CDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <2354.66.230.1.97.1089229246.squirrel@exitwound.org>
References: <2128.66.230.1.97.1089224667.squirrel@exitwound.org>
    <200407071907.i67J7b309004@watkins-home.com>
Reply-To: stephen@exitwound.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200407071907.i67J7b309004@watkins-home.com>
To: Guy <bugzilla@watkins-home.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Guy said:
>
> Send me the output from these 2 commands:
> Cat /proc/mdstat

# cat /proc/mdstat
Personalities : [raid5]
read_ahead not set
unused devices: <none>

> mdadm -D /dev/md0

n# mdadm -D /dev/md0
mdadm: md device /dev/md0 does not appear to be active.

As I mentioned, I shut it off when it had reached 1.1% of the rebuild.  I
haven't turned it back on because I don't want it to begin rebuilding
again.  My minimal experience has shown that it will likely pick up where
it left off.  The startup script (Debian Sarge -- /etc/init.d/mdadm-raid)
is going to use /etc/mdadm/mdadm.conf, which is:

# cat /etc/mdadm/mdadm.conf
DEVICE /dev/hd*
ARRAY /dev/md0 level=raid5 num-devices=3
UUID=fef44719:ddd66a49:0a337b48:b53e14c0
   devices=/dev/hdg1,/dev/hdd1,/dev/hdc1

(And apparently doesn't reflect the fact that hde is my spare ...)

> Omit the disk that is being re-built!!!!!!  Not hde1.  hde1 was added as a
> spare.  It may still have good data.  The disk being re-built is toast!
> The other 2 may also have good data.

I'm guessing it was rebuilding hdg since that was the first device I
listed on the commandline.

> If you are not sure, just ask another question.

Thanks, Guy!  I sure do appreciate your assistance.

--
Steve
