From: "NeilBrown" <neilb@suse.de>
Subject: Re: >16TB RAID0
Date: Sat, 18 Jul 2009 10:13:55 +1000 (EST)
Message-ID: <bcd208d4a52b6706193626667237b729.squirrel@neil.brown.name>
References: <150c16850907162036w44a13b3dn6d6039a8960ed141@mail.gmail.com>
    <88b4380a1bcd5fd15556fd1d4454565a.squirrel@neil.brown.name>
    <150c16850907171247u24b7919el33794f72e3d0008c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <150c16850907171247u24b7919el33794f72e3d0008c@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Maggard <jmaggard10@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, July 18, 2009 5:47 am, Justin Maggard wrote:
> On Thu, Jul 16, 2009 at 8:59 PM, NeilBrown<neilb@suse.de> wrote:
>> I'm not 100% sure, but a quick look at the code suggests that
>> 16TB is the upper limit for normal read/write operations on
>> a block device like /dev/md0 on a 32bit host. =A0This is because it =
uses
>> the page cache, and that uses 4K pages with a 32bit index, hence
>> 16TB.
>
> Yep, you're right.  Sorry, I should have looked more into that first.
> I was assuming LBD took care of that somehow, because the kernel docs
> just say that LBD allows it to go over 2TB, and doesn't mention the
> new 16TB upper limit.
>
>> However this doesn't explain why it seems to work for RAID5. =A0If I
>> am right, RAID5 should fail in the same way as RAID0.
>> But I would certainly expect RAID0 to work if anything does.
>>
>
> And again you're correct.  It eventually failed the comparison on
> RAID5.  But it failed in a much different way on RAID5 than RAID0 for
> some reason.  The same disk set on an x86_64 machine appears to be
> working fine.  Sorry for the false alarm.  So I guess now my question
> is, should the kernel and/or mdadm refuse to create or run a >16TB
> array on a 32-bit kernel? :)

I'm not sure that refusal is appropriate as there might be some use
cases that work perfectly.
Emitting a warning my be a good idea though, and possibly disabling
some of the use cases that are known to be unreliable.

Thanks,
NeilBrown

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
