From: John Hendrikx <hjohn@xs4all.nl>
Subject: Re: [PATCH 000 of 5] md: Introduction
Date: Mon, 23 Jan 2006 02:08:56 +0100
Message-ID: <43D42CA8.6060507@xs4all.nl>
References: <20060117174531.27739.patches@notabene>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060117174531.27739.patches@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, "Steinar H. Gunderson" <sgunderson@bigfoot.com>
List-Id: linux-raid.ids

NeilBrown wrote:
> In line with the principle of "release early", following are 5 patches
> against md in 2.6.latest which implement reshaping of a raid5 array.
> By this I mean adding 1 or more drives to the array and then re-laying
> out all of the data.
>   
I think my question is already answered by this, but...

Would this also allow changing the size of each raid device?  Let's say 
I currently have 160 GB x 6, could I change that to 300 GB x 6 or am I 
only allowed to add more 160 GB devices?

