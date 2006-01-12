From: Neil Brown <neilb@suse.de>
Subject: Re: mdadm-2.2 typo
Date: Thu, 12 Jan 2006 21:12:00 +1100
Message-ID: <17350.11120.170888.812103@cse.unsw.edu.au>
References: <cfac95650601030848g3c4aa3b9h77b4dfa0ca2d2e2d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Roger Willcocks on Tuesday January 3
Sender: linux-raid-owner@vger.kernel.org
To: Roger Willcocks <willcor@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday January 3, willcor@gmail.com wrote:
> mdadm-2.2/super1.c line 384:
> 
>         if (strcmp(update, "uuid") == 0)
>                 memcmp(sb->set_uuid, info->uuid, 16);
> 
> should probably be memcpy

:-(

Thanks!!

NeilBrown
