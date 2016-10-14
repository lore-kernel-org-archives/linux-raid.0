From: Ramon Hofer <ramonhofer@bluewin.ch>
Subject: Re: "bitmap" line in /proc/mdstat
Date: Fri, 14 Oct 2016 14:32:05 +0200
Message-ID: <5800D045.9060602@bluewin.ch>
References: <5800AE09.70608@bluewin.ch>
 <8922e2e1-b612-fa32-6932-9f4158f52fe6@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8922e2e1-b612-fa32-6932-9f4158f52fe6@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks for your answer, Phil.

On 14/10/16 13:53, Phil Turmel wrote:
> On 10/14/2016 06:06 AM, Ramon Hofer wrote:
>
>>  From what I was reading [1,2] it is useful for faster rebuilds.
>> But why is it not present for md[1234] as I used the same command to
>> create these RAIDs?
>> Is it only possible for the last of the linear devices, or is it only
>> used for almost empty devices, or was the bitmap introduced in a recent
>> update?
>
> Bitmaps have been available for a long time, but including them on a new
> array by default is recent.  They are most useful if a device is
> unexpectedly disconnected but otherwise OK.  mdadm --re-add will allow
> that device to rejoin the array and only the missing data (tracked by
> the bitmap) will have to be written to sync it up.

What could be an unexpected disconnect? If a disc is accidentally 
removed from a slot?


>> I wonder if I should and could add a bitmap for the other devices as well?
>
> There is a performance hit, so it should be considered on a case by case
> basis.

My uneducated guess would be that I don't really need it.

So I should probably remove the bitmap for the newly created device.
Although the performance hit is not really an issue in my case, I guess.
How much disk space is used for a 12 TB RAID5 bitmap?


Best regards,
Ramon
