From: Rudy Zijlstra <rudy@grumpydevil.homelinux.org>
Subject: Re: raid array with 3T disks and GPT partition
Date: Thu, 01 Sep 2011 21:13:55 +0200
Message-ID: <4E5FD973.4000208@grumpydevil.homelinux.org>
References: <20110901154759.GA32649@apartia.fr> <20110901155913.GA20825@cthulhu.home.robinhill.me.uk> <20110901163334.GA13347@apartia.fr> <4E5FB8EC.5040801@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E5FB8EC.5040801@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


>> However lilo won't boot on anything other than 0.9, this I found the
>> hard way :)
>
> Lilo should be able to boot on version 1.0 arrays too.  It's just 
> version 1.1 and 1.2 arrays that kill lilo.  But, then again, lilo is 
> so long since dead that one has to wonder why you are still using it.
>
At least lilo has an understandable way of working. grub2 is just.... a 
big pain in the *ass as far as i am concerned.
