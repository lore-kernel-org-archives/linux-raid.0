From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: PULL REQUEST - serious md/RAID10 bug in 3.1 when activating a
 hot-spare.
Date: Mon, 31 Oct 2011 13:34:10 +0800
Message-ID: <4EAE3352.8090409@fnarfbargle.com>
References: <20111031130859.121d5620@notabene.brown> <4EAE2C62.3030506@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4EAE2C62.3030506@fnarfbargle.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 31/10/11 13:04, Brad Campbell wrote:
> On 31/10/11 10:08, NeilBrown wrote:
>>
>> Hi Linus et al,
>>
>> I just discovered a fairly serious flaw that I introduced into 3.1 -
>> details
>> below.
>>
>> Anyone running RAID10 with 3.1 is advised to either apply this patch or
>> revert an earlier kernel as soon as possible. In the mean time, remove
>> any
>> hot spares from an RAID10 array.
>>
>
> G'day Neil,
>
> Is that the issue I bumped up against here?
>
> http://permalink.gmane.org/gmane.linux.raid/35805

After looking closer I can confirm that making the indicated change 
resolves this problem.

Regards,
Brad
