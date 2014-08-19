From: Killian De Volder <killian.de.volder@megasoft.be>
Subject: Re: Can I replace raid6 disk using dd?
Date: Tue, 19 Aug 2014 09:09:34 +0200
Message-ID: <53F2F82E.7070204@megasoft.be>
References: <CABY_QbV8=y_VnsYk6XC0MEZ7-Np-20PoJLsyKoZA6BzdvUMguA@mail.gmail.com> <53F2B6D8.4030208@shiftmail.org> <53F2BB43.4030408@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <53F2BB43.4030408@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ram Ramesh <rramesh2400@gmail.com>, Ethan Wilson <ethan.wilson@shiftmail.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

No need to remove the bitmap.
But be very careful that the disk is exactly the same size (or bigger).
I recently had a disk that was slightly smaller then advertised !

But if it's a raid6 why not just jank a disk ?
It's still going to be redundant, but only on 1 disk.

Killian De Volder
Megasoft bvba
killian.de.volder@megasoft.be

On 19-08-14 04:49, Ram Ramesh wrote:
> On 08/18/2014 09:30 PM, Ethan Wilson wrote:
>> On 18/08/2014 21:26, Ram Ramesh wrote:
>>> I had a recent disk failure in my 4x2TB raid6 and as a temporary fix I
>>> added a 4tb drive to prevent the drive from being degraded while I
>>> researched for a new drive.
>>>
>>> Now that I have purchased a new drive, I am wondering if it is ok to
>>> simply dd the first 2tb of the 4tb drive to replace the drive. I am
>>> asking because my case/motherboard does not have another HD slot to
>>> add the new disk
>>> in parallel with raid6. I was thinking of shutting down the machines,
>>> moving the 4tb memmebr and the new drive to another machine, making
>>> image copy (only 2tb), and putting the
>>> 2tb drive back in the original machine and rebooting. Will this work?
>>
>>
>> I think it should work, if metadata is 1.1 or 1.2 . I'm not sure if it is 1.0 .
>> You can also attach it via USB with an adapter, and do a replace (look up "want_replacement") then shutdown, swap the drives, and turn on again.
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> I thought about USB. First I do not have one, but that is a small problem to overcome. I was thinking more in terms of
> performance. USB will slow things down as it is 2.0 (old MB) and dd should be real fast (130+ MB, based on the replacement)
> But, I agree that mdadm replace is safer. Do I have to remove bitmap for replacement? I don't think so, but this is a newer operation and less info is available, so making sure.
>
> Ramesh
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

