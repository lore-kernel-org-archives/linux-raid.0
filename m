From: Jeremy Sanders <jeremy@jeremysanders.net>
Subject: Re: GPT on MD raid
Date: Mon, 18 Apr 2011 19:37:13 +0100
Message-ID: <4DAC84D9.8060406@jeremysanders.net>
References: <iohnsc$ggc$1@dough.gmane.org> <4DAC6B04.9030702@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DAC6B04.9030702@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 18/04/11 17:47, Phil Turmel wrote:
> On 04/18/2011 12:11 PM, Jeremy Sanders wrote:
>> Hi - I was thinking of using a GPT partition on top of a MD raid device. It
>> occurs to me that because GPT also puts data at the end of the device, it
>> might get confused if the raid device is resized by adding more drives, etc.
>>
>> Has anyone tried this? Should it work? How should the GPT header get moved
>> to the end of the raid device? Will parted fix it?
>
> I've parted fix cases of this in the past, but I don't know how robust it is.
>
>> Should I ditch this idea and delve into the complexities of LVM?
>
> Yes, in my not-entirely-humble opinion.  I suspect you'll find LVM isn't all that complex, at least if all you are trying to do is replace GPT.  And you get some serious advantages without extra effort, like non-contiguous volumes and snapshotting.
>
> While my copy of gparted won't work with it, there are gui tools to manage LVM.  I use kvpm on my gentoo/KDE laptop.

Thanks for all the replies - I will look at lvm...

Jeremy
