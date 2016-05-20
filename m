From: d tbsky <tbskyd@gmail.com>
Subject: Re: suggest disk numbers in a raidset?
Date: Fri, 20 May 2016 18:13:07 +0800
Message-ID: <CAC6SzHKMdVJHGVnrxUL_uh2xeCj=KjzG2=VGKua122HvACVuVQ@mail.gmail.com>
References: <CAC6SzHJ8Wi18opzDbzjtT+niM5QKOyOU3AAeo0npbDsV+sQOTQ@mail.gmail.com>
	<20160520083830.GA3189@metamorpher.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160520083830.GA3189@metamorpher.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2016-05-20 16:38 GMT+08:00 Andreas Klauer <Andreas.Klauer@metamorpher.de>:
> The question is whether you really want that many disks in a single array.
>
> After all, the more disks, the more likely you have more than one disk fail,
> due to various causes (not just the disk itself, also cable problems, etc.)
> Do you test your disks regularly? md raid checks, smart self tests, do you
> actually replace them when they start reallocating sectors, ...?
>
> Do you want everything to be gone when the raid fails or just half? ;)
>
> I'm not sure if I'd be comfortable with more than ~24 disks in a raid6.
>
>> in the future, maybe add another 20 disks into the array
>
> If you have 20 disks now you could create a 20 disk raid6 now;
> if you add 20 disks later you can choose... grow by 20? or just
> create another 20 disk raid set. I think I'd go for the latter.
>
> But it's a personal choice. You have to make it yourself.
> Just make sure you have good monitoring for your disks,
> if you don't detect disk errors early, raid redundancy might not save you.
>
> Regards
> Andreas Klauer

If I use LSI raid card, I would use 16 or 24 disks in a raid6 set,
since the limit is 32.
but I would like to know if there are other thoughts when using software raid..
thanks for the suggestion :)

Regards,
tbskyd
