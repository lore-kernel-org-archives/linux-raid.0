From: Rudy Zijlstra <rudy@grumpydevil.homelinux.org>
Subject: Re: Why not just return an error?
Date: Fri, 7 Oct 2016 10:21:26 +0200
Message-ID: <0d0109f4-2c03-484c-9f70-008a7a1a0d67@grumpydevil.homelinux.org>
References: <57F6DF18.40703@yandex.ru>
 <20161007052651.GA11868@www5.open-std.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161007052651.GA11868@www5.open-std.org>
Sender: linux-raid-owner@vger.kernel.org
To: keld@keldix.com, Dark Penguin <darkpenguin@yandex.ru>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Op 07-10-16 om 07:26 schreef keld@keldix.com:
> On Fri, Oct 07, 2016 at 02:32:40AM +0300, Dark Penguin wrote:
>> Greetings!
>>
>> The more I read about md-raid, the more I notice that the biggest
>> problem of it: if you hit an error on a degraded RAID, it falls apart.
>> Because of this, it is possible to lose a huge amount of data due to one
>> tiny read error, which particularly makes raid5 the sword of Damocles.
>>
>> But one question keeps me increasingly frustrated. Yes, during its
>> normal functioning, it totally makes sense to kick a faulty device out
>> of an array. But if we're running a degraded array, and doing so will
>> definitely result is massive data loss, why not just return a read error
>> instead? Just add a little check: on error, if degraded -> then just
>> return an error. I believe this is the dream of everyone who had ever
>> dealt with RAIDs.
>>
>> With RAID, the first proprity is keeping data safe. Yes, it's not an
>> alternative to backups and all that, but still - if we hit an error on a
>> degraded array, the array should scream and panic and send all kinds of
>> warnings, but definitely NOT collapse and warrant a visit to the RAID
>> recovery laboratory (or this mailing list). Imagine how much headache
>> and lost hair would that relieve!..
>>
>> Now, I'm probably not the first one to think of such a bright idea. So
>> there must be a very good reason why this is not possible; I don't think
>> the problem is just that "the existing behaviour is preferred, and
>> anyone who does not agree is an idiot". If not for enterprise use, then
>> at least it would be very useful for the "home archive" scenario when
>> "uptime" and "absense of errors" hold much less meaning than "losing one
>> file and not all the data". So, why is this not possible?..
> Likewise, when the first disk fails, one could mark it as kind of in an error state,
> and keep it running, and if one gets a read error, then you could get
> the data from the good disks.
>
> Often read errors can be remedied by writing data to the failing disk.
> The good data could then be obtained from the good parts of the array.
>
> This behaviour could be optional and could even be set during operation.
>
> Best regards
> keld
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

One big reason is human behaviour. And it is human behaviour that in the 
end causes all the collapsed raids. I have lost count how often i have 
seen requests for help once the raid had collapsed. But the earlier 
signal, where the RAID had become degraded was ignored. This means that 
if you only give an error message and continue going you will -- most 
likely in increasing rate -- have errors in the files. Very quickly it 
will become impossible to state which file is correct and which is not. 
Essentially you have lost at that point all information with NO ability 
to recover. Unless you have a backup....

That is one of the big reasons the behaviour is as it is. RAID is 
intented to guarantee the consistency and correctness of the stored 
data. When this becomes impossible, the only way out is to clearly 
signal this. Even a collapsed RAID has  more consistent data (although 
it takes effort to recover) then a corrupted RAID which would be the 
result of your proposal. The corruption resulting from your proposal 
above CANNOT be recovered.


Cheers

Rudy
