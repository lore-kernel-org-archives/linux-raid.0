From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: what superblock to use
Date: Tue, 21 Apr 2009 10:31:07 -0700
Message-ID: <49EE02DB.6020407@zytor.com>
References: <49EC7B22.8070805@lfarkas.org> <slrngup0vb.90j.Mario.Holbe@darkside.dyn.samba-tng.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <slrngup0vb.90j.Mario.Holbe@darkside.dyn.samba-tng.org>
Sender: linux-raid-owner@vger.kernel.org
To: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mario 'BitKoenig' Holbe wrote:
> Farkas Levente <lfarkas@lfarkas.org> wrote:
>> anyway is there any advantage of a raid6 over raid5+1spare disk? afaik
>> raid5 will be faster and use less cpu and both case 2 disk can failed.
> 
> No, raid6 survives the simultaneous failure of two disks.
> Raid5 survives the simultaneous failure of one disk only. Even with a
> hot-spare, after this failure you have a time frame where the spare is
> synching and your array has no redundancy left. Thus, nearly every other
> disk failure (except a failure on the synching spare) within this time
> frame kills your array.
> 

It's worth noting that a failure mode that is getting increasingly
frequently reported is the failure of a drive *during sync*.  I suspect
that the cause is that synchronization puts different stresses on the
drives than normal operation.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

