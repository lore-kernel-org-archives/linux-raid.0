From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Size limitation?
Date: Mon, 04 Jan 2010 00:29:26 +0000
Message-ID: <4B413666.5030907@anonymous.org.uk>
References: <g40gloecsm81fex9s1UYAxe124vaj_firegpg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <g40gloecsm81fex9s1UYAxe124vaj_firegpg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: mjevans1983@gmail.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 03/01/2010 23:34, mjevans1983@gmail.com wrote:
> On Sun, Jan 3, 2010 at 12:33 PM, Andre Noll <maan@systemlinux.org> wrote:
>> On 00:30, Zdenek Behan wrote:
>>> On 01/01/2010 08:57 PM, Michael McLagan wrote:
>>> >    I'm trying to set up a large array but isn't working.  I tried
>>> > Googling size limits, etc and came up empty.
[...]
>> Jup, missing LBD support would explain what Michael is seeing. That
>> begs the question why md happily creates arrays > 2T on a kernel
>> witout LBD support..
> 
> There are two Michael's here, I'm not the one that that had this issue 

I don't think there was any need to point this out; Andre wasn't quoting 
your reply to the thread and he did quote the Michael he was referring to.

Cheers,

John.

