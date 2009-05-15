From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: RAID4 and RAID5 Code
Date: Fri, 15 May 2009 09:08:36 -0700
Message-ID: <4A0D9384.1020805@zytor.com>
References: <37d33d830905140957q6e180d89v4cd4a21d23471481@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <37d33d830905140957q6e180d89v4cd4a21d23471481@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: SandeepKsinha <sandeepksinha@gmail.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

SandeepKsinha wrote:
> Hi all,
> 
> Looks like we have the same code for RAID 4 and RAID 5, I could see
> the same make_request for both.
> 
> Can someone point me in the code, where exactly we differentiate
> between these two. i.e updating checksum block, etc.
> 

RAID 4 is really nothing but a block layout algorithm for RAID 5 (which
has four more block layout algorithms.)  RAID 6 contains all five under
one "level".

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

