From: "Marc" <linux-raid@liquid-nexus.net>
Subject: Re: where is the spare drive? :-)
Date: Thu, 5 Jan 2006 14:16:08 +0800
Message-ID: <20060105061133.M54165@liquid-nexus.net>
References: <02a801c60f2a$de619ce0$a400a8c0@dcccs>
Mime-Version: 1.0
Content-Type: text/plain;
	charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <02a801c60f2a$de619ce0$a400a8c0@dcccs>
Sender: linux-raid-owner@vger.kernel.org
To: JaniD++ <djani22@dynamicweb.hu>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 2 Jan 2006 00:26:58 +0100, JaniD++ wrote
> Hello, list,
> 
> I found something interesting when i try to create a brand new array 
> on brand new drives....
> 

<snip>

> 5. The question
> 
> Why shows sdh2 as spare?
> The MD array size is correct.
> And i really can see, the all drive is reading, and sdh2 is *ONLY* writing.
> 

I'm not 100% sure but from a post by Neil a while a go on the list, the spare
device is a temporary construct created during the resync operation. Once the
resync is complete it should disappear. 

You could try searching the list archives for the post - choice of keywords is
up to you ;)

Regards,
Marc

