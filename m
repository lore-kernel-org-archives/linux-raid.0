From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: ANNOUNCE: mdadm 3.2.4 - A tool for managing Soft RAID under Linux
Date: Tue, 15 May 2012 09:03:21 +0200
Message-ID: <4FB1FFB9.5090300@redhat.com>
References: <2598499.YYnUQlf0Se@localhost> <4FB16B68.3000201@redhat.com> <1714869.L4aqWfddyq@localhost> <4FB17212.3000308@redhat.com> <20120515073219.1275b10a@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120515073219.1275b10a@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: =?UTF-8?B?UGF3ZcWCIFNpa29yYQ==?= <pluto@agmk.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 05/14/12 23:32, NeilBrown wrote:
> On Mon, 14 May 2012 22:58:58 +0200 Jes Sorensen <Jes.Sorensen@redhat.com>
>> If you post a patch without including a proper commit message and
>> signed-off-by lines, which is standard practice, then that is equivalent
>> to you not having posted a patch in the first place.
>>
>> Don't blame others for not doing the basic work everybody else does when
>> posting patches. It really isn't hard to comply with the standard patch
>> posting rules!
> 
> I decided a better approach is just to refresh from upstream:
> 
>       http://gcc.gnu.org/svn/gcc/branches/cilkplus/include/sha1.h
>       http://gcc.gnu.org/svn/gcc/branches/cilkplus/libiberty/sha1.c
> 
> have been copied into mdadm with just a tiny change to not include config.h
> 
> Seems to work, and probably has the *right* fix.

I would tend to agree with you, if not we can hollor at the gcc guys :)

Cheers,
Jes


