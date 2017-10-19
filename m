From: =?UTF-8?Q?Bj=C3=B8rnar_Ness?= <bjornar.ness@gmail.com>
Subject: mdadm segfault with incremental
Date: Thu, 19 Oct 2017 13:24:17 +0200
Message-ID: <CAJO99Tk=at4gXNgEHKmq1=iDip+vt2LT-T8d+FSQYGJquH5C2g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

While working with mdadm policy/udev to add slaves when they are
inserted, I notices
mdadm is segfaulting if it gets a blank drive and action is set to
spare or above.

Looking into the code, this segfault is caused by the following code:

Incremental.c line 965

                     st2->ss->avail_size(st2, devsize,
                                         sra->devs
                                         ? sra->devs->data_offset
                                         : INVALID_SECTORS)

avail_size in my case is super1.c avail_size1

and here the code sets:

struct mdp_superblock_1 *super = st->sb;

and later tries accessing i.e super->feature_map, where it segfaults
because in the case
of an empty drive, st2 is created in super1.c/match_metadata_desc1
where it sets:

        st->sb = NULL;

I am not entirely sure how this is supposed to work, but atleast
currently it segfaults.

-- 
Bj(/)rnar
