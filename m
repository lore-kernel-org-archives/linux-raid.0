From: antlists <antlists@youngman.org.uk>
Subject: Re: Grow array and convert from raid 5 to 6
Date: Sun, 1 Mar 2020 19:07:56 +0000
Message-ID: <fa393999-3f56-0bcf-b097-462a209f1eae@youngman.org.uk>
References: <CALc6PW7C30Z6bccQLXLPf8zYuM=aBVZ_hLgW3i5gqZFVsLRpfA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CALc6PW7C30Z6bccQLXLPf8zYuM=aBVZ_hLgW3i5gqZFVsLRpfA@mail.gmail.com>
Content-Language: en-GB
Sender: linux-raid-owner@vger.kernel.org
To: William Morgan <therealbrewer@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 01/03/2020 18:07, William Morgan wrote:
> I have a healthy 4 disk raid 5 array (data only, non booting) that is
> running out of space. I'd like to add 4 more disks for additional
> space, as well as convert to raid 6 for additional fault tolerance.
> I've read through the wiki page on converting an existing system, but
> I'm still not sure how to proceed. Can anyone outline the steps for
> me? Thanks for your help.

> Looks like you looked at the wrong section ... :-) Look at "a guide to mdadm".

The subsection "upgrading a mirror raid to a parity raid" contains the 
information you need, just not laid out nicely for you.

You want to "grow" your raid, and you could do it in one hit, or in 
several steps. I'd probably add the drives first, "--grow --add disk1 
--add disk2 ..." to give an array with 4 active drives and 4 spares. 
Then you can upgrade to raid 6 - "--grow --level=6 --raid-devices=8".

> A little bit of advice - MAKE SURE you have the latest mdadm, and if 
> possible an up-to-date kernel. What mdadm and kernel do you have?

If your kernel/mdadm is older, the reshape might hang at 0%. The easiest 
fix is to reboot into an up-to-date rescue disk and re-assemble the 
array, at which point it'll kick off fine. The only snag, of course, is 
that means your system is not available for normal use until the reshape 
is complete and you can reboot back into your normal setup.

Cheers,

Wol
