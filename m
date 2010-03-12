From: "Majed B." <majedb@gmail.com>
Subject: Re: Growing after replacing with larger discs
Date: Fri, 12 Mar 2010 21:13:07 +0300
Message-ID: <70ed7c3e1003121013u6dc745abhe1376b28f01e68ec@mail.gmail.com>
References: <4B9A7C63.6090202@anonymous.org.uk> <70ed7c3e1003121000q3cfb5eddt7ebd496cdd5f2e1a@mail.gmail.com>
	<4B9A8225.3010805@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B9A8225.3010805@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

If you do this kind of thing a lot, or often enough, then it's better
to get a portable NAS, copy filesystem contents to it, then dump the
stuff back.

You can save yourself time with the new arrays by zeroing all the new
disks, and then when creating the new array, use assume-clean. That'll
prevent the array from resyncing, and you'll get full speed when
copying the filesystem contents back to the new array.

dd allows parallel writing to output devices.

On Fri, Mar 12, 2010 at 9:04 PM, John Robinson
<john.robinson@anonymous.org.uk> wrote:
> On 12/03/2010 18:00, Majed B. wrote:
>>
>> I'm not sure if it is going to work or not, what you suggested.
>>
>> But if you can run all disks at the same time, then why not create a
>> new array and copy the files over?
>
> I can't, I only have the 3 drive caddies, so I was going to shut down, start
> up from a CD, copy each drive individually, then put the 3 larger drives in
> all at once.
>
> Cheers,
>
> John.
>
>



-- 
       Majed B.
