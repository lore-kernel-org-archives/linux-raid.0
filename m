From: Chris Murphy <lists@colorremedies.com>
Subject: Re: read errors with md RAID5 array
Date: Mon, 15 Aug 2016 10:23:33 -0600
Message-ID: <CAJCQCtSDEWr6Tp0Hd+Jifw4h_aoM6Tqroav_vLmfwfqjoEe8Rg@mail.gmail.com>
References: <78aab29c-9b7b-ff8b-f9c7-fab286f16243@buttersideup.com>
 <CAJCQCtSggAsQMSH9Ufa=Vjmu13cBm58+Q-RBZ4WRXm9UF=Yd+Q@mail.gmail.com> <b353161b-255e-e359-e3f4-800eac848847@buttersideup.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <b353161b-255e-e359-e3f4-800eac848847@buttersideup.com>
Sender: linux-raid-owner@vger.kernel.org
To: Tim Small <tim@buttersideup.com>
Cc: Chris Murphy <lists@colorremedies.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Aug 15, 2016 at 8:42 AM, Tim Small <tim@buttersideup.com> wrote:
> On 15/08/16 14:57, Chris Murphy wrote:
>> $ sudo smartctl -l scterc <dev>   ## for each device used in the array
>> $ sudo cat /sys/block/<dev>/device/timeout   ## for each device used
>> in the array
>
> These were all reporting:
>
> SCT Error Recovery Control:
>            Read: Disabled
>           Write: Disabled


You failed to provide the value for the 2nd command. Is it something
other than 30 for each device?



>
> However I'm not sure how this would cause a read error from the md
> device itself?  There are no timeout/reset messages in the kernel logs
> for the underlying SATA devices?

Nevertheless it's a misconfiguration that inhibits proper read error
reporting by the drive, thereby preventing the md driver from fixing
bad sectors via writing good data over them and causing the drive
firmware to sort it out. So you should issue 'smartctl -l scterc,70,70
<dev>' for all devices and make sure this is made persistent at boot
time.




>
> To check, I've set the ERC on all drives to 6.5 seconds for both reads
> and writes, and restarted the "dd if=/dev/md2 of=/dev/null
> conv=noerror", and it's just produced read failures at exactly the same
> places, with no further kernel messages.


Well it isn't really a read error, it's a buffer io error that happens
to be triggered when reading, so it's a little more specific than a
read error. It sounds to me you've run into a bug or there's some kind
of hardware problem somewhere. It might be helpful if you provide the
entire dmesg from boot until the first error message. As well as the
stuff Andreas asked for.



-- 
Chris Murphy
