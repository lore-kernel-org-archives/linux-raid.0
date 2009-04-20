From: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Subject: Re: what superblock to use
Date: Mon, 20 Apr 2009 16:17:15 +0200
Message-ID: <slrngup0vb.90j.Mario.Holbe@darkside.dyn.samba-tng.org>
References: <49EC7B22.8070805@lfarkas.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Farkas Levente <lfarkas@lfarkas.org> wrote:
> anyway is there any advantage of a raid6 over raid5+1spare disk? afaik
> raid5 will be faster and use less cpu and both case 2 disk can failed.

No, raid6 survives the simultaneous failure of two disks.
Raid5 survives the simultaneous failure of one disk only. Even with a
hot-spare, after this failure you have a time frame where the spare is
synching and your array has no redundancy left. Thus, nearly every other
disk failure (except a failure on the synching spare) within this time
frame kills your array.


regards
   Mario
-- 
There are two major products that come from Berkeley: LSD and UNIX.
We don't believe this to be a coincidence.    -- Jeremy S. Anderson

