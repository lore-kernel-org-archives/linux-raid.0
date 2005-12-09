From: Mike Hardy <mhardy@h3c.com>
Subject: Re: mdadm source rpm build error + command-line parsing error + resync
 reporting problem
Date: Thu, 08 Dec 2005 21:43:41 -0800
Message-ID: <4399198D.5050206@h3c.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Neil Brown wrote:

>>The man page indicates that if I don't set the size, it will grow to
>>fill the smallest device in the array. It's definitely not doing
>>that...
> 
> 
> Could you please point me to the part of the man page that says that?
> I will try to fix it.

I see what you mean now - I got confused because there are two
paragraphs in the size option description, one indicates that you don't
need to set it, then the second paragraph discusses the "grow" context
and indicates you can use 'max'.

The first paragraph doesn't indicate a specific context, so I took it to
cover all possible contexts where 'size' was applicable, and it seems
like it isn't

I did successfully grow my md arrays though, which was nice, but then
ext2online didn't do what I asked it to do, and now I'm back to just
doing the more typical dump/restore thing anyway.

Not really on-topic, but has anyone else gotten ext2online to work? I
get this "Dec  8 21:27:02 istanbul kernel: JBD: ext2online wants too
many credits (2050 > 2048)" after letting it attempt to extend the FS to
cover the entire device.

-Mike

