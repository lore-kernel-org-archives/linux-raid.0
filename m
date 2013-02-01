From: Phil Turmel <philip@turmel.org>
Subject: Re: Raid 5 to 6 migration
Date: Fri, 01 Feb 2013 13:22:50 -0500
Message-ID: <510C07FA.4090405@turmel.org>
References: <BLU0-SMTP433B0BCF64D448CC81098D2C91C0@phx.gbl>,<510C0075.9010908@turmel.org> <COL114-W137DD8871889508BBF087BC91C0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <COL114-W137DD8871889508BBF087BC91C0@phx.gbl>
Sender: linux-raid-owner@vger.kernel.org
To: "Dominique C." <dcouot@hotmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Dominique,

[Top-posting repaired.  Please don't]

On 02/01/2013 01:19 PM, Dominique C. wrote:
[trim /]

>>> I was wondering what would be the best way to convert a 6 hdd raid 5 to
>>> raid 6. Ideally without having to reformat everything and lose all the
>>> data in the process. I have backups of the data but I don't look forward
>>> reinstalling everything on that server.
>>
>> 1) Add a seventh drive to the system.
>>
>> You can do this on the run if you have hotplug-capable sata ports or sas
>> ports.
>>
>> 2) Add that drive to the array w/ "mdadm --add"
>> 3) Convert array to raid6 w/ "mdadm --grow --level=raid6"
>>
>> You can do 2 & 3 on the run.
>>
>> 4) Monitor /proc/mdstat to see when it finishes.

> Hi Phil,
>
> Thanks for your answer, however I forgot to mention one thing: I used
6 hdd out of 6 possible. No possibility to expand at this stage....
> The data only uses part of the space available.
> Any other ideas ?

Shrinking is usually possible, but there are many more steps, depending
on what is in the array.

Please provide more detail.  The output of "lsdrv"[1] might be a good start.

Phil

[1] http://github.com/pturmel/lsdrv

