From: Maurice Hilarius <maurice@harddata.com>
Subject: Re: from 2x RAID1 to 1x RAID6 ?
Date: Tue, 07 Jun 2011 14:07:12 -0600
Message-ID: <4DEE84F0.2030205@harddata.com>
References: <4DEE6A11.1030205@xunil.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DEE6A11.1030205@xunil.at>
Sender: linux-raid-owner@vger.kernel.org
To: lists@xunil.at, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 6/7/2011 12:12 PM, Stefan G. Weichinger wrote:
> Greetings, could you please advise me how to proceed?
>
> On a server I have 2 RAID1-arrays, each consisting of 2 TB-drives:
>
> ..
>
> Now I would like to move things to a more reliable RAID6 consisting of
> all the four TB-drives ...
>
> How to do that with minimum risk?
>
> ..
> Maybe I overlook a clever alternative?

RAID 10 is as secure, and risk free, and much faster.
And will cause much less CPU load.

-- 
Cheers,
Maurice Hilarius
eMail: /mhilarius@gmail.com/
