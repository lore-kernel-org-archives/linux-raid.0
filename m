From: Andrew Dunn <andrew.g.dunn@gmail.com>
Subject: Re: RAID down, dont know why!
Date: Sun, 08 Nov 2009 17:15:27 -0500
Message-ID: <4AF742FF.4080509@gmail.com>
References: <4AF6CEFD.60309@gmail.com>	 <20091108142238.GA11786@cthulhu.home.robinhill.me.uk>	 <4AF6D494.2050207@gmail.com>	 <20091108150157.GB11786@cthulhu.home.robinhill.me.uk> <7d86ddb90911081408k175257b8g42fff881a7d1b7a7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7d86ddb90911081408k175257b8g42fff881a7d1b7a7@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ryan Wagoner <rswagoner@gmail.com>
Cc: linux-raid list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I had this setup running under ubuntu 9.04 with raid6, all nine drives
for about a month without any of these issues.

I installed the new ubuntu fresh and tried to rebuild the array with a
larger chunk size.

I also created the file system with the proper stride and width parameters.

I am wondering if TLER, or a larger chunk, ext options, or OS change
might have caused this. I do not think that it is a backpane issue... I
will however re-seat all of the drives here in a little bit.

Ryan Wagoner wrote:
> Is this the box on your blog at http://blog.agdunn.net/?p=391 ? If so
> those cards are to be used in the Supermicro UIO slot, which is
> basically just an inverted PCI Express slot. However since there is
> only one UIO slot per board they might have not tested compatibility
> with multiple in the same system.
>
> I do have one of these boards installed on an Intel board without
> issue. I have had the 7 drives connected in mdadm RAID for almost 2
> years now with no dropouts. You might try a port multiplier since the
> card supports it and one drive isn't going to use the full bandwidth
> of a single SAS cable.
>
> Ryan
>
> On Sun, Nov 8, 2009 at 10:01 AM, Robin Hill <robin@robinhill.me.uk> wrote:
>   
>> On Sun Nov 08, 2009 at 09:24:20AM -0500, Andrew Dunn wrote:
>>     
>>> Robin Hill wrote:
>>>       
>>>> On Sun Nov 08, 2009 at 09:00:29AM -0500, Andrew Dunn wrote:
>>>>
>>>>
>>>>         
>>>>> I just copied 4+ TiB of information to this array, restarted 5 times
>>>>> and tried to access it.... What is going on?
>>>>>
>>>>> What kind of logs do you need, I really need help!
>>>>>
>>>>>
>>>>>           
>>>> From the message you've posted, it looks like something has triggered
>>>> the (simultaneous) removal of four drives from the array.  I'd check the
>>>> dmesg output - it should provide some information.  I'd guess these four
>>>> drives are all attached to the same controller (are they external or
>>>> internal?), so possibly the controller reset (or for external drives, it
>>>> could be a cable issue).
>>>>
>>>>         
>>> What would I be looking for on this? Its a lot to sift through.
>>>
>>> Currently just line-by-lining it.
>>>
>>>       
>> Look for where the drives are being kicked out of the array (should be
>> towards the bottom).  Just above that should be some error messages
>> (often including bus resets).
>>
>> Cheers,
>>    Robin
>> --
>>     ___
>>    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
>>   / / )      | Little Jim says ....                            |
>>  // !!       |      "He fallen in de water !!"                 |
>>
>>     
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   

-- 
Andrew Dunn
http://agdunn.net

