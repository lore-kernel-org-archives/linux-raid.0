From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: [RFE] Please, add optional RAID1 feature (= chunk checksums)
 to make it more robust
Date: Fri, 27 Jul 2012 16:06:02 +1000
Message-ID: <50122FCA.3070304@websitemanagers.com.au>
References: <500CD32E.4000800@hardwarefreak.com> <542194327.593466.1343036057599.JavaMail.root@redhat.com> <20120723170320.GA2691@lazy.lzy> <CABYL=Tq0w150QMcehdsScUfDfCD2tGFeuROjWjwsepy1rRXk_w@mail.gmail.com> <CACJz6Qu6qVAroTTZJL=Q_Gs5VRsn=VttaKMu0WOKCh2sdJdgqQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CACJz6Qu6qVAroTTZJL=Q_Gs5VRsn=VttaKMu0WOKCh2sdJdgqQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 24/07/12 07:31, Drew wrote:
> Been mulling this problem over and I keep getting hung up on one
> problem with ECC on a two disk RAID1 setup.
>
> In the event of silent corruption of one disk, which one is the good
> copy?
>
> It works fine if the ECC code is identical across both mirrors. Just
> checksum both chunks and discard the incorrect one.
>
> It also works fine if the ECC codes are corrupted but the data
> chunks are identical. Discard the bad checksum.
>
> What if the corruption goes across several sectors and both data &
> ECC chuncks are corrupted? Now you're back to square one.

I know I'm a bit late to this discussion, and I know very little about
the code level/etc... however, I thought the whole point of the checksum
is to determine that the data + checksum do not match, therefore the
data is wrong and should be discarded. You would re-write the data and
checksum from another source (ie, the other drive in RAID1, or other
drives in RAID5/6 etc...).

ie, it should be treated the same as a bad block / non-readable sector
(or lots of unreadable sectors....)

Regards,
Adam


-- 
Adam Goryachev
Website Managers
www.websitemanagers.com.au


