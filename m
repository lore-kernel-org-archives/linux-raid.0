From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: Why not just return an error?
Date: Tue, 11 Oct 2016 12:00:47 +0800
Message-ID: <a1fd81ef-c52e-8d10-e754-984e3f7be60e@fnarfbargle.com>
References: <57F6DF18.40703@yandex.ru> <20161007112151.GA4405@metamorpher.de>
 <e887908f-ba51-0f88-f891-f60e8bac50bd@turmel.org>
 <57F7CC10.3050607@yandex.ru>
 <94b1a4f4-adec-90b7-e804-2d8d2c94a7af@turmel.org>
 <57F7DF05.8090605@yandex.ru>
 <b9e7054f-8d68-c576-41a5-aec60c53aa9b@youngman.org.uk>
 <20161010213726.GA3757@metamorpher.de> <57FC0E65.1050407@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <57FC0E65.1050407@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, Andreas Klauer <Andreas.Klauer@metamorpher.de>
Cc: Dark Penguin <darkpenguin@yandex.ru>, Phil Turmel <philip@turmel.org>, Rudy Zijlstra <rudy@grumpydevil.homelinux.org>, keld@keldix.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 11/10/16 05:55, Wols Lists wrote:
> On 10/10/16 22:37, Andreas Klauer wrote:
>> On Mon, Oct 10, 2016 at 09:47:04PM +0100, Anthony Youngman wrote:
>>> with a list of all blocks that failed to copy. Then we need to patch the
>>> low-level disk access code so that it reads this list of "bad blocks"
>>> and returns a read error if any attempt is made to read one. If a block
>>
>> hdparm has that feature to mark sectors as bad (--make-bad-sector).
>> not sure how that behaves on a re-write by md. I never tried it myself.
>
> I'm guessing it's useless ...

Not useless at all.

> The point is that the disk sector is not bad. So you don't want to mark
> it as bad on the disk. But you know that the *data* in that block is
> bad, so you want the disk access layer to fake a read error when you try
> to read it. The intent is to deliberately trigger a rewrite by md.

I suggested this a while ago. Take the badblocks log, use hdparm to mark 
each bad sector as bad and put the drive back in the array. I even 
suggested potentially adding a feature to ddrescue to auto-mark the 
blocks as bad on the target drive.

When md reads from that bad sector it will get an immediate error from 
the drive, reconstruct the data and rewrite it, clearing the bad sector.

This absolutely prevents a rescued disk from returning zeros rather than 
bad data, and allows the good parts of the disk to participate in the 
array redundancy while stuff gets rectified.

This is only useful where you have several dud disks in an array and the 
bad sectors are not in the same stripes, but for that pathological case 
it would allow ddrescuing onto new drives and reconstructing the array 
without data loss. Whereas simply using ddrescued disks will happily 
return zeros where the holes are.

Regards,
Brad
