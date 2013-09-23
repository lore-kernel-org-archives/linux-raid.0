From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: mke2fs with discard option breaks RAID5 array
Date: Mon, 23 Sep 2013 12:38:37 -0700
Message-ID: <CAA9_cmepA3qd7HaEMpx0fhjr+M=O8w9Fikpx5WwzGLVA2Zyjzg@mail.gmail.com>
References: <5234BDFE.7050700@arcor.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5234BDFE.7050700@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: Martin Wilck <mwilck@arcor.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sat, Sep 14, 2013 at 12:50 PM, Martin Wilck <mwilck@arcor.de> wrote:
> I just had the following weird effect under OpenSUSE 12.3, kernel
> 3.7.10-1.16. I am wondering if it's a known problem.
>
> Creating a RAID5 array (format doesn't seem to matter) either with the
> openSUSE native mdadm 3.2.6 or mdadm 3.3, and running mke2fs on it,
> fails. The RAID array is broken after that, all disks faulty, any IO fails.
>
> Further examination shows that the problem is related to mke2fs trying
> to discard blocks. Running "-E nodiscard" or setting "discard=no" in
> mke2fs.conf fixes the problem. Unfortnately, "discard" seems to be the
> default.
>
> Details under https://bugzilla.novell.com/show_bug.cgi?id=840413
>
> Has anyone seen this before?

This sounds like the issue addressed by:

66c28f9 [SCSI] sd: Update WRITE SAME heuristics
5026d7a md/raid1,5,10: Disable WRITE SAME until a recovery strategy is in place
