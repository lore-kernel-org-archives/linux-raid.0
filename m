From: Brian Candler <b.candler@pobox.com>
Subject: Re: Problem diagnosing rebuilding raid5 array
Date: Tue, 15 Oct 2013 13:50:47 +0100
Message-ID: <525D3A27.7070301@pobox.com>
References: <20131014123104.77620e8uy2pe0214@phobos.elinuxservers.com> <525C29CD.4080604@pobox.com> <20131015084037.10297bo5940ryklk@phobos.elinuxservers.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20131015084037.10297bo5940ryklk@phobos.elinuxservers.com>
Sender: linux-raid-owner@vger.kernel.org
To: peter@steinhoff.se
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 15/10/2013 13:40, peter@steinhoff.se wrote:
>
> On another note, I took the failed drive I replaced in my array 
> (/dev/sdh) and put it in another machine (win7) and run Western 
> Digital's diagnosis software and it says the drive is OK.
>
Another type of drive test you can do is with smartctl:

smartctl -t conveyance /dev/sdX
... typically takes a couple of minutes
smartctl -l selftest /dev/sdX   # to monitor progress / completion

smartctl -t long /dev/sdX
... typically takes 6 hours on a 3TB drive
smartctl -l selftest /dev/sdX   # to monitor progress / completion

Regards,

Brian.

