From: Ram Ramesh <rramesh2400@gmail.com>
Subject: Re: Can I replace raid6 disk using dd?
Date: Tue, 19 Aug 2014 08:42:59 -0500
Message-ID: <53F35463.50204@gmail.com>
References: <CABY_QbV8=y_VnsYk6XC0MEZ7-Np-20PoJLsyKoZA6BzdvUMguA@mail.gmail.com> <53F2B6D8.4030208@shiftmail.org> <53F2BB43.4030408@gmail.com> <53F2F82E.7070204@megasoft.be> <53F313FA.5040106@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <53F313FA.5040106@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: Ethan Wilson <ethan.wilson@shiftmail.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 08/19/2014 04:08 AM, Ethan Wilson wrote:
> On 19/08/2014 09:09, Killian De Volder wrote:
>> No need to remove the bitmap.
>> But be very careful that the disk is exactly the same size (or bigger).
>> I recently had a disk that was slightly smaller then advertised !
>>
>> But if it's a raid6 why not just jank a disk ?
>> It's still going to be redundant, but only on 1 disk.
>>
>> Killian De Volder
>> Megasoft bvba
>> killian.de.volder@megasoft.be
>>
>
> I think it would not be accepted by MD if the size was smaller than 
> needed. At least with --replace. With the dd thing I don't know: it 
> might trust the metadata and bypass the check.... I'd be careful in 
> that case indeed.
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
Thank you all. I think many feel dd is risky although doable. I felt the 
same way too. Let me look for alternate/safe ways.

I wanted to experiment because  the real data in the array is small and 
I had good backups. Still, I do not think it is worth risking the chance 
of trashing the array.  I am more worried of the what if scenario, where 
there is corruption, but not detected until my backup is no longer up to 
date - I am not fond of Murphy :-)

Ramesh

