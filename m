From: Arka Sharma <arka.sw1988@gmail.com>
Subject: Re: Fwd: Re: mdadm I/O error with Ddf RAID
Date: Tue, 22 Nov 2016 15:00:20 +0530
Message-ID: <CAPO=kN1kn4voZpzhD4spYY3+X=6tVWdZSbvD=41zJWr7J2pSSA@mail.gmail.com>
References: <CAPO=kN2QDLEMgo9p9pU3=MeLQ=J6R8eeDL1Pw9m2pHjbVsuFGg@mail.gmail.com>
 <874m3ak3ci.fsf@notabene.neil.brown.name> <CAPO=kN3psOzSYzbKZ5dAGK5uEk3JfTSf-Ec+S_UTL0iaD78Pdg@mail.gmail.com>
 <87oa1ehd06.fsf@notabene.neil.brown.name> <CAPO=kN2NwC1nZKzmWCEzkxN=OZrYOJFOq__pttqfiLWo-4fJSw@mail.gmail.com>
 <CAPO=kN3pSizni=e3N3zxktSjQWsRL7T_GwZJdUUyKzCjM-0MWw@mail.gmail.com> <87polocrsv.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87polocrsv.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have observed that following block
else if (!mddev->bitmap)
                        j = mddev->recovery_cp;
is getting executed in md_do_sync. I performed to test. In case 1 I
filled the entire 32 mb of physical disks with FF and then wrote the
metadata. And in the following case we filled the 32 mb with zeros and
then wrote the metadata. In both the cases we receive md/raid1:md126:
not clean -- starting background reconstruction message from md when
there is access to LBA 1000182866. However when I create raid 1 using
mdadm and reboot the system there is no access to  LBA 1000182866.
Also when I read that sector after creating raid 1 with mdadm we see
this block contains FF. As we have confirmed that mdadm also writing
the config data at 1000182610. Only in case of raid created through
our application results access at that offset.

Regards,
Arka

On Tue, Nov 22, 2016 at 5:24 AM, NeilBrown <neilb@suse.com> wrote:
> On Tue, Nov 22 2016, Arka Sharma wrote:
>
>> ---------- Forwarded message ----------
>> From: "Arka Sharma" <arka.sw1988@gmail.com>
>> Date: 21 Nov 2016 12:57 p.m.
>> Subject: Re: mdadm I/O error with Ddf RAID
>> To: "NeilBrown" <neilb@suse.com>
>> Cc: <linux-raid@vger.kernel.org>
>>
>> I have run mdadm --examine on both the component devices as well as on
>> the container. This shows that one of the component disk is marked as
>> offline and status is failed. When I run mdadm --detail on the RAID
>> device it shows the component disk 0 state as removed. Since I am very
>> much new to md and linux in general I am not able to fully root cause
>> this issue. I have made couple of observation though, that before the
>> invalid sector 18446744073709551615 is sent, the sector 1000182866 is
>> accessed after which mdraid reports as not clean starts background
>> reconstruction. I read the LBA 1000182866 and this block contains FF.
>> So is md expecting something in the metadata we are not populating ?
>> Please find the attached md127.txt which is the output of the mdadm
>> --examine <container>, blk-core_diff.txt which contains the printk's
>> and dmesg.txt, also DDF_Header0.txt and DDF_Header1.txt are the dump
>> of ddf headers for both the disks.
>
> Thanks for providing more details.
>
> Sector 1000182866 is 256 sectors into the config section.
> It starts reading the config section at 1000182610 and gets 256 sectors,
> so it reads the rest from 1000182866 and then starts the array.
>
> My guess is that md is getting confused about resync and recovery.
> It tries a resync, but as the array appears degraded, this code:
>                 if (test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery))
>                         j = mddev->resync_min;
>                 else if (!mddev->bitmap)
>                         j = mddev->recovery_cp;
>
> in md_do_sync() sets 'j' to MaxSector, which is effectively "-1".  It
> then starts resync from there and goes crazy.  You could put a printk in
> there to confirm.
>
> I don't know why.  Something about the config makes mdadm think the
> array is degraded.  I might try to find time to dig into it again later.
>
> NeilBrown
