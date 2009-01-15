From: Michal Soltys <soltys@ziu.info>
Subject: Re: Interesting article
Date: Thu, 15 Jan 2009 23:13:30 +0100
Message-ID: <496FB50A.4040600@ziu.info>
References: <496E44DE.7090200@harddata.com> <f3177b9e0901141455i460f09cs69e38e24842e9c62@mail.gmail.com> <496F194C.2050002@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <496F194C.2050002@dgreaves.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>
Cc: Chris Worley <worleys@gmail.com>, Maurice Hilarius <maurice@harddata.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

David Greaves wrote:
> 
> Agreed - and I think another huge gap is that when you lose a block you really
> should be able to find out what file was affected. Doable on ext3 but not
> (AFAIK) xfs.
> 

It's doable on xfs as well.

http://oss.sgi.com/archives/xfs/2008-10/msg01448.html <- two methods in
that thread.

On related note - if there's a mismatch on some stripe under linux's md 
- is there any way to pinpoint which stripe exactly (or what blocks 
correspond to fixed/checked stripe) ?

ITOW - is there anything besides mismatch_cnt ?
