From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: RE: Kernel 2.6.32-5-amd64 fails to boot.
Date: Wed, 2 Feb 2011 06:00:07 -0500 (EST)
Message-ID: <alpine.DEB.2.00.1102020557270.21703@p34.internal.lan>
References: <42.F7.13137.411094D4@cdptpa-omtalb.mail.rr.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <42.F7.13137.411094D4@cdptpa-omtalb.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Leslie Rhorer <lrhorer@satx.rr.com>
Cc: 'Rudy Zijlstra' <rudy@grumpydevil.homelinux.org>, 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



On Wed, 2 Feb 2011, Leslie Rhorer wrote:

>>>> Serial console can be captured to a file and then the output analysed.
>>>> So you can read afterwards the messages that are flying past.
>>>>
>>>> What i do in such case, is that i take serial connector from a laptop,
>>>> and run a terminal emulater like minicom. And capture it to a file so i
>>>> can analyse what has been happening.
>>>>
>>> 	Yeah, I don't think there is anything pertinent prior to the md
>>> failures, but it might be worth a shot.  I don't have a laptop, but I do
>>> have another server sitting right below the one in question.  The main
>>> problem is, neither one has a serial port.
>>>
>>>
>> Network console? I could tell you how to setup serial console, but i've
>> never done the network console
>
> 	Me either.  I tired to do a Google search, but I think the words
> "network", "console", and "boot" are too common to return practical results,
> even when combined with "initrd".  I waded through a ton of results, but
> couldn't find a tutorial on how to enable a network console in the initrd.

Hi,

Check the network console documentation in the kernel.  Essentially, in 
LILO, run:

append="netconsole=4444@192.0.0.1/eth0,514@192.0.0.2/00:60:2D:CD:2A:B7"
                              ^^ src                  ^^dest / ^dest mac addr

On the remote host, run syslogd -r (to accespt remote syslogging)

This *is* clearly documented here in the kernel docs:
linux/Documentation/networking/netconsole.txt

Re:

It takes a string configuration parameter "netconsole" in the
following format:

  netconsole=[src-port]@[src-ip]/[<dev>],[tgt-port]@<tgt-ip>/[tgt-macaddr]

    where
         src-port      source for UDP packets (defaults to 6665)
         src-ip        source IP to use (interface address)
         dev           network interface (eth0)
         tgt-port      port for logging agent (6666)
         tgt-ip        IP address for logging agent
         tgt-macaddr   ethernet MAC address for logging agent (broadcast)

Examples:

Justin.
