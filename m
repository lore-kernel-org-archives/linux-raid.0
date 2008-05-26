From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: How to force stopping an array`
Date: Mon, 26 May 2008 18:30:26 -0400 (EDT)
Message-ID: <alpine.DEB.1.10.0805261829160.31108@p34.internal.lan>
References: <200805262343.20626.Dexter.Filmore@gmx.de> <alpine.DEB.1.10.0805261806340.31108@p34.internal.lan> <200805270026.12994.Dexter.Filmore@gmx.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200805270026.12994.Dexter.Filmore@gmx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Dexter Filmore <Dexter.Filmore@gmx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Tue, 27 May 2008, Dexter Filmore wrote:

> Am Dienstag, 27. Mai 2008 00:06:57 schrieb Justin Piszcz:
>> On Mon, 26 May 2008, Dexter Filmore wrote:
>>> So I have a filesystem on an array I cannot unmount, hence I cannot stop
>>> the array.
>>> Any way to force it?
>>>
>>> Dex
>>
>> What is using it?
>>
>> lsof | grep /mount_point
>> lsof | grep /dev/mdX
>
> A defunct java process that died from a mem heap error. I can't kill the
> process, not even -9, leaves a <defunct>.

Other than rebooting I am not sure..  You could try making / re-mounting 
it as read-only but if the java process is still reading from the FS it 
probably will not be of any help.

Justin.
