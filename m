From: <c4c3m@oke.net.id>
Subject: Re: RAID 5 On Linux
Date: Fri, 25 Jul 2003 10:18:33 +0700 (JAVT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <45881.202.158.96.2.1059103113.power.web.id@mail2.oke.net.id>
References: <16160.37915.55072.524606@gargle.gargle.HOWL>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16160.37915.55072.524606@gargle.gargle.HOWL>
To: neilb@cse.unsw.edu.au
Cc: c4c3m@oke.net.id, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

the version mdadm that i use is mdadm-1.2.0 and i did make mdadm.static then
make install..but it still need library when i load from faulty machine ( i
try install mdadm-1.2.0 from debian 3.0 machine and red hat 9 machine). any
suggestion ??

thanks a lot
regards

hendri


> On Friday July 25, c4c3m@oke.net.id wrote:
>> i did it what u say. i was install mdadm from other machine and loat
>> it on faulty machine. but another  error show up (mdadm:
>> /lib/libc.so.6: version 'GLIBC_2.2.3' not found (required by mdadm)).
>> i'm using red hat 6.2 and when i try to check the files
>> (libc.so.6)...it was there...what should i do ???
>> note:
>> * i can't access /usr and /var partition
>>
>
> You can build a statically linked mdadm with
>
>   make mdadm.static
>
> if you copy this across to your faulty machine, it should run without
> needing to find any libraries.
>
> NeilBrown



-----------------------------------------
This email was sent using OkeMail.
 "Your Communication LifeStyle!"
      http://www.oke.net.id/


