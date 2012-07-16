From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: Re: On mdadm 3.2 and bad-block-log
Date: Mon, 16 Jul 2012 12:08:38 +0300
Message-ID: <CAGRgLy5x6dtHGDg7D8O6W63DeEVUbZ_mB8JQ4RBMqyNe5Cqf4g@mail.gmail.com>
References: <4FD7738D.3040403@shiftmail.org>
	<CAGRgLy5Eryf_kT69a3SSPi8-MVpVmhEL96tNWJZQd9-vf4iYZQ@mail.gmail.com>
	<20120716134138.0f1c9cfc@notabene.brown>
	<5003C5BC.3070609@shiftmail.org>
	<CAGRgLy6udWWhYn_UEwyyVrKsV5auAdfN5qkLVxbNnVqgWE=+UQ@mail.gmail.com>
	<5003D73B.3010609@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5003D73B.3010609@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: Asdo <asdo@shiftmail.org>
Cc: linux-raid <linux-raid@vger.kernel.org>, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

That's not what I was saying. The mdadm code to support bad blocks is
really one or two lines. The rest is in the kernel. (On the other
hand, the mdadm version which has those one or two lines is about a
year behind the mainline mdadm, so it lacks many other
things/fixes/improvements, but that's a different issue).

Yes, the kernel code is out, but as Neil pointed out, it might still
have some glitches. Since mdadm that supports bad-blocks is not out
yet, you have no (official) way to create an array with bad-blocks
support. So you should not suffer from those glitches.

Alex.


On Mon, Jul 16, 2012 at 11:56 AM, Asdo <asdo@shiftmail.org> wrote:
> Right, that's the reason of my question.
> Neil wrote "I probably don't want to rush it out" so that would mean that
> the buggy code is not "out" yet.
> So that would point to mdadm-3.3 because the bad block code of the kernel is
> already "out".
> However as you say the bad block code in mdadm-3.3 is very simple so it's
> strange that it could be buggy.
>
> Now thinking at myself: if there were bugs in the mdadm-3.3 I probably have
> dodged them because I was able to create the array.
> However if there are known bugs in the kernel code our data is still at risk
> so i'd rather ask.
> FWIW I am not using mdadm-3.3 as monitoring daemon: the daemon is mdadm-3.2
> , I don't know if this "helps".
>
> Thank you
> A.
>
>
>
> On 07/16/12 09:55, Alexander Lyakas wrote:
>>
>> The mdadm code only reserves some space for bad-blocks log and
>> notifies the kernel that this feature is enabled during array
>> creation.
>>
>> On Mon, Jul 16, 2012 at 10:41 AM, Asdo<asdo@shiftmail.org>  wrote:
>>>
>>> On 07/16/12 05:41, NeilBrown wrote:
>>>>
>>>> and as the bad block code is
>>>> clearly still buggy, I probably don't want to rush it out :-)
>>>
>>>
>>> The bad block code is buggy... the one in the kernel or the one in
>>> mdadm-3.3
>>> ?
>>> 'cause I am currently using an array created with bad block log on kernel
>>> 3.4.3...
>>>
>>> Thanks
>
>
