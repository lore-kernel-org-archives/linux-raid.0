From: "David Rees" <drees76@gmail.com>
Subject: Re: Large single raid and XFS or two small ones and EXT3?
Date: Sun, 25 Jun 2006 12:13:51 -0700
Message-ID: <72dbd3150606251213xfaba054if76348f15c779706@mail.gmail.com>
References: <449AEB7C.6040108@cjx.com> <op.tblclqd3cigqcu@apollo13>
	 <87r71fk613.fsf@hades.wkstn.nix>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87r71fk613.fsf@hades.wkstn.nix>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Nix <nix@esperi.org.uk>
Cc: PFC <lists@peufeu.com>, Chris Allen <chris@cjx.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 6/23/06, Nix <nix@esperi.org.uk> wrote:
> On 23 Jun 2006, PFC suggested tentatively:
> >       - ext3 is slow if you have many files in one directory, but has
> >       more mature tools (resize, recovery etc)
>
> This is much less true if you turn on the dir_index feature.

However, even with dir_index, deleting large files is still much
slower with ext2/3 than xfs or jfs.

-Dave
