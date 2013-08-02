From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: RFC swap over raid1
Date: Fri, 02 Aug 2013 02:46:16 -0500
Message-ID: <51FB63C8.2090300@hardwarefreak.com>
References: <CAH3kUhFoNKgHErujKuCLMvx_qbDa2dwhW+sMD=7W9W0hHTWB-w@mail.gmail.com> <51FAE985.1040809@redhat.com> <CAH3kUhH-uc-tXitqZ=xuUYz5A8GY_+dhy+LnvvZTR9gSUJ0Y4A@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAH3kUhH-uc-tXitqZ=xuUYz5A8GY_+dhy+LnvvZTR9gSUJ0Y4A@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: Doug Ledford <dledford@redhat.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 8/1/2013 9:01 PM, Roberto Spadim wrote:

> other point is... swap have a badblock feature? i think it's not
> linux-raid but linux-vm or something like it...
> for example if i'm using a disk and swap find a badblock, it will use
> it? does swap handle bad blocks?

I believe you're thinking of "mkswap -c":

"Check the device (if it is a block device) for bad blocks before
creating the swap area. If any are found, the count is printed."

This simply tells you if bad blocks are found during mkswap, and how
many.  It doesn't tell you the locations of the blocks nor attempt to
remap them.  It's informational only.  Remedial action is left to the user.

I'm not aware of any code in the mm or block layer that transparently
handles bad block management, nor code that simply tracks bad blocks to
avoid using them.  If there were such a patch, it would not apply simply
to swap, but to the entire block layer.  I've not heard of any such
thing in recent development.  If this was included in the block layer
you'd surely have seen emails about it on the linux-raid list, as the
current md code that deals with bad blocks would have needed rewriting
to interface with any new generic interface in the block layer.

So if you're worried about your swap partition sitting on potentially
bad blocks you'll want to have one form or another of redundant md
device sitting under that swap partition.

However, you stated you're using enterprise class drives.  These are
usually pretty good about remapping bad blocks on the fly, and have much
larger reserved block pools than consumer drives for remapping use, so
this may simply be a non-issue.

-- 
Stan

