From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: Read errors on raid5 ignored, array still clean .. then disaster !!
Date: Wed, 27 Jan 2010 16:06:26 +0100
Message-ID: <87wrz337v1.fsf@frosties.localdomain>
References: <4B5F6C73.30707@texsoft.it> <4B6000F0.2000405@shiftmail.org>
	<4B6010F5.6030702@texsoft.it> <4B601A5F.9050301@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B601A5F.9050301@shiftmail.org> (asdo@shiftmail.org's message of
	"Wed, 27 Jan 2010 11:50:07 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Asdo <asdo@shiftmail.org> writes:

> Giovanni Tessore wrote:
>> I didn't setup smart monitoring... Luca is right.
>> But I dont like the idea that md relies on another tool, that could
>> be not installed or correctly configured, to warn the user on
>> potential critical situations which involve directly itself.
>>
>> From the logs, it results that it did a "check" on md3 the 4 january
>> (first read errors at beginning of december, failure of other disk
>> 18 january); no read error occurred.
>> Looks like it did not help much :(
>> Maybe I was just very unluky
>
> It's strange... quite unlucky I'd say...
> Maybe the check needs to be run more frequently, like weekly.
> (Asdo taking notes... :-D)
> I also am not expert of this kind of statistics.
> FWIW I have seen two hardware raid controllers, and they do the scrub
> weekly by default. I don't know if they also run SMART tests.
>
> Also is it possible that you experienced an electricity surge or a
> physical shock on the computer?
>
> Obviously smart checks also help.
>
> Good luck
> Asdo

Or the check just does not report errors.

You need to read your syslog/kernel log to see read errors and check the
mismatch count after a check. Not all distributions do report mismatch
count != 0 after a check. Most don't I think.

MfG
        Goswin
