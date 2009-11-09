From: John Hughes <john@Calva.COM>
Subject: Re: MD performance options: More =?windows-1252?Q?CPU=92s_or_?=
 =?windows-1252?Q?more_Hz=92s=3F?=
Date: Mon, 09 Nov 2009 18:37:16 +0100
Message-ID: <4AF8534C.3030304@Calva.COM>
References: <66781b10911040149q165edf1s94a86f179f9af9fc@mail.gmail.com> <4AF18A39.6010404@tmr.com> <4AF19216.30300@Calva.COM> <4AF8505D.9060007@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AF8505D.9060007@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: mark delfman <markdelfman@googlemail.com>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Bill Davidsen wrote:
> John Hughes wrote:
>> An external journal can be a huge win for ext3 if you are doing lots 
>> of file creates/deletes.  (Striped raid, i.e. 
>> raid0/raid5/raid6/raid10 doesn't help the journal much as it is used 
>> sequentially.  In my tests putting the journal on a raid1 and the 
>> rest of the fs on a raid10 makes things go much faster.  If you have 
>> enough disks of course :-))
>
> You might try mounting with data=journal and see what performance you 
> get with small reads and writes. Might surprise you. I hadn't thought 
> of using raid1 (or raid0 if speed is more important than survival), 
> but I have been playing with using SSD just for the journal. As you 
> say, when you do lots of creates or deletes it makes a big difference.
Yup, data=journal will be in the next tests I do.


