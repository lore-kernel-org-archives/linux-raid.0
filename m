From: Asdo <asdo@shiftmail.org>
Subject: Re: On mdadm 3.2 and bad-block-log
Date: Mon, 16 Jul 2012 10:56:27 +0200
Message-ID: <5003D73B.3010609@shiftmail.org>
References: <4FD7738D.3040403@shiftmail.org>
 <CAGRgLy5Eryf_kT69a3SSPi8-MVpVmhEL96tNWJZQd9-vf4iYZQ@mail.gmail.com>
 <20120716134138.0f1c9cfc@notabene.brown> <5003C5BC.3070609@shiftmail.org>
 <CAGRgLy6udWWhYn_UEwyyVrKsV5auAdfN5qkLVxbNnVqgWE=+UQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <CAGRgLy6udWWhYn_UEwyyVrKsV5auAdfN5qkLVxbNnVqgWE=+UQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Lyakas <alex.bolshoy@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

Right, that's the reason of my question.
Neil wrote "I probably don't want to rush it out" so that would mean 
that the buggy code is not "out" yet.
So that would point to mdadm-3.3 because the bad block code of the 
kernel is already "out".
However as you say the bad block code in mdadm-3.3 is very simple so 
it's strange that it could be buggy.

Now thinking at myself: if there were bugs in the mdadm-3.3 I probably 
have dodged them because I was able to create the array.
However if there are known bugs in the kernel code our data is still at 
risk so i'd rather ask.
FWIW I am not using mdadm-3.3 as monitoring daemon: the daemon is 
mdadm-3.2 , I don't know if this "helps".

Thank you
A.


On 07/16/12 09:55, Alexander Lyakas wrote:
> The mdadm code only reserves some space for bad-blocks log and
> notifies the kernel that this feature is enabled during array
> creation.
>
> On Mon, Jul 16, 2012 at 10:41 AM, Asdo<asdo@shiftmail.org>  wrote:
>> On 07/16/12 05:41, NeilBrown wrote:
>>> and as the bad block code is
>>> clearly still buggy, I probably don't want to rush it out :-)
>>
>> The bad block code is buggy... the one in the kernel or the one in mdadm-3.3
>> ?
>> 'cause I am currently using an array created with bad block log on kernel
>> 3.4.3...
>>
>> Thanks

