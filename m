From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: mdadm: /dev/md0 has been started with 1 drive (out of 2).
Date: Tue, 05 Nov 2013 22:39:50 +1100
Message-ID: <5278D906.4010301@websitemanagers.com.au>
References: <C8EFEBC6-4B43-4B71-AA3F-7DC69480220D@gmail.com> <5278C2A6.7060005@websitemanagers.com.au> <A30C811A-B2E9-4A46-A8D6-26E64C0D090E@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A30C811A-B2E9-4A46-A8D6-26E64C0D090E@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ivan Lezhnjov IV <ivan.lezhnjov.iv@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 05/11/13 22:32, Ivan Lezhnjov IV wrote:
> I checked out mdadm man page, read some pages on the web, and well, what bitmap chunk size should I go for considering these are WD Elements 2TB drives (what kind of technical information about these drives are relevant when considering a bitmap chunk size?)
> 

Other users might have a better suggestion, but I usually just use the
default.

The only time this will matter is if performance is really important to
you, then you can force a larger bitmap chunk size which will result in
more data being copied during a resync, but less bitmap updates,
therefore possibly better performance.

I mainly use it where I can't afford the 30 hours of resync time.

Regards,
Adam

> Ivan
> 
> On Nov 5, 2013, at 12:04 PM, Adam Goryachev <mailinglists@websitemanagers.com.au> wrote:
> 
>> Personally, I would also do:
>> mdadm --grow /dev/md0 --bitmap=internal
>> This means next time you have a similar issue, when you add the older
>> drive, it will only sync the small parts of the drive that are out of
>> date, instead of the entire drive.


-- 
Adam Goryachev
Website Managers
www.websitemanagers.com.au
