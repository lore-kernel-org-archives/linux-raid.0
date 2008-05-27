From: "NeilBrown" <neilb@suse.de>
Subject: Re: How to force stopping an array`
Date: Tue, 27 May 2008 10:05:36 +1000 (EST)
Message-ID: <40275.192.168.1.70.1211846736.squirrel@neil.brown.name>
References: <200805262343.20626.Dexter.Filmore@gmx.de>
    <200805270026.12994.Dexter.Filmore@gmx.de>
    <alpine.DEB.1.10.0805261829160.31108@p34.internal.lan>
    <200805270102.15029.Dexter.Filmore@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200805270102.15029.Dexter.Filmore@gmx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Dexter Filmore <Dexter.Filmore@gmx.de>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, May 27, 2008 9:02 am, Dexter Filmore wrote:
> Am Dienstag, 27. Mai 2008 00:30:26 schrieb Justin Piszcz:
>> On Tue, 27 May 2008, Dexter Filmore wrote:
>> > Am Dienstag, 27. Mai 2008 00:06:57 schrieb Justin Piszcz:
>> >> On Mon, 26 May 2008, Dexter Filmore wrote:
>> >>> So I have a filesystem on an array I cannot unmount, hence I cannot
>> >>> stop the array.
>> >>> Any way to force it?
>> >>>
>> >>> Dex
>> >>
>> >> What is using it?
>> >>
>> >> lsof | grep /mount_point
>> >> lsof | grep /dev/mdX
>> >
>> > A defunct java process that died from a mem heap error. I can't kill
>> the
>> > process, not even -9, leaves a <defunct>.
>>
>> Other than rebooting I am not sure..  You could try making / re-mounting
>> it as read-only but if the java process is still reading from the FS it
>> probably will not be of any help.
>>
>> Justin.
>
> Exactly. reboot pretty much deosn't do any good, afterwars the raid
> resyncs,
> which takes full 7h here.

There shouldn't be a resync.  Presumably nothing is writing to the
array, and moments after the last write, the array will have been
flagged as 'clean' and will not require a resync after a reboot.

> What happens there anyway? it resyncs, but mdstats say [UUUUU], all fine.

I don't understand this question.

NeilBrown

