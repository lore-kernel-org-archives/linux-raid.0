From: Neil Brown <neilb@suse.de>
Subject: Re: Linux/MacOSX RAID5 dual boot
Date: Fri, 9 Jul 2010 20:22:21 +1000
Message-ID: <20100709202221.31ea30a7@notabene.brown>
References: <AAF65F6E-E855-4E37-A66D-9FC39D0E02F7@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AAF65F6E-E855-4E37-A66D-9FC39D0E02F7@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Marek <mlf.conv@gmail.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, 9 Jul 2010 12:07:56 +0200
Marek <mlf.conv@gmail.com> wrote:

> Hi,
> 
> it seems that my email has hit top 5 ranking on google when searching  
> for "mdadm macosx", but it seems that due to some heavy discussion on  
> this mailing list it probably went unnoticed.
> I would like to ask if someone would be able to elaborate whether  
> there is a possibility that mdadm would run on Darwin and if so,  
> whether a port would require a substantial rewrite.

mdadm would not run on Darwin.  It only works with the 'md' driver which is
only in Linux.

If you want both Linux and Darwin to be able to access the same software RAID
array, you would need to find a format that both understand.
Probably the easiest way would be do discover how MAC OSX formats RAID array
and write support for that in mdadm.  Far from trivial, but probably possible.

A quick google suggest that RAID5 is not supported in OSX, so that would not
be an option.

NeilBrown
