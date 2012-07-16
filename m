From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: Re: On mdadm 3.2 and bad-block-log
Date: Mon, 16 Jul 2012 10:55:40 +0300
Message-ID: <CAGRgLy6udWWhYn_UEwyyVrKsV5auAdfN5qkLVxbNnVqgWE=+UQ@mail.gmail.com>
References: <4FD7738D.3040403@shiftmail.org>
	<CAGRgLy5Eryf_kT69a3SSPi8-MVpVmhEL96tNWJZQd9-vf4iYZQ@mail.gmail.com>
	<20120716134138.0f1c9cfc@notabene.brown>
	<5003C5BC.3070609@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5003C5BC.3070609@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: Asdo <asdo@shiftmail.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

The mdadm code only reserves some space for bad-blocks log and
notifies the kernel that this feature is enabled during array
creation.

On Mon, Jul 16, 2012 at 10:41 AM, Asdo <asdo@shiftmail.org> wrote:
> On 07/16/12 05:41, NeilBrown wrote:
>>
>> and as the bad block code is
>> clearly still buggy, I probably don't want to rush it out :-)
>
>
> The bad block code is buggy... the one in the kernel or the one in mdadm-3.3
> ?
> 'cause I am currently using an array created with bad block log on kernel
> 3.4.3...
>
> Thanks
