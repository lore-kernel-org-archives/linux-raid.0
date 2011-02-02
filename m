From: CoolCold <coolthecold@gmail.com>
Subject: Re: Kernel 2.6.32-5-amd64 fails to boot.
Date: Wed, 2 Feb 2011 14:32:05 +0300
Message-ID: <AANLkTimaz7epg+u9cKAYm_LB-jJn0YyU5hRZvdNHFVS1@mail.gmail.com>
References: <42.F7.13137.411094D4@cdptpa-omtalb.mail.rr.com>
	<alpine.DEB.2.00.1102020557270.21703@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1102020557270.21703@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Leslie Rhorer <lrhorer@satx.rr.com>, Rudy Zijlstra <rudy@grumpydevil.homelinux.org>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Feb 2, 2011 at 2:00 PM, Justin Piszcz <jpiszcz@lucidpixels.com>=
 wrote:
>
>
> On Wed, 2 Feb 2011, Leslie Rhorer wrote:
>
>>>>> Serial console can be captured to a file and then the output anal=
ysed.
>>>>> So you can read afterwards the messages that are flying past.
>>>>>
>>>>> What i do in such case, is that i take serial connector from a la=
ptop,
>>>>> and run a terminal emulater like minicom. And capture it to a fil=
e so i
>>>>> can analyse what has been happening.
>>>>>
>>>> =A0 =A0 =A0 =A0Yeah, I don't think there is anything pertinent pri=
or to the md
>>>> failures, but it might be worth a shot. =A0I don't have a laptop, =
but I do
>>>> have another server sitting right below the one in question. =A0Th=
e main
>>>> problem is, neither one has a serial port.
>>>>
>>>>
>>> Network console? I could tell you how to setup serial console, but =
i've
>>> never done the network console
>>
>> =A0 =A0 =A0 =A0Me either. =A0I tired to do a Google search, but I th=
ink the words
>> "network", "console", and "boot" are too common to return practical
>> results,
>> even when combined with "initrd". =A0I waded through a ton of result=
s, but
>> couldn't find a tutorial on how to enable a network console in the i=
nitrd.
>
> Hi,
>
> Check the network console documentation in the kernel. =A0Essentially=
, in
> LILO, run:
>
> append=3D"netconsole=3D4444@192.0.0.1/eth0,514@192.0.0.2/00:60:2D:CD:=
2A:B7"
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ^^ src =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0^^dest / ^dest mac addr
>
> On the remote host, run syslogd -r (to accespt remote syslogging)
>
> This *is* clearly documented here in the kernel docs:
> linux/Documentation/networking/netconsole.txt
>
> Re:
>
> It takes a string configuration parameter "netconsole" in the
> following format:
>
> =A0netconsole=3D[src-port]@[src-ip]/[<dev>],[tgt-port]@<tgt-ip>/[tgt-=
macaddr]
>
> =A0 where
> =A0 =A0 =A0 =A0src-port =A0 =A0 =A0source for UDP packets (defaults t=
o 6665)
> =A0 =A0 =A0 =A0src-ip =A0 =A0 =A0 =A0source IP to use (interface addr=
ess)
> =A0 =A0 =A0 =A0dev =A0 =A0 =A0 =A0 =A0 network interface (eth0)
> =A0 =A0 =A0 =A0tgt-port =A0 =A0 =A0port for logging agent (6666)
> =A0 =A0 =A0 =A0tgt-ip =A0 =A0 =A0 =A0IP address for logging agent
> =A0 =A0 =A0 =A0tgt-macaddr =A0 ethernet MAC address for logging agent=
 (broadcast)
>
> Examples:
>
> Justin.
As for me, when i've tryed to use netconsole on debian, i've needed to
add such lines into /etc/initramfs-tools/modules
8139too
8139cp
netconsole netconsole=3D4444@87.118.x.y/eth0,514@95.x.x.x/00:18:74:z:z:=
z

and do "update-initramfs -u -k `uname -r`" then
where 8139too are my NIC modules - can be obtained with lspci -k and
00:18:74:z:z:z was mac of the gateway. Worked on .18, but not on .32
kernel, though..

> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Best regards,
[COOLCOLD-RIPN]
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
