From: =?ISO-8859-15?Q?Stefan_/*St0fF*/_H=FCbner?=
	<stefan.huebner@stud.tu-ilmenau.de>
Subject: Re: Recommended sw raid setup
Date: Tue, 05 Jul 2011 08:14:55 +0200
Message-ID: <4E12ABDF.50409@stud.tu-ilmenau.de>
References: <BANLkTinbBu6zX-6s2NYH5BQvnaJZJYt_BA@mail.gmail.com> <BANLkTinghqiT4QbBb--X7Eh_RRWnRg_0RQ@mail.gmail.com> <CACJz6Qv=u0-66hwOEg5AeZ2rWuw2OE10ozUKEQGTbuGn0_fgGg@mail.gmail.com> <BANLkTing8Ei+najZAFXN_ib0LRmQfS8e9Q@mail.gmail.com> <CACJz6QuzTj3cmESu0eBGgq3rK3wopXZpj9m34N5ecR=uj6FvCQ@mail.gmail.com>
Reply-To: stefan.huebner@stud.tu-ilmenau.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CACJz6QuzTj3cmESu0eBGgq3rK3wopXZpj9m34N5ecR=uj6FvCQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Drew <drew.kay@gmail.com>
Cc: Simon Matthews <simon.d.matthews@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Am 02.07.2011 23:30, schrieb Drew:
>> I thought that I had read the TLER was not useful for mdraid, so that
>> enterprise drives were not really advised for mdraid. Am I wrong about
>> this?
> 
> TLER just shortens the firmware's error recovery from something like
> 60 seconds down to 4 seconds. It's mainly useful in hardware RAID but
> I can see it being useful with mdraid in the enterprise where you
> can't afford to wait for the drive to do it's own recovery attempts.
> 
> 
This is not correct.  You may want to read the ATA8-ACS2 draft standard
(see www.t13.org).  There you'll find: SCT-ERC

The internal error recovery procedure includes a vast amount of
algorithms.  If a disk cannot read a sector and starts error recovery,
it may take far more than a minute.
With ERC you can tell the disk beforehand to stop processing the command
(may it be "read" or "write") and return a "uncorrectable error" to the
host.  Some drives (i.E. recent Hitachi Deskstar, which I do recommend!)
do not allow you to set ERC lower than 6.5s.

For a home-box I recommend adding a startup-script and a hotplug-script
(as ERC-settings get reset to firmware defaults upon power-on) which
uses smartmontools >=5.41 to set the read-ERC to 7s and the write ERC to
12s.  We have good experience that this works out well in productive
systems.

/Stefan
P.S.: pseudo-knowledge makes important things go really badly wrong.
