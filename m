From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: [PATCH] Use new sb type
Date: Tue, 29 Jan 2008 18:08:43 -0500
Message-ID: <479FB1FB.6040500@tmr.com>
References: <Pine.LNX.4.64.0801281818430.1185@fbirervta.pbzchgretzou.qr> <479E1C95.1040008@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <479E1C95.1040008@dgreaves.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>
Cc: Jan Engelhardt <jengelh@computergmbh.de>, neilb@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

David Greaves wrote:
> Jan Engelhardt wrote:
>   
>> This makes 1.0 the default sb type for new arrays.
>>
>>     
>
> IIRC there was a discussion a while back on renaming mdadm options (google "Time
> to  deprecate old RAID formats?") and the superblocks to emphasise the location
> and data structure. Would it be good to introduce the new names at the same time
> as changing the default format/on-disk-location?
>   

Yes, I suggested some layout names, as did a few other people, and a few 
changes to separate metadata type and position were discussed. BUT, 
changing the default layout, no matter how "better" it seems, is trumped 
by "breaks existing setups and user practice." For all of the reasons 
something else is preferable, 1.0 *works*.

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


