From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 0/2] Fix typo in RWH_WRITE_LIFE_NOT_SET constant name
Date: Thu, 25 Oct 2018 08:25:44 -0600
Message-ID: <8acaf8d7-17c9-e8ec-c60a-18a011b4c34f@kernel.dk>
References: <20181006175114.GA10435@asgard.redhat.com>
 <20181025141927.GB19512@asgard.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181025141927.GB19512@asgard.redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Eugene Syromiatnikov <esyr@redhat.com>, linux-kernel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Ingo Molnar <mingo@kernel.org>, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-raid.ids

On 10/25/18 8:19 AM, Eugene Syromiatnikov wrote:
> On Sat, Oct 06, 2018 at 07:51:14PM +0200, Eugene Syromiatnikov wrote:
>> Hello.
>>
>> This is a small fix of a typo (or, more specifically, some remnant of
>> the old patch version spelling) in RWH_WRITE_LIFE_NOT_SET constant,
>> which is named as RWF_WRITE_LIFE_NOT_SET currently.  Since the name
>> with "H" is used in man page and everywhere else, it's probably worth
>> to make the name used in the fcntl.h UAPI header in line with it.
>> Second follow-up patch updates (the sole) usage site of this constant
>> in kernel to use the new spelling.
>>
>> The old name is retained as it is part of UAPI now.
> 
> Hello, are there issues with the patches?

I only got the 0/2 patch, none of the two others..

-- 
Jens Axboe
