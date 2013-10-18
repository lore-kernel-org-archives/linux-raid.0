From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: raid5 trim OOPS / use after free?
Date: Fri, 18 Oct 2013 08:05:07 +0200
Message-ID: <wrfjob6ndsh8.fsf@redhat.com>
References: <CE8692DA.64C5%shli@fusionio.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CE8692DA.64C5%shli@fusionio.com> (Shaohua Li's message of "Thu,
	17 Oct 2013 23:30:31 +0000")
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <ShLi@fusionio.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, NeilBrown <neilb@suse.de>, Jeff Moyer <jmoyer@redhat.com>
List-Id: linux-raid.ids

Shaohua Li <ShLi@fusionio.com> writes:
> On 10/18/13 5:58 AM, "Jes Sorensen" <Jes.Sorensen@redhat.com> wrote:
>
>>Hi,
>>
>>I have been trying out the trim code in recent kernels and I am
>>consistently seeing crashes with the raid5 trim implementation.
>>
>>I am seeing 3-4 different OOPS outputs which are very different in their
>>output. This makes me suspect this is a memory corruption of use after
>>free problem?
>>
>>Basically I have a system with an AHCI controller and 4 SATA SSD drives
>>hooked up to it. I create a raid5 and then run mkfs.ext4 on it and the
>>fireworks display starts.
>>
>>I first saw this with an older kernel with some backports applied, but I
>>am able to reproduce this with the current top of tree out of Linus'
>>tree.
>>
>>Any ideas?
>
> The raid5 trim support is in upstream since v3.7, can you please try an
> old kernel to check if this is a regression? For example, 3.11, 3.10?
> Looks we have some problems with discard request payload from the oops log.

I went as far back and explicitly checked out the git commit that
introduced raid5 trim support:

git checkout 620125f2bf8ff0c4969b79653b54d7bcc9d40637

Same problem there.

Regards,
Jes
