From: Joe Landman <joe.landman@gmail.com>
Subject: Re: Ok, dumb question time ...
Date: Fri, 08 Oct 2010 01:00:23 -0400
Message-ID: <4CAEA567.9050205@gmail.com>
References: <4CAE9C13.3060002@scalableinformatics.com> <20101008155448.19d46db6@notabene>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101008155448.19d46db6@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: landman@scalableinformatics.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/08/2010 12:54 AM, Neil Brown wrote:

>> This is quite disconcerting ... I thought it would be simple.
>
> It is.
>
> You want the array to think that it only has two devices?
>
>    mdadm --grow /dev/md0 --raid-devices=2

Very nice ... thanks!

