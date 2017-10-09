From: "John Stoffel" <john@stoffel.org>
Subject: Re: mdadm: Patch to restrict --size when shrinking unless forced
Date: Sun, 8 Oct 2017 21:22:27 -0400
Message-ID: <23002.53075.413063.6948@quad.stoffel.home>
References: <22997.8664.67459.119616@quad.stoffel.home>
        <87a81637lq.fsf@notabene.neil.brown.name>
        <23002.37193.492253.120639@quad.stoffel.home>
        <87shetz207.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87shetz207.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: John Stoffel <john@stoffel.org>, Eli Ben-Shoshan <eli@benshoshan.com>, Jes.Sorensen@gmail.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>>>> "NeilBrown" == NeilBrown  <neilb@suse.com> writes:

NeilBrown> On Sun, Oct 08 2017, John Stoffel wrote:
>>>>>>> "NeilBrown" == NeilBrown  <neilb@suse.com> writes:
>> 
NeilBrown> On Wed, Oct 04 2017, John Stoffel wrote:
>>>> Since Eli had such a horrible experience where he shrunk the
>>>> individual component raid device size, instead of growing the overall
>>>> raid by adding a device, I came up with this hacky patch to warn you
>>>> when you are about to shoot yourself in the foot.
>>>> 
>>>> The idea is it will warn you and exit unless you pass in the --force
>>>> (or -f) switch when using the command.  For example, on a set of loop
>>>> devices:
>>>> 
>>>> # cat /proc/mdstat
>>>> Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5]
>>>> [raid4] [multipath] [faulty]
>>>> md99 : active raid6 loop4p1[4] loop3p1[3] loop2p1[2] loop1p1[1]
>>>> loop0p1[0]
>>>> 606720 blocks super 1.2 level 6, 512k chunk, algorithm 2 [5/5]
>>>> [UUUUU]
>>>> 
>>>> # ./mdadm --grow /dev/md99 --size 128
>>>> mdadm: Cannot set device size smaller than current component_size of /dev/md99 array.  Use -f to force change.
>>>> 
>>>> # ./mdadm --grow /dev/md99 --size 128 -f
>>>> mdadm: component size of /dev/md99 has been set to 0K
>>>> 
>> 
NeilBrown> I'm not sure I like this.
NeilBrown> The reason that mdadm will quietly accept a size change like this is
NeilBrown> that it is trivial to revert - just set the same to a big number and all
NeilBrown> your data is still there.
>> 
>> This is wrong, because if you use --grow --size ### with a small
>> enough number, it destroys the MD raid superblock.

NeilBrown> If that is true, then it is a kernel bug and should be fixed in the kernel.

I just remembered another point I wanted to make.  The earliest we get
such a change into the kernel is 4.15, and then maybe back ported into
some number of stable kernels.  But by putting this check into mdadm
as well, we can protect people running older kernels as well.  It
seems to me like a good arguement for fixing mdadm to:

- adding the --grow --Force ... option.
- fixing the size check so you don't destroy the MD superblock even
  with --Force.
- reporting to the user the pre- and post- size of array components
  when using --grow --size ##

Thanks,
John
