From: Joe Landman <joe.landman@gmail.com>
Subject: Re: Have I any chance of restoring my Raid6 data?
Date: Sun, 16 Jul 2017 18:28:13 -0400
Message-ID: <56444baf-d0a9-13ab-6397-b5da7b9ed28a@gmail.com>
References: <90ab63b9-3a4b-06fa-d66b-d212ee4ae94f@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <90ab63b9-3a4b-06fa-d66b-d212ee4ae94f@gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: bogo.mipps@gmail.com, Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



On 07/16/2017 06:14 PM, Bogo Mipps wrote:
>
> Since then I've been unable to mount or access any data. Have followed 
> instructions as per Linux Raid Wiki's "Recovering a failed software 
> RAID" & "RAID Recovery" , but still no success. I've attached the 
> results of their suggestions in the attached log file 
> "linux_raid_wiki_logs.txt".

Why did you recreate the RAID (though you used --assume-clean) ? Did you 
try mounting it before that?

>
> Is there a chance of restoring my data?

Depends ... if you 'fsck -n /dev/md0' does it say there are errors?

>
> P.S. This line looks ominous? <md0: detected capacity change from 
> 4000528203776 to 0> !!!

That is because md0 was stopped.

-- 
Joe Landman
e: joe.landman@gmail.com
t: @hpcjoe
w: https://scalability.org
g: https://github.com/joelandman

