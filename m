From: Bogo Mipps <bogo.mipps@gmail.com>
Subject: Re: Have I any chance of restoring my Raid6 data?
Date: Wed, 19 Jul 2017 14:01:49 +1200
Message-ID: <0b776537-739d-eaec-fd22-0b53c0c32159@gmail.com>
References: <90ab63b9-3a4b-06fa-d66b-d212ee4ae94f@gmail.com>
 <56444baf-d0a9-13ab-6397-b5da7b9ed28a@gmail.com>
Reply-To: bogo.mipps@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <56444baf-d0a9-13ab-6397-b5da7b9ed28a@gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Joe Landman <joe.landman@gmail.com>, Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 07/17/2017 10:28 AM, Joe Landman wrote:

> Why did you recreate the RAID (though you used --assume-clean) ? Did you 
> try mounting it before that?

Yes, and data appeared to be missing

>> Is there a chance of restoring my data?
> 
> Depends ... if you 'fsck -n /dev/md0' does it say there are errors?

Yes.  Unsuccessful.  Could find no superblocks, hence no ability to check.

>>
>> P.S. This line looks ominous? <md0: detected capacity change from 
>> 4000528203776 to 0> !!!
> 
> That is because md0 was stopped.

Ah - thanks. Your input appreciated. Not looking good, having now 
followed Peter's post.


