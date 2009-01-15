From: David Greaves <david@dgreaves.com>
Subject: Re: Interesting article
Date: Thu, 15 Jan 2009 22:31:59 +0000
Message-ID: <496FB95F.7060503@dgreaves.com>
References: <496E44DE.7090200@harddata.com> <f3177b9e0901141455i460f09cs69e38e24842e9c62@mail.gmail.com> <496F194C.2050002@dgreaves.com> <496FB50A.4040600@ziu.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <496FB50A.4040600@ziu.info>
Sender: linux-raid-owner@vger.kernel.org
To: Michal Soltys <soltys@ziu.info>
Cc: Chris Worley <worleys@gmail.com>, Maurice Hilarius <maurice@harddata.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Michal Soltys wrote:
> David Greaves wrote:
>>
>> Agreed - and I think another huge gap is that when you lose a block
>> you really
>> should be able to find out what file was affected. Doable on ext3 but not
>> (AFAIK) xfs.
>>
> 
> It's doable on xfs as well.
> 
> http://oss.sgi.com/archives/xfs/2008-10/msg01448.html <- two methods in
> that thread.
> 
> On related note - if there's a mismatch on some stripe under linux's md
> - is there any way to pinpoint which stripe exactly (or what blocks
> correspond to fixed/checked stripe) ?
> 
> ITOW - is there anything besides mismatch_cnt ?

Thanks, I'll take a look at that - first glance says that it's not exactly
end-user material!

David


-- 
"Don't worry, you'll be fine; I saw it work in a cartoon once..."
