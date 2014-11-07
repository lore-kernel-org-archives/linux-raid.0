From: Phil Turmel <philip@turmel.org>
Subject: Re: Raid5 drive fail during grow and no backup
Date: Fri, 07 Nov 2014 08:36:42 -0500
Message-ID: <545CCAEA.6070204@turmel.org>
References: <loom.20141031T141939-473@post.gmane.org> <5455A35C.2060000@turmel.org> <loom.20141103T151703-83@post.gmane.org> <5458FC2A.1050308@turmel.org> <loom.20141105T200200-434@post.gmane.org> <loom.20141106T175806-337@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <loom.20141106T175806-337@post.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Vince <stuff@hagenhuegel.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 11/06/2014 12:12 PM, Vince wrote:
> Hi Phil,
>
>> This is a problem you haven't solved yet, I think.  The raid array
>> should have fixed this bad sector for you without kicking the drive out.
>> The scenario is common with "green" drives and/or consumer-grade
>> drives in general.
>
> i investigated some time and now i am a bit confused.
>
> All my 5 WD Red drives have ERC enables (7sec)
> The kernel timeout is set to 30sec (/sys/block/sdb/device/timeout)
> on all devices.
>
> Unfortunately i haven't any backup of the dmesg output, but i can remeber i
> got something like:
> "failed command: READ FPDMA QUEUED status: { DRDY ERR } error: { UNC }".
> This shows up several times until it ends with showing me the sector which
> causes the problem.
>
> My raid is still up, but as you mentioned i would like some kind of self
> repair if a sector is unreadable instead throwing the disk out of the array.
>
> Here is the samrtctl of one drive that fails.
>
> Do you have any idea if i missing some settings etc?

Interesting.  I use the WD Red drives, too, and recommend them.  Your 
drive's smartctl report is clean as far as wear & tear is concerned. 
That suggests a hardware problem elsewhere in your system.  Bad cable, 
perhaps, or a failing power supply.

Beyond that, I can only recommend regular "check" scrubs, with "repair" 
scrubs only when mismatches are discovered.

Phil
