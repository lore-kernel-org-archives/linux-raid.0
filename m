From: Michal Soltys <msoltyspl@yandex.pl>
Subject: Re: [general question] rare silent data corruption when writing data
Date: Wed, 20 May 2020 22:29:29 +0200
Message-ID: <3e3dbd06-a425-59bd-5ce8-e66b5406eb80@yandex.pl>
References: <b0e91faf-3a14-3ac9-3c31-6989154791c1@yandex.pl>
 <20200513063127.GA2769@onthe.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200513063127.GA2769@onthe.net.au>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Chris Dunlop <chris@onthe.net.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 20/05/13 08:31, Chris Dunlop wrote:
> Hi,
> 
> 
> "Me too!"
> 
> We are seeing 256-byte corruptions which are always the last 256b of a 
> 4K block. The 256b is very often a copy of a "last 256b of 4k block" 
> from earlier on the file. We sometimes see multiple corruptions in the 
> same file, with each of the corruptions being a copy of a different 256b 
> from earlier on the file. The original 256b and the copied 256b aren't 
> identifiably at a regular offset from each other. Where the 256b isn't a 
> copy from earlier in the file
> 
> I'd be really interested to hear if your problem is just in the last 
> 256b of the 4k block also!

 From what I have checked - in my case it has always been full 4k page.

I'll follow the suggestion by Sarah in the other part of this thread and 
enable pagealloc debug options and then put the machine/disks under load 
- so I'll keep an eye if something like you described happens.

This will have to wait a bit though, as I have another bug to hunt as 
well - as journaled raid refuses to assemble, so with help of Song I'm 
chasing that issue first.

If not for btrfs, we probably would have been using the machine happily 
until now (blaming occasional detected issues on userspace stuff, 
usually some fat java mess).

Thanks for detailed explanations of what happened in your case (and the 
span of kernel versions in which it does happen is scary). The hardware 
indeed looks strikingly similiar.
