From: <c4c3m@oke.net.id>
Subject: Re: RAID 5 On Linux
Date: Fri, 25 Jul 2003 09:14:21 +0700 (JAVT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <35005.202.158.96.2.1059099261.power.web.id@mail2.oke.net.id>
References: <16160.34422.833142.148043@gargle.gargle.HOWL>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16160.34422.833142.148043@gargle.gargle.HOWL>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

i did it what u say. i was install mdadm from other machine and loat it on
faulty machine. but another  error show up (mdadm: /lib/libc.so.6: version
'GLIBC_2.2.3' not found (required by mdadm)).
i'm using red hat 6.2 and when i try to check the files (libc.so.6)...it was
there...what should i do ???
note:
* i can't access /usr and /var partition


Thanks a lot
regards

hendri


> On Friday July 25, c4c3m@oke.net.id wrote:
>>
>> > There isn't really enough information here to see what is happening.
>> > Could you run
>> >   mdadm -Eb /dev/sd*
>> > and
>> >   mdadm -E /dev/sd*
>> >
>> > and send the output.
>> >
>> > If you don't have mdadm, you can get it from
>> >   http://www.kernel.org/pub/linux/utils/raid/mdadm/
>> >
>> > NeilBrown
>> i can't run mdam -E /dev/sd* because i guess it is in /var and /usr.
>> and the bad news is /usr include in raid 5 partition then i can't
>> access it.
>
> 1/ please reply to the list as well.
>
> 2/ Do you have another computer that you can build mdadm on, and the
> copy it onto a diskette, and the load it in on the faulty computer?
>
> NeilBrown



-----------------------------------------
This email was sent using OkeMail.
 "Your Communication LifeStyle!"
      http://www.oke.net.id/


