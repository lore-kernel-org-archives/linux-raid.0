From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: Failing to grow raid10 with one larger disk
Date: Fri, 25 Jan 2013 12:32:11 +1100
Message-ID: <5101E09B.3030404@websitemanagers.com.au>
References: <CAOHBbgU5Uf+eD=O7_0K1AKn_t+RcdaeAQabf9XSST8qtcbaAsw@mail.gmail.com> <CADNH=7H+r25QRY0RekU+ukG=s-TT9FNfMnfctj=oKniPiYL0-Q@mail.gmail.com> <CAOHBbgVizy_LTyOaT=WUyPbFjOOLLxRFnMT3hYWPF5cVmRpHJg@mail.gmail.com> <5101DB37.7030407@fnarfbargle.com> <CAOHBbgUbbxWZh2TM5m+o6ULHxctGPOs55mK3sKrX8A-D5UKJCg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAOHBbgUbbxWZh2TM5m+o6ULHxctGPOs55mK3sKrX8A-D5UKJCg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Asif Iqbal <vadud3@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 25/01/13 12:22, Asif Iqbal wrote:
> On Thu, Jan 24, 2013 at 8:09 PM, Brad Campbell <brad@fnarfbargle.com> wrote:
>> On 25/01/13 09:02, Asif Iqbal wrote:
>>> I was hoping to grow the size of the raid10. I was following this link
>>> https://raid.wiki.kernel.org/index.php/Growing#Expanding_existing_partitions
>>
>> Re-read the second sentence on the first line of that page.
> doh! so I can only grow raid level 1/4/5/6
>
> ok, can you suggest how can I increase the /dir (/dev/md10) with bigger disks?
>
> I already backed up the data.
>
> does linux software raid allow disks of different sizes in raid10? I
> did not see much discussion
> of raid level 10 in that wiki page.

From my understanding, there are two methods:
1) Create new RAID10, dd old RAID10 to new one, expand
filesystem/lvm/whatever is on the RAID10
2) Don't use RAID10, use RAID1 + linear. Don't increase the size of
members, only add additional pairs at the end of the linear array.
3) The one exception to 2 is that you can expand the size of the last
pair, but this is somewhat tricky. I've done this successfully twice,
but I doubt you really want to be using linear anyway.

Regards,
Adam

-- 
Adam Goryachev
Website Managers
www.websitemanagers.com.au

