From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: Software RAID checksum performance on 24 disks not even close
 to kernel reported
Date: Wed, 06 Jun 2012 20:58:07 +0800
Message-ID: <4FCF53DF.3010001@fnarfbargle.com>
References: <CA+4vN7wPd0Av_sbtA0JD5y=fGcsuq20SOQVHWnE8BUFpDxOEXQ@mail.gmail.com> <CA+sTkh4fd+oZqagpHkGv5Kw+nkDyhunXfJm0tu0rqvuxVZBOyQ@mail.gmail.com> <CA+4vN7xH10qS-=OSS_3z3B3EohKHjk8-GBVvVfPj01TH-0pe3w@mail.gmail.com> <CA+sTkh7XeE49HmF+REyNTcOWJK6OS-tfi0qk7-SosFmAWenTqA@mail.gmail.com> <CA+4vN7x0f3f3=htC4iaPmDPqdviv8+AqAqY3sxKbP1X+89gtuQ@mail.gmail.com> <4FCEB515.5050209@fnarfbargle.com> <CA+4vN7y+W2y2bDWu4JH9KBLD+pP6DcCdRVf7mxQ_6us5EZ5yhw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+4vN7y+W2y2bDWu4JH9KBLD+pP6DcCdRVf7mxQ_6us5EZ5yhw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ole Tange <ole@tange.dk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 06/06/12 19:17, Ole Tange wrote:

> But if I try that setup on the test in RAM, md0_raid6 still takes up
> more CPU time than the checksumming would account for.

What part of "and shunting around blocks from 20 odd block devices, 
arranging them and checksumming them." are you missing?

The number your kernel gives you at bootup is to take a block of data 
and checksum it. In your real world results (in the same thread as the 
one doing the checksum) you are juggling the IO from all the disks, 
managing the buffers that result from that and calculating all the block 
positions. In what conceivable way can you conclude that a single thread 
can do all that and still give you the throughput the fabricated 
benchmark does?

>> Why not do as the man suggested and enable CONFIG_MULTICORE_RAID456 and see
>> what happens?
>
> It is a lot of work to put into testing something that is at best a guess.

Can lead a horse to water.

Regards,
Brad
