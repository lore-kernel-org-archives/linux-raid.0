From: Asdo <asdo@shiftmail.org>
Subject: Re: First raid1 sector gets zeroed at first reboot
Date: Wed, 17 Aug 2011 16:00:13 +0200
Message-ID: <4E4BC96D.1020802@shiftmail.org>
References: <4E4AABF6.2070800@shiftmail.org> <4E4BC586.10109@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <4E4BC586.10109@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 08/17/11 15:43, John Robinson wrote:
>
> The first sector of a md RAID with metadata 1.0 is in its data area, 
> so there's no way md is writing to this area itself, it's almost 
> certainly the filesystem that's writing it.
>
> I think installing grub on a md partition is a bad idea. You can use 
> metadata 1.2 to have the first 4K left free, but grub may write its 
> stage 1.5 code to the first 31.5K of a device (whole drive or partition).
>

No you are confusing it with metadata 1.1 .
Metadata 1.0 has the data at the end like 0.9 .
Writing there is semantically correct.

Thank you
