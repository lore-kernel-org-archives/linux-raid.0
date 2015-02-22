From: Joshua Kinard <kumba@gentoo.org>
Subject: Re: Metadata > 0.90 and auto-assemble
Date: Sun, 22 Feb 2015 16:54:12 -0500
Message-ID: <54EA5004.3090104@gentoo.org>
References: <54EA25D3.8020300@gentoo.org> <CAJCQCtSPPm3ipb49SCeNFvgQ21y4HseqovBPg28LKXzvP5PY8Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJCQCtSPPm3ipb49SCeNFvgQ21y4HseqovBPg28LKXzvP5PY8Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/22/2015 16:29, Chris Murphy wrote:
> On Sun, Feb 22, 2015 at 11:54 AM, Joshua Kinard <kumba@gentoo.org> wrote:
>> I'd like to
>> avoid this if possible, as I haven't had to use an initramfs for normal booting
>> in the past, as long as I stay on metadata 0.90.  So I thought I'd ask what the
>> official stance is on this.
> 
> https://raid.wiki.kernel.org/index.php/Autodetect
> 
> Official stance is that it's deprecated, but people still use it.

Yeah, but it's a pretty useful feature.  I can't see why autodetect for simple
setups (several disks or partitions and building a basic array out of them) is
maintained, while userspace autodetect is required for the more complex setups.

But I suppose this has been discussed before in detail, though I cannot find
said discussion.  The RAID Boot page has this one example only:

"This approach can cause problems in several situations (imagine moving part of
an old array onto another machine before wiping and repurposing it: reboot and
watch in horror as the piece of dead array gets assembled as part of the
running RAID array, ruining it); kernel autodetect is correspondingly deprecated."

Which I find to be rather unconvincing.  The cited example is a fault of the
user not torching the superblock before moving the disks or trying to use
them...and I've done this to myself on several occasions.  mdadm --misc
--zero-superblock and 'dd' saved the day in less than ~30s.

Are there any other discussions that might be more convincing, or offer up
other points of view?  Perhaps there's a point I've yet to consider that might
be enlightening.

Thanks!,

-- 
Joshua Kinard
Gentoo/MIPS
kumba@gentoo.org
4096R/D25D95E3 2011-03-28

"The past tempts us, the present confuses us, the future frightens us.  And our
lives slip away, moment by moment, lost in that vast, terrible in-between."

--Emperor Turhan, Centauri Republic
