From: Phil Turmel <philip@turmel.org>
Subject: Re: How to recover after md crash during reshape?
Date: Wed, 21 Oct 2015 16:37:17 -0400
Message-ID: <5627F77D.1000600@turmel.org>
References: <04cdcd6bd69b3aa1f8f24465f8485c90@tantosonline.com>
 <874mhl2ed3.fsf@notabene.neil.brown.name> <56278284.5020306@turmel.org>
 <87k2qg0xz6.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87k2qg0xz6.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <nfbrown@novell.com>, andras@tantosonline.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/21/2015 04:26 PM, Neil Brown wrote:
> Phil Turmel <philip@turmel.org> writes:

>> Hmmm.  This feature has advanced beyond my last look at the code.  I was
>> under the impression the backup option was only optional when mdadm
>> could move the data offset.  Does this new algorithm apply to v0.90
>> metadata, a v3.2 kernel, and v3.2.5 mdadm?
>>
> 
> It isn't a new algorithm, it is the original algorithm.
> 
> In mdadm-2.4-pre1 (march 2006), you couldn't specify a backup file, but
> you could grow a raid5 to more devices.
> That was changed by a patch with comment:
> 
>     Allow resize to backup to a file.
>     
>     To support resizing an array without a spare, mdadm now understands
>       --backup-file=
>     which should point to a file for storing a backup of critical data.
>     This can be given to --grow which will create the file, or
>     --assemble which will restore from the file if needed.
>     
> The backup-file was subsequently used to support in-place reshapes and
> array shrinking.

Ah, ok.  I wasn't using parity raid that far back, and never noticed
that growing to more devices worked that way.

Thanks for clarifying.

Phil

