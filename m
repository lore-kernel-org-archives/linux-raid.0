From: Xiao Ni <xni@redhat.com>
Subject: Re: [PATCH 0/4] RFC: attempt to remove md deadlocks with metadata
 without
Date: Mon, 11 Sep 2017 22:51:51 -0400 (EDT)
Message-ID: <296444241.9937022.1505184711007.JavaMail.zimbra@redhat.com>
References: <150518076229.32691.13542756562323866921.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <150518076229.32691.13542756562323866921.stgit@noble>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



----- Original Message -----
> From: "NeilBrown" <neilb@suse.com>
> To: "Xiao Ni" <xni@redhat.com>
> Cc: linux-raid@vger.kernel.org
> Sent: Tuesday, September 12, 2017 9:49:12 AM
> Subject: [PATCH 0/4] RFC: attempt to remove md deadlocks with metadata without
> 
> Hi,
>  I looked again at the previous patch I posted which tried to mak
>  md_update_sb() safe without taking reconfig_mutex, and realized that
>  it had serious problems, particularly around devices being added or
>  removed while the update was happening.
> 
>  So I decided to try a different approach, which is embodied in these
>  patches.  The md thread is now explicitly allowed to call
>  md_update_sb() while some other thread holds the lock and
>  waits for mddev_suspend() to complete.
> 
>  Please test these and confirm that they still address the problem you
>  found.

Hi Neil

Thanks for the patches. I'll update the test result. 

Regards
Xiao

