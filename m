From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: RAID performance
Date: Fri, 08 Feb 2013 11:00:03 +1100
Message-ID: <4c6136c9-4deb-4baf-a861-ca562bbf1ecb@email.android.com>
References: <51134E43.7090508@websitemanagers.com.au> <CAKHEz2YLpyyqo-3XX=pX+D49QP1Y0DNaKcBN=9tPQDjmHAPfdw@mail.gmail.com> <51137FB8.6060003@websitemanagers.com.au> <51139799.2070004@fnarfbargle.com> <51139FEE.3020807@websitemanagers.com.au> <5113E06B.7030808@wirebound.net>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5113E06B.7030808@wirebound.net>
Sender: linux-raid-owner@vger.kernel.org
To: Fredrik Lindgren <fli@wirebound.net>
Cc: Brad Campbell <lists2009@fnarfbargle.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Fredrik Lindgren <fli@wirebound.net> wrote:

>Hello,
>
>On 02/07/2013 01:37 PM, Adam Goryachev wrote:
>> On 07/02/13 23:01, Brad Campbell wrote:
>>> On 07/02/13 18:19, Adam Goryachev wrote:
>> BTW, I just created a small LV (15G) and ran a couple of write tests
>> (well, not proper one, but at least you get some idea how bad things
>are).
>> dd if=/dev/zero of=/dev/vg0/testlv oflag=direct bs=16k count=50k
>> ^C50695+0 records in
>> 50695+0 records out
>> 830586880 bytes (831 MB) copied, 99.4635 s, 8.4 MB/s
>>
> From the iostat output it seems quite clear that the culprit is the
>drbd2 device. The /dev/sd[b-f] seems to have plenty more to give,
>even though they're doing some 1400 iops each (which seems a
>lot for the throughput you're seeing, why are the IOs towards the
>physical disks so small?).
>
>Regarding that drbd device, Is there some mirroring being done to
>another machine by way of drbd? If so, with a sync-mirror to another
>machine over the network 8,4Mb/s could be quite "normal", right?

Thank you for the smack, I realise now that I was stupidly doing this late at night, and as you suggested, the secondary comes online after business hours. I will need to redo my test after manually disconnecting the secondary server after hours.

Please ignore the above data, I will re-test tonight and advise.

Regards,
Adam

--
Adam Goryachev
Website Managers
www.websitemanagers.com.au
