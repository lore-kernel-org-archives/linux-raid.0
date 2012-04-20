From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: [md PATCH 08/23] md: don't set md arrays to readonly on shutdown.
Date: Fri, 20 Apr 2012 17:26:34 +0100
Message-ID: <4F918E3A.8090506@anonymous.org.uk>
References: <20120314043555.7978.75486.stgit@notabene.brown> <20120314044040.7978.64156.stgit@notabene.brown> <CAGRgLy5UYf27335hQmEQQ8V2GSatQ-1aev9DdTia0j-Hv4wsEg@mail.gmail.com> <20120419084833.39379a6f@notabene.brown> <CAGRgLy6LXB34JtmfZYQEdAK4GLCV-hn-V8cT1zCwo_=ERyK90A@mail.gmail.com> <20120419195740.6e35ea02@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120419195740.6e35ea02@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Alexander Lyakas <alex.bolshoy@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 19/04/2012 10:57, NeilBrown wrote:
> On Thu, 19 Apr 2012 12:11:43 +0300 Alexander Lyakas<alex.bolshoy@gmail.com>
> wrote:
>
>> Hi Neil,
>> Thanks for the clarification.
>> However, from your commit message, it stems that during a normal
>> reboot (without -f -n), writes can still arrive after your reboot
>> notifier has cleaned the array. In such case, array might be dirty
>> after reboot. Is that so? If yes, then that's kind of regression.
>
> Why do you think that?
>
> I don't think that is the case.

That's what I had thought too, because in your original message 
describing the patch, you wrote:

> It seems that with recent kernel, writeback can still be happening
> while shutdown is happening, and consequently data can be written
> after the md reboot notifier switches all arrays to read-only.

I understand that to mean that someone somewhere has patched the kernel 
so that writes (writeback?) can still be happening after the array is 
supposed to be read-only. This sounds like a regression to me, though 
not one you have created.

Cheers,

John.

